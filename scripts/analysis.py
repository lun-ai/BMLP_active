import matplotlib.pyplot as plt
import matplotlib.transforms as pltrans
import matplotlib.colors as mcolors
import os
import json
import numpy as np
import re
import seaborn as sns

curve_legends = {
    "ase": r'$BMLP_{active}$',
    "rand": r'$Random \, sampling$'
}

colors = ['#4A7298', '#F3C846', '#D2D3D3']


def compare_methods_fixed_itr(Json_Paths, xname, yname, xticks=None, target_path=""):
    method = []
    acc = []
    cost = []
    steps = []
    for Json_Path in Json_Paths:
        for f in os.listdir(Json_Path):
            if '.json' in f:
                file = open(Json_Path + f)
                data = json.load(file)
                if data['method'] not in method:
                    method.append(data['method'])
                    acc.append(data['accuracy'])
                    cost.append(data['cost'])
                    steps.append(data['stepsizes'])
                else:
                    for i in range(0, len(method)):
                        current_step = data['stepsizes']
                        if method[i] == data['method']:
                            for j in range(0, len(current_step)):
                                if len(steps[i]) > j and current_step[j] in steps[i]:
                                    k = steps[i].index(current_step[j])
                                    acc[i][k] += data['accuracy'][j]
                                    cost[i][k] += data['cost'][j]
                                else:
                                    steps[i].append(current_step[j])
                                    acc[i].append(data['accuracy'][j])
                                    cost[i].append(data['cost'][j])

    acc_temp = []
    cost_temp = []
    steps_temp = []
    for i in range(0, len(method)):
        sorted_steps = sorted(steps[i])
        acc_temp.append([])
        cost_temp.append([])
        steps_temp.append(sorted_steps)
        for k in range(0, len(sorted_steps)):
            j = steps[i].index(sorted_steps[k])
            acc_temp[i].append(acc[i][j])
            cost_temp[i].append(cost[i][j])

    acc = acc_temp
    cost = cost_temp
    # steps = np.log2(steps_temp)
    steps = steps_temp
    accs = []
    costs = []
    labels = list(sorted(dict.fromkeys(method)))
    for u in labels:
        acc_u = np.array(flatten_res(method, u, acc)) * 100
        if len(acc_u) > 0:
            accs.append(acc_u)
            costs.append(np.array(flatten_res(method, u, cost)) / 1)

    mean_plot("accuracy.png", steps, accs, labels,
              xname, yname, xticks=xticks, target_path=target_path)


