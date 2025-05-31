naive(I,Acc,Cost) :-
    trial_path(TrialPath),
    % consult all trials but unload them once the partition has been created
    cheapest_trials(I,TrialPath,'experiments/iML1515/abduction/temp/naive_partition.pl'),
    % choose hypothesis with highest compression given this set of examples.
    % if there is no trial, then return with zero accuracy and cost
    current_predicate(ex/2),!,
    findall(C,(ex(_,E),cost(E,C)),Cs),
    sum_elements_in_list(Cs,Cost),
    unload_file('experiments/iML1515/abduction/temp/naive_partition.pl'),!,
    % write the hypothesis with max compression
    compression_path(CompPath),
    compression(CompPath),
    (current_predicate(comp/4) ->
        (
            find_max_comp(MaxComp),
            findall(abd(AId,A),comp(AId,A,MaxComp,_),H),
            write_facts(H),
            consult(TrialPath),
            test_accuracy(Acc)
        );Acc = 0
    ),told,!.
naive(_,0,0).



% Given the trial_partition_size/1 definition, sub-sample a set of trials to be candidates.
% Then locate the cheapest trial from this set if cost has not been exhausted.
%
% Consult all trials but unload them once the partition has been created.

cheapest_trials(N,AllTrialPath,PartitionPath) :-
    consult(AllTrialPath),
    findall(ex(I,E),ex(I,E),AllTrials),
    unload_file(AllTrialPath),
    cost_cap(TotalCost),
    cheapest_trial(N,TotalCost,AllTrials,[],SelectedTrials),
    tell(PartitionPath),
    write_facts(SelectedTrials),
    told,consult(PartitionPath).

cheapest_trial(0,_,C,C,T,T) :- !.
cheapest_trial(N,AllTrials,Budget,LeftOver,Trials1,Trials2) :-
    once((
        subtract(AllTrials,Trials1,Trials3),
        trial_partition_size(TN),
        sample_trials(TN,Trials3,Trials4),
        findall(cost(E,C),(member(ex(_,E),Trials4),cost(E,C)),CsTerms),
        findall(C,(member(ex(_,E),Trials4),cost(E,C)),Cs),
        min_list(Cs,MinCost),
        NewCost is Budget - MinCost
    )),
    NewCost >= 0,!,
    member(cost(E,MinCost),CsTerms),
    member(ex(I,E),Trials4),!,
    N1 is N - 1,
    cheapest_trial(N1,AllTrials,NewCost,LeftOver,[ex(I,E)|Trials1],Trials2).
cheapest_trial(_,_,_,_,_,_).