ase(I,Acc,Cost,Args) :-
    ase_trials(I,Cost,Args),!,
    test_accuracy(Acc).


% Given the trial_partition_size/1 definition, sub-sample a set of trials to be candidates.
% Use f compression to compute the selection sequence of trials with lowest expected cost.
ase_trials(N,Cost,Args) :-
    get_arg(Args,costf,CF),!,
    % load ground truth labels
    ground_truth_path(GTPath),
    consult(GTPath),
    % load all abducibles
    abd_path(AbdPath),
    consult(AbdPath),
    % load model classification labels
    classification_matrix_path(CMPath),
    (exists_source(CMPath), not(get_arg(Args,lazy,true))
        -> consult(CMPath); true),
    % temp result paths
    compression_path(CompPath),
    stat_path(StatPath),
    ec_path(ECPath),!,
    ase_trials_(N,CompPath,StatPath,ECPath,_Final),
    selected_trial_path(FinalSelectionPath),
    consult(FinalSelectionPath),
    trial_cost(CF,Cost),
    unload_file(FinalSelectionPath).


ase_trials_(Itr,CompPath,StatPath,ECPath,Final) :-
    cost_cap(Budget),
    findall(abd(I,A),abd(I,A),As),
    % remove all abducibles temporarily in ase's scope
    % since final hypotheses share the same term definition
    abd_path(AbdPath),
    unload_file(AbdPath),!,
    hypoth_path(HypothPath),
    tell(HypothPath),told,
    select_trial(CompPath,StatPath,ECPath,Itr,As,_H,Budget,Final,[],Trials),
    selected_trial_path(FinalSelectionPath),!,
    tell(FinalSelectionPath),
    write_facts(Trials),
    told.


select_trial(_,_,_,0,As,As,Final,Final,Ts,Ts) :- !.
select_trial(_,_,_,_,[H],[H],Final,Final,Ts,Ts) :- !.
select_trial(CompPath,StatPath,ECPath,Itr,As1,As2,Leftover,Final,Ts1,Ts2) :-
    once((
            % load consistent abducibles
            new_abducibles(Itr,As1,NewAbduciblePath),
            As1 \== [],
            new_trial_partition(Itr,SampledTrialPath,Ts1),
            (Ts1 == [] ->
                (
                    findall(I,ex(I,_E),EIds),!,
                    random_permutation(EIds,EIdsPermute),
%                    initial_trial(min_cost_max_entropy,Leftover,EIdsPermute,TrialId),
                    initial_trial(max_entropy,Leftover,EIdsPermute,TrialId),
                    ex(TrialId,Trial)
                );(
                    exists_source(StatPath),
                    consult(StatPath),
                    expected_costs(ECPath),
                    trial_with_lowest_EC(ex(TrialId,Trial))
                )
            ),

            % check resource leftover
            cost(Trial,Cost),
            format("\t # leftover:~w/~w \n",[Leftover,Cost]),
            Leftover >= Cost,
            % compute minimal reduction ratio
            minimal_reduction_ratio(TrialId,Ratio,CN,ICN),
            format("\t\t # min ratio: ~w/~w/~w \n",[Ratio,CN,ICN]),

            % obtain label of the selected trial
            label(Trial,Label),
            format("\t\t % ~w\n",[label(Trial,Label)]),
            % find only consistent abducibles
            %   as a subset of current abducibles
            get_covered_AIds(TrialId,Label,AIds1),
            findall(abd(AId,A),(member(AId,AIds1),abd(AId,A)),As3),
            intersection(As1,As3,As4),
            % compute compression given labelled instances and unlabelled instances from the current partition
            compression([ex(TrialId,Trial)|Ts1],As4,CompPath),
            hypoth_stat(StatPath),

            % unload trials sampled in this round
            %   and clean temp computations
            unload_file(SampledTrialPath),
            unload_file(CompPath),
            unload_file(StatPath),
            unload_file(ECPath),
            unload_file(NewAbduciblePath),

            hypoth_path(HypothPath),
            tell(HypothPath),
            write_facts(As4),told,
            NewCost is Leftover - Cost,
            Itr1 is Itr - 1
    )),
    select_trial(CompPath,StatPath,ECPath,Itr1,As4,As2,NewCost,Final,[ex(TrialId,Trial)|Ts1],Ts2).
% either reaching max cost or no hypothesis is learnable,
% failure catch against only negative examples
select_trial(_,_,_,Itr,As,As,Final,Final,Ts,Ts) :-
    output_path(abd,OutputPath),
    atomic_list_concat([OutputPath,'partition_',Itr,'.pl'],SampledTrialPath),
    atomic_list_concat([OutputPath,'abducibles_',Itr,'.pl'],NewAbduciblePath),
    unload_file(SampledTrialPath),
    unload_file(NewAbduciblePath).



% create a sample trial partition of size N given a iteration number
% consult the new trial partition after creation

new_trial_partition(Itr,SampledTrialPath,SelectedTrials) :-
    trial_path(AllTrialPath),
    trial_partition_size(N),
    output_path(abd,OutputPath),
    atomic_list_concat([OutputPath,'partition_',Itr,'.pl'],SampledTrialPath),
    sample_trial_partition(N,AllTrialPath,SampledTrialPath,SelectedTrials),!.


new_abducibles(Itr,Abds,NewAbduciblePath) :-
    output_path(abd,OutputPath),
    atomic_list_concat([OutputPath,'abducibles_',Itr,'.pl'],NewAbduciblePath),
    tell(NewAbduciblePath),
    write_facts(Abds),
    told,consult(NewAbduciblePath),!.