def compare_methods_fixed_itr_error_bound(Json_Path, target_path=""):
    # Stores {stepsize: [all_accuracies_for_this_step_from_all_ase_files]}
    ase_step_data = {}
    # Stores {stepsize: [all_accuracies_for_this_step_from_all_rand_files]}
    rand_step_data = {}

    for f_name in os.listdir(Json_Path):
        if f_name.endswith('.json'):
            file_path = os.path.join(Json_Path, f_name)
            try:
                with open(file_path, 'r') as f:
                    data = json.load(f)

                method_type = data.get('method')
                stepsizes = data.get('stepsizes')
                accuracies_per_step = data.get(
                    'accuracy')  # This is a list of lists

                if not all([method_type, stepsizes, accuracies_per_step]):
                    print(f"Skipping file {f_name} due to missing data.")
                    continue

                target_data_dict = None
                if f_name.startswith('ase_') and method_type == 'ase':
                    target_data_dict = ase_step_data
                elif f_name.startswith('rand_') and method_type == 'rand':
                    target_data_dict = rand_step_data

                if target_data_dict is not None:
                    for i, step in enumerate(stepsizes):
                        if i < len(accuracies_per_step):
                            acc_list_for_this_step_this_file = accuracies_per_step[i]
                            if step not in target_data_dict:
                                target_data_dict[step] = []
                            target_data_dict[step].extend(
                                acc_list_for_this_step_this_file)
            except Exception as e:
                print(f"Error processing file {f_name}: {e}")
                continue

    ase_avg_accuracies = {step: np.mean(
        accs) * 100 for step, accs in ase_step_data.items() if accs}
    rand_avg_accuracies = {step: np.mean(
        accs) * 100 for step, accs in rand_step_data.items() if accs}

    fig = plt.figure(figsize=(16, 8))

    # the minimum reduction ratio is 0.0053763
    phi = 0.538

    # ASE data processing
    desired_ase_steps = [1, 2, 3, 4, 5]
    ase_acc_for_err_calc = [ase_avg_accuracies[s]
                            for s in desired_ase_steps if s in ase_avg_accuracies]
    ase_trial_count_for_ratio = [
        s for s in desired_ase_steps if s in ase_avg_accuracies]

    ase_err = []
    ase_ratio = []
    if ase_acc_for_err_calc and ase_trial_count_for_ratio:
        ase_err = [100 - acc for acc in ase_acc_for_err_calc]
        ase_ratio = [err / count for err,
                     count in zip(ase_err, ase_trial_count_for_ratio) if count > 0]

    # RAND data processing
    desired_rand_steps = [1, 2, 3, 4, 5, 10, 15, 20, 25, 30]
    rand_acc_for_err_calc = [rand_avg_accuracies[s]
                             for s in desired_rand_steps if s in rand_avg_accuracies]
    rand_trial_count_for_ratio = [
        s for s in desired_rand_steps if s in rand_avg_accuracies]

    rand_err = []
    rand_ratio = []
    if rand_acc_for_err_calc and rand_trial_count_for_ratio:
        rand_err = [100 - acc for acc in rand_acc_for_err_calc]
        rand_ratio = [(err + phi) / count for err, count in zip(rand_err,
                                                                rand_trial_count_for_ratio) if count > 0]

    if ase_err and ase_ratio:
        plt.errorbar(ase_err, ase_ratio, label=r'$\frac{\epsilon}{s_{active}}$', ls='--', marker='^',
                     elinewidth=0.1, capsize=0,
                     linewidth=3,
                     color=colors[0], ms=15, mew=2)

    if rand_err and rand_ratio:
        plt.errorbar(rand_err, rand_ratio, label=r'$\frac{\epsilon + \phi}{s_{passive}}$', ls='--', marker='^',
                     elinewidth=0.1, capsize=0,
                     linewidth=3,
                     color=colors[1], ms=15, mew=2)
    # plt.fill_between(x_data[i], u[i] - std[i], u[i] + std[i], color=colors[i], alpha=0.1)

    # plt.hlines(xmin=65, xmax=-2, y=50.03001200480193, colors="r", linestyles='dashed', label="rand_pred")

    plt.ylabel('Ratio Between Predictive Error and Sample Complexity', fontsize=18)
    plt.xlabel(r'Predictive Error $\epsilon$ (%)', fontsize=20)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)

    # plt.xlim(left=np.min(x_data) - 1, right=np.max(x_data) + 1)
    # plt.ylim(bottom=min(np.min(u) - 0.5, np.min(u) - np.max(std)))
    plt.legend(loc='upper left', fontsize=30)
    plt.tight_layout()

    if target_path:
        plt.savefig(os.path.join(target_path, 'error_ratio.png'))


def compare_methods_fixed_cost(Json_Path):
    method = []
    steps = []
    acc = []
    cost = []
    for f in sorted(os.listdir(Json_Path)):
        if '.json' in f and ('ase' in f or 'rand' in f):
            file = open(Json_Path + f)
            data = json.load(file)
            method.append(curve_legends[data['method']])
            steps.append(data['totalCost'])
            acc.append(data['accuracy'])
            cost.append([[np.log10(max(1, c)) for c in u]
                        for u in data['cost']])

    accs = []
    costs = []
    for u in sorted(list(dict.fromkeys(method))):
        acc_u = np.array(flatten_res(method, u, acc)) * 100
        if len(acc_u) > 0:
            accs.append(acc_u)
            costs.append(
                np.mean(np.array(flatten_res(method, u, cost)) / 1, axis=1))

    mean_plot_rotate(Json_Path + "accuracy_cost.png", accs,
                     # steps,
                     costs,
                     sorted(list(dict.fromkeys(method))),
                     "Predictive Accuracy (%)",
                     # "Sum of Unit Chemical Cost")
                     r"Total Experiment Resource Cost in $log_{10}$", xlim=10)
    # "Average No. medium variations")


