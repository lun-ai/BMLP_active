:- [sample].
:- [run].
:- [trial_ec].
:- [rand].
:- [ase].
:- [naive].
:- [eval].
:- use_module(library(random)).


:- dynamic(total_cost/1).
:- dynamic(output_path/2).
:- dynamic(default/1).

default(total_cost(10000)).

compression_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'h_compression.pl'],Path).
stat_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'h_stat.pl'],Path).
ec_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'ec.pl'],Path).
hypoth_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'hypotheses.pl'],Path).
selected_trial_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'selected_trials.pl'],Path).

exp_select_init(Path,CMPath,Dependency) :-
    assert(output_path(abd,Path)),
    assert(classification_matrix_path(CMPath)),
    forall(member(F,Dependency),consult(F)).
exp_select_init(Path,Dependency) :-
    assert(output_path(abd,Path)),
    atomic_list_concat([Path,'cm.pl'],CMPath),
    assert(classification_matrix_path(CMPath)),
    forall(member(F,Dependency),consult(F)).

ground_truth_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'labels.pl'],Path).

trial_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'examples.pl'],Path).

abd_path(Path) :- !,
    output_path(abd,BP),
    atomic_list_concat([BP,'abducibles.pl'],Path).

cost_cap(Cost) :- !,
    total_cost(Cost).