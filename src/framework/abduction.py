import subprocess
import sys
import os
import argparse
from datetime import datetime


def arg_dict(arg):
    arg_vars = vars(arg)
    prolog_dict = []
    for key, value in arg_vars.items():
        if value is not None:
            item = str(value).lower()
            if isinstance(value, str) and "/" in value:
                item = "'" + item + "'"
            prolog_dict.append(str(key) + "=" + item)
    return "[" + ",".join(prolog_dict) + "]"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", help="selection method of experiments")
    ap.add_argument("app", help="definition source directory")
    ap.add_argument("--id", help="user-defined abduction run id")
    ap.add_argument(
        "--use_output", help="use a pre-generated classification matrix")
    ap.add_argument("--lazy", default=False, action="store_true",
                    help="perform lazy active learning")
    ap.add_argument("--matrix", default=False, action="store_true",
                    help="compute classification matrix")
    ap.add_argument("--rep", default=10,
                    help="the number of repeats for each selection iteration, default is 10")
    ap.add_argument("--iter", default=6,
                    help="the max number fo selection iterations")
    ap.add_argument(
        "--steps", help="max selection iteration increases by defined step size")
    ap.add_argument("--costf", default="material", help="cost function")
    ap.add_argument(
        "--costCap", default=[1000000], help="cost limits while selecting experiments")
    ap.add_argument("--single_gene",
                    help="e.g. b0002 or equivalent in the model")
    ap.add_argument("--trial_partition_size", default=4000,
                    help="the size of instance subset to select from")

    args = ap.parse_args()
    opt_args = arg_dict(args)

    if not args.id:
        rid = datetime.now().strftime("%m_%d_%Y_%H:%M:%S")
    else:
        rid = args.id

    # set up the temp file directory and filenames
    app = args.app
    mode = args.mode
    temp_path = "results/abd_" + \
        str(rid) if not args.use_output else "results/abd_" + \
        str(rid) + "_selection"
    info = "%%%% Source: " + app + ", Mode: " + \
        mode + ", ID: " + str(rid) + " %%%%"
    log_path = temp_path + "/abduction.log"
    dependency = app + "/dependency.pl"
    abd_path = temp_path + "/abducibles.pl"
    ex_path = temp_path + "/examples.pl"
    cm_path = temp_path + "/cm.pl"
    matrix_batch_size = 1000

    rep = args.rep
    abd_iter = args.iter
    steps = args.steps

    subprocess.run(["mkdir", "-p", "results"])
    subprocess.run(["mkdir", "-p", temp_path])

    log_file = open(log_path, "w")
    print(info, file=log_file)

    addition_args = []

    if args.single_gene:
        addition_args.append(["gene", args.single_gene])

    # subprocess.run(["rm -f experiments/iML1515/abduction/temp/*"], shell=True)
    subprocess.run(["rm -f mstate* tmstate*"], shell=True)

    if not args.use_output:
        # sample examples and create a new folder for experiment results
        trials_gen = ["swipl", "-s", app + "/sample.pl", "-q", "-t",
                      "generate_abduction_trials(" + str(addition_args) + ",'" + ex_path + "')"]
        abd_gen = ["swipl", "-s", app + "/sample.pl", "-q", "-t",
                   "generate_abds(" + str(addition_args) + ",'" + abd_path + "')"]
        subprocess.run(trials_gen, stdout=log_file)
        subprocess.run(abd_gen, stdout=log_file)

    subprocess.run(["cp", app + "/labels.pl", temp_path + "/labels.pl"])
    jsonfile = temp_path + "/" + mode + "_iter" + \
        str(abd_iter) + "_rep" + str(rep) + "_eval.json"

    if args.lazy and mode == "ase":
        # copy classification matrix for hypothesis accuracy assessment
        subprocess.run(["cp", app + "/cm.pl", cm_path])
        # lazy active learning
        subprocess.run(["swipl", "-s", "src/framework/abduction/exp_select.pl",
                        # "-q",
                        "-t",
                        "exp_select_init('" + temp_path + "/'," +
                        "['" + dependency + "'])," +
                        "exp_selection_itr('" + temp_path +
                        "/','" + jsonfile + "', ase"
                        + ", " + opt_args + ")"],
                       stdout=log_file)
        subprocess.run(["rm -f " + temp_path + "/mstate* " +
                       temp_path + "/tmstate*"], shell=True)
        print("% Experiment selection and hypothesis evaluation completed", file=log_file)

    elif args.matrix and mode == "ase" and not args.use_output:
        ex_p = 0
        ex_all = open(ex_path, "r")
        num_batch = 1
        exs = ex_all.readlines()
        for ex in exs:
            num_batch = (ex_p // matrix_batch_size) + 1
            subprocess.run(
                ["echo", "-n", ex],
                stdout=open(temp_path + "/ex_" + str(num_batch), "a"))
            ex_p += 1

        # generate the entire classification matrix
        # before active selecting experiments
        abd_file = open(abd_path, "r")
        abds = abd_file.readlines()

        aid = 1
        for abd in abds:
            cm_batch_path = temp_path + "/abd_res_" + str(aid)
            for bid in range(1, num_batch + 1):
                abd_path = temp_path + "/abd_" + str(aid) + "_" + str(bid)
                subprocess.run(
                    ["cat", dependency],
                    stdout=open(abd_path, "w"))
                subprocess.run(
                    ["echo"],
                    stdout=open(abd_path, "a"), shell=True)
                subprocess.run(
                    ["echo", abd],
                    stdout=open(abd_path, "a"))
                subprocess.run(
                    ["cat", temp_path + "/ex_" + str(bid)],
                    stdout=open(abd_path, "a"))

                parallel_abduction(temp_path, dependency,
                                   abd_path, cm_batch_path)
                subprocess.run(["rm", "-f", abd_path])

            subprocess.run(["swipl", "-s", "src/framework/abduction/run.pl",
                            "-q",
                            "-t",
                            "concat_abd_labels(" + str(aid - 1) +
                            ",'" + cm_batch_path
                            + "','" + temp_path + "/cm.pl" + "')."],
                           stdout=log_file)

            complete_time = str(datetime.now().strftime("%m_%d_%Y_%H:%M:%S"))
            text = "% Batch NO. " + str(aid) + " completed at " + complete_time
            subprocess.run(["echo", "-e", text])
            subprocess.run(["rm", "-f", cm_batch_path])
            aid += 1
        rm_ex = temp_path + "/ex_*"
        subprocess.run(["rm -f " + temp_path + "/mstate* " +
                       temp_path + "/tmstate* " + rm_ex], shell=True)
        print("% All classifications completed")

    else:
        # use a generated matrix
        if not args.use_output:
            raise ValueError(
                "Need to include the path to a classification table in the application/source directory")
        else:
            subprocess.run(["cp", args.use_output + "/cm.pl", cm_path])
            subprocess.run(
                ["cp", args.use_output + "/abducibles.pl", abd_path])
            subprocess.run(["cp", args.use_output + "/examples.pl", ex_path])
            subprocess.run(["swipl", "-s", "src/framework/abduction/exp_select.pl",
                            # "-q",
                            "-t",
                            "exp_select_init('" + temp_path + "/'," +
                            "['" + dependency + "'])," +
                            "exp_selection_itr('" + temp_path +
                            "/','" + jsonfile + "'," + mode
                            + ", " + opt_args + ")"],
                           stdout=log_file)
        subprocess.run(["rm -f " + temp_path + "/mstate* " +
                       temp_path + "/tmstate*"], shell=True)
        print("% Experiment selection and hypothesis evaluation completed", file=log_file)


# create classification matrix in batches
# current implementation does not handle long evaluation well
# partitioning helps computational performance
def parallel_abduction(temp_path, dependency, abd_path, out_path):
    subprocess.run(["rm -f mstate* tmstate*"], shell=True)

    subprocess.run(["swipl", "-s", "src/framework/abduction/run.pl",
                    "-q",
                    "-t",
                    "simulations('" + temp_path + "/','" + dependency + "','" + abd_path + "','" + out_path + "')."])


if __name__ == '__main__':
    main()