# sort res by methods
def flatten_res(method, m, l):
    l_all = [l[i] for i in range(0, len(method)) if method[i] == m]
    res = []
    if l_all:
        for i in range(0, len(l_all[0])):
            flatten_acc = []
            for j in range(0, len(l_all)):
                flatten_acc += l_all[j][i]
            res.append(flatten_acc)

    return res


def calc_stats(raw):
    u = np.mean(raw, axis=1)
    std = np.std(raw, axis=1)
    return u, std


def mean_plot(fig_name, x_data, y_data, legends, xlabel, ylabel, marker='^', xticks=None, target_path=""):
    u = []
    std = []
    for d in y_data:
        d_u, d_std = calc_stats(d)
        u.append(d_u)
        std.append(d_std / np.sqrt(len(d)))

    fig = plt.figure(figsize=(16, 8))
    plt.rc('font', size=15)

    for i in range(0, len(u)):
        plt.errorbar(x_data[i], u[i], yerr=std[i], label=curve_legends[legends[i]], ls='--', marker=marker,
                     elinewidth=0.1, capsize=0,
                     linewidth=3,
                     color=colors[i], ms=15, mew=2)
        plt.fill_between(x_data[i], u[i] - std[i],
                         u[i] + std[i], color=colors[i], alpha=0.2)
        print("# method: %s, accuracy: %s, No. experiments %s" %
              (legends[i], u[i], x_data[i]))

    # plt.hlines(xmin=65, xmax=-2, y=50.03001200480193, colors="r", linestyles='dashed', label="rand_pred")

    plt.xlabel(xlabel, fontsize=20)
    plt.ylabel(ylabel, fontsize=20)
    if not xticks:
        plt.xticks([round(j, 1) for i in x_data for j in i])
    else:
        plt.xticks(xticks)

    # plt.xlim(left=np.min(x_data) - 1, right=np.max(x_data) + 1)
    # plt.ylim(bottom=min(np.min(u) - 0.5, np.min(u) - np.max(std)))
    plt.legend(loc='center right', fontsize=20)
    plt.tight_layout()

    if target_path:
        os.path.join(target_path, fig_name)


def t(epsilon, x):
    return np.log(epsilon) / np.log(x)


def sample_partition_analysis(fig_path):
    x_data = np.linspace(0.8, 0.999, 500)

    fig = plt.figure(figsize=(16, 9))

    plt.plot(x_data, t(0.01, x_data),
             color=colors[0], label=r'$\epsilon$' + '=0.01')
    plt.plot(x_data, t(0.05, x_data),
             color=colors[1], label=r'$\epsilon$' + '=0.05')
    # plt.plot(x_data, t(0.1, x_data), color=colors[2], label=r'$\epsilon$' + '=0.1')

    idx = np.argwhere(np.diff(np.sign(x_data - (455 - 6) / 455))).flatten()
    plt.vlines(x=x_data[idx], ymin=0, ymax=t(0.01, x_data)
               [idx], colors="r", linestyles='dashed')
    plt.hlines(xmin=0.8, xmax=x_data[idx], y=t(0.01, x_data)[
               idx], colors="r", linestyles='dashed')
    plt.text(0.8, t(0.01, x_data)[idx] + 10,
             str(int(np.ceil(t(0.01, x_data)[idx][0]))))
    plt.hlines(xmin=0.8, xmax=x_data[idx], y=t(0.05, x_data)[
               idx], colors="r", linestyles='dashed')
    plt.text(0.8, t(0.05, x_data)[idx] + 10,
             str(int(np.ceil(t(0.05, x_data)[idx][0]))))
    # plt.hlines(xmin=0.8, xmax=x_data[idx], y=t(0.1, x_data)[idx], colors="r", linestyles='dashed')
    # plt.text(0.8, t(0.1, x_data)[idx] + 10, str(int(np.ceil(t(0.1, x_data)[idx][0]))))

    plt.xlabel('Probability of selecting an uninformative experiment p')
    plt.ylabel('Size of candidate experiments |T|')
    plt.legend(loc='upper left')
    plt.ylim(top=500, bottom=0)
    plt.xlim(left=0.8)
    plt.savefig("candidate_trial_size.png")
    # plt.show()


