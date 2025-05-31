:- ['src/framework/lmatrix/utils.pl'].

generate_abduction_trials(Args,OutputPath) :-
    format("\n% Generating examples to ~w\n",[OutputPath]),
    open(OutputPath,write,OutputStr),
    cond(ex,Args,Ex),
    write_facts(OutputStr,Ex),
    length(Ex,L),
    format("\n% Generated ~w trials\n",[L]),
    close(OutputStr).


% ASE only
% Take all trials, remove conducted trials and sample a new set of N trials

sample_trial_partition(N,AllTrialPath,SampledTrialPath,ConductedTrials) :-
    consult(AllTrialPath),
    findall(ex(I,E),(ex(I,E),\+memberchk(ex(I,E),ConductedTrials)),NewTrials),
    unload_file(AllTrialPath),!,
    sample_trials(N,NewTrials,SampledTrials),
    SampledTrials \== [],
    tell(SampledTrialPath),
    write_facts(SampledTrials),
    told,consult(SampledTrialPath).



% Given a cost cap, sample a trial partition of N without replacement.
%
% Consult all trials but unload them once the partition has been created.

sample_trial_partition_with_cost_limit(N,TotalCost,AllTrialPath,SampledTrialPath,ConductedTrials) :-
    consult(AllTrialPath),
    findall(ex(I,E),(ex(I,E),\+memberchk(ex(I,E),ConductedTrials)),NewTrials),
    unload_file(AllTrialPath),!,
    tell(SampledTrialPath),
    sample_trial_partition_with_cost_limit(N,TotalCost,NewTrials),
    told,consult(SampledTrialPath),!.



sample_trial_partition_with_cost_limit(0,_,_) :- !.
sample_trial_partition_with_cost_limit(N,TotalCost,AllTrials) :-
    once((
            sample_trials(1,AllTrials,[ex(I,SampledTrial)]),
            cost(SampledTrial,Cost)
        )),
    NewCost is TotalCost - Cost,
    NewCost >= 0,!,
    write_fact(ex(I,SampledTrial)),
    N1 is N - 1,
    delete(AllTrials,ex(I,SampledTrial),Rest),
    sample_trial_partition_with_cost_limit(N1,NewCost,Rest).
sample_trial_partition_with_cost_limit(_,_,_).



% Given a set of trials, get a random sample of size N
sample_trials(N,AllTrials,SampledTrials) :-
    length(AllTrials,TrialN),
    N1 is min(TrialN,N),
    length(SampledTrials,N1),
    random_permutation(AllTrials,Permuted),
    append(SampledTrials,_,Permuted),!.