def lb(n, phi, epsilon, delta, h_size):
    m = phi * n
    # m = (1 - phi) ** n
    print(m)
    m1 = 1 / (epsilon + m)
    m2 = m1 * (np.log(1 / delta) + np.log(h_size))

    return m2


def sample_complexity_analysis(fig_path):
    x_size = 4000
    h_size = 1000
    epsilon = 0.05
    delta = 0.05
    # rands = np.random.randint(0, 51, size=x_size, dtype=int) / 100
    ns = [1, 10, 20, 40, 80, 200]
    ps = [0.001, 0.01, 0.1, 0.2, 0.3, 0.5]

    fig = plt.figure()
    plt.xticks(ns)
    for j in ps:
        ms = []
        for i in ns:
            # pj = len([x for x in rands if x >= j]) / x_size
            ms.append(lb(i, j, epsilon, delta, h_size))
        plt.plot(ns, ms, label=r'$\phi$=' + str(j))
    plt.ylabel('No. experiments')
    plt.xlabel(r'N')
    plt.ylim(bottom=0)
    plt.legend()
    plt.savefig("sample_complexity.png")


def mean_plot_rotate(fig_path, x_data, y_data, legends, xlabel, ylabel, xlim=0):
    u = []
    ste = []
    for d in x_data:
        d_u, d_std = calc_stats(d)
        u.append(d_u)
        ste.append(d_std / np.sqrt(len(d)))

    if len(y_data) == 0:
        y_axis = range(1, len(u[0]) + 1)
    else:
        y_axis = y_data

    fig, ax1 = plt.subplots()

    for i in range(0, len(u)):
        plt.errorbar(u[i], y_axis[i], xerr=ste[i], label=legends[i], elinewidth=0, capsize=0, ls='--', marker='^',
                     color=colors[i], linewidth=2)
        for j in range(0, len(u[i])):
            if u[i][j] == 100.0:
                plt.axhline(y_axis[i][j], color=colors[-1], ls='-.')
                plt.text(20, y_axis[i][j] + 0.1, round(y_axis[i][j], 2))
                break
        plt.fill_betweenx(y_axis[i], u[i] - ste[i],
                          u[i] + ste[i], color=colors[i], alpha=0.2)

    ax1.set_xlabel(xlabel, fontsize=10)
    ax1.set_ylabel(ylabel, fontsize=10)
    # ax1.yaxis.tick_right()
    # ax1.yaxis.set_label_position("right")
    plt.tight_layout(pad=2)
    plt.xlim(left=xlim)
    plt.legend(loc='upper center', fontsize=10)
    plt.savefig(fig_path)
    # plt.show()


# Helper function to parse the prolog label files
def _parse_prolog_labels(file_path):
    labels = {}
    try:
        with open(file_path, 'r') as f:
            for line_content in f:
                line = line_content.replace("\n", "").replace(" ", "")
                if not line:
                    continue

                # Check for "label(...)" or "l(...)" structure
                if (line.startswith("label(") or line.startswith("l(")) and line.endswith(")."):
                    # Extract content within the outermost parentheses
                    # e.g., from "label(term,value)" to "term,value"
                    content_start_index = line.find('(') + 1
                    content_end_index = -2
                    content = line[content_start_index:content_end_index]

                    # Split by the last comma to separate term and value
                    term_part, separator, value_part = content.rpartition(',')

                    if separator:  # Ensure a comma was found
                        term = term_part.strip()
                        value_str = value_part.strip()
                        try:
                            value = int(value_str)
                            labels[term] = value
                        except ValueError:
                            print(
                                f"Warning: Could not convert value '{value_str}' to int in line: {line_content.strip()}")
                    else:
                        print(
                            f"Warning: Could not parse term and value from line: {line_content.strip()}")

    except FileNotFoundError:
        print(f"Error: File not found {file_path}")
        return None
    except Exception as e:
        print(f"Error parsing file {file_path}: {e}")
        return None
    print(f"Parsed {len(labels)} labels from {file_path}")
    return labels


# Helper function to calculate TP, TN, FP, FN
def _get_confusion_matrix_values(trial_labels_filepath=None, predictions_filepath=None, results=None):
    if trial_labels_filepath and predictions_filepath:
        # Relies on _parse_prolog_labels being in scope
        true_labels_data = _parse_prolog_labels(trial_labels_filepath)
        predicted_labels_data = _parse_prolog_labels(predictions_filepath)

        if true_labels_data is None or predicted_labels_data is None:
            # _parse_prolog_labels prints errors, so just return None
            return None

        TP, TN, FP, FN = 0, 0, 0, 0
        for key, true_label in true_labels_data.items():
            if key in predicted_labels_data:
                predicted_label = predicted_labels_data[key]
                if true_label == 1 and predicted_label == 1:
                    TP += 1
                elif true_label == 0 and predicted_label == 0:
                    TN += 1
                elif true_label == 0 and predicted_label == 1:
                    FP += 1
                elif true_label == 1 and predicted_label == 0:
                    FN += 1
        return TP, TN, FP, FN
    elif results is not None:
        if isinstance(results, (list, tuple)) and len(results) == 4:
            # Ensure all elements are integers
            if all(isinstance(x, int) for x in results):
                return tuple(results)
            else:
                print(
                    "Invalid results provided. Expected four integers: [TP, TN, FP, FN].")
                return None
        else:
            print("Invalid results format. Expected a list/tuple of four integers.")
            return None
    else:
        # This case should ideally be caught by the caller ensuring one set of params is given
        print(
            "Insufficient data: Provide either filepaths or results for confusion matrix.")
        return None

# Helper function to plot a single confusion matrix on a given Axes


def _plot_single_cm(ax, TP, TN, FP, FN, title, cbar=False):
    total_samples = TP + TN + FP + FN

    annot_font_size = 16  # Define a variable for annotation font size

    if total_samples == 0:
        print(
            f"Warning: Total samples is zero for '{title}'. Plotting raw counts.")
        # For annotation, use the raw counts in the FP, TN, TP, FN order matching the array structure
        annot_values = np.array([[FP, TN], [TP, FN]])
        # For the heatmap itself, use a zero array as there's no normalization
        display_array = np.array([[0.0, 0.0], [0.0, 0.0]])
        sns.heatmap(display_array, annot=annot_values,
                    # Added annot_kws
                    fmt='d', cmap='Blues', cbar=cbar, ax=ax, annot_kws={"size": annot_font_size})
    else:
        TP_norm = TP / total_samples
        TN_norm = TN / total_samples
        FP_norm = FP / total_samples
        FN_norm = FN / total_samples
        cm_array_norm = np.array([[FP_norm, TN_norm], [TP_norm, FN_norm]])
        sns.heatmap(cm_array_norm, annot=True, fmt='.3f',
                    # Added annot_kws
                    cmap='Blues', cbar=cbar, ax=ax, annot_kws={"size": annot_font_size})

    ax.set_xlabel(title, fontsize=annot_font_size)
    ax.set_ylabel('Experimental data', fontsize=annot_font_size)
    ax.set_xticklabels(['Phenotype', 'No phenotype'], fontsize=annot_font_size)
    ax.set_yticklabels(['No phenotype', 'Phenotype'],
                       rotation='vertical', va='center', fontsize=annot_font_size)


def confusion_m(output_path="",
                results1=None, trial_labels_filepath1=None, predictions_filepath1=None,
                results2=None, trial_labels_filepath2=None, predictions_filepath2=None,
                titles=("Confusion Matrix 1", "Confusion Matrix 2")):
    """
    Plots two confusion matrices side-by-side in a single figure.

    Each matrix's data can be sourced from:
    1. Prolog files: via `trial_labels_filepath1`/`2` and `predictions_filepath1`/`2`.
    2. Direct results: via `results1`/`2` as a list/tuple `[TP, TN, FP, FN]`.

    The function saves the combined figure if `output_path` is provided and
    returns the matplotlib figure object.

    Args:
        output_path (str, optional): Path to save the figure. If a directory,
            'cm_combined.png' is used as filename. Defaults to "".
        results1 (list/tuple, optional): [TP, TN, FP, FN] for the first matrix.
        trial_labels_filepath1 (str, optional): Path to true labels for the first matrix.
        predictions_filepath1 (str, optional): Path to predicted labels for the first matrix.
        results2 (list/tuple, optional): [TP, TN, FP, FN] for the second matrix.
        trial_labels_filepath2 (str, optional): Path to true labels for the second matrix.
        predictions_filepath2 (str, optional): Path to predicted labels for the second matrix.
        titles (tuple, optional): Titles for the two subplots.
            Defaults to ("Confusion Matrix 1", "Confusion Matrix 2").

    Returns:
        matplotlib.figure.Figure or None: The figure object, or None if data retrieval fails for both.
                                         If one fails, it attempts to plot the other.
    """
    cm_data1 = _get_confusion_matrix_values(
        trial_labels_filepath=trial_labels_filepath1,
        predictions_filepath=predictions_filepath1,
        results=results1
    )

    cm_data2 = _get_confusion_matrix_values(
        trial_labels_filepath=trial_labels_filepath2,
        predictions_filepath=predictions_filepath2,
        results=results2
    )

    if cm_data1 is None and cm_data2 is None:
        print(
            f"Error: Could not retrieve data for the first confusion matrix ({titles[0]}).")
        print(
            f"Error: Could not retrieve data for the second confusion matrix ({titles[1]}).")
        print("Cannot generate any plot as data for both matrices is missing.")
        return None

    num_plots = 0
    if cm_data1 is not None:
        num_plots += 1
    if cm_data2 is not None:
        num_plots += 1

    if num_plots == 0:  # Should be caught by above, but as a safeguard
        print("No data available for plotting.")
        return None

    fig, axes = plt.subplots(1, num_plots, figsize=(
        6.5 * num_plots, 6))  # Adjust figsize dynamically

    current_ax_idx = 0
    if cm_data1 is not None:
        ax_to_plot = axes[current_ax_idx] if num_plots > 1 else axes
        _plot_single_cm(ax_to_plot, *cm_data1, titles[0])
        current_ax_idx += 1
    else:
        print(
            f"Skipping plot for first confusion matrix ({titles[0]}) due to missing data.")

    if cm_data2 is not None:
        ax_to_plot = axes[current_ax_idx] if num_plots > 1 and current_ax_idx < len(
            axes) else axes  # handle single plot case if only cm_data2 is valid
        if num_plots == 1 and cm_data1 is None:  # If only cm_data2 is plotted, axes is not an array
            ax_to_plot = axes
        _plot_single_cm(ax_to_plot, *cm_data2, titles[1], cbar=True)
    else:
        print(
            f"Skipping plot for second confusion matrix ({titles[1]}) due to missing data.")

    plt.show()
    plt.tight_layout()

    if output_path:
        save_filename = "cm_combined.png"
        if os.path.isdir(output_path):
            save_filename = os.path.join(output_path, save_filename)
        else:  # Assume output_path is a full file path
            save_filename = output_path
            output_dir = os.path.dirname(save_filename)
            # Ensure directory exists if full path is given and output_dir is not an empty string (e.g. for files in root)
            if output_dir and not os.path.exists(output_dir):
                os.makedirs(output_dir)

        try:
            fig.savefig(save_filename)
            print(f"Confusion matrix figure saved to {save_filename}")
        except Exception as e:
            print(f"Error saving confusion matrix figure: {e}")

    # return fig
