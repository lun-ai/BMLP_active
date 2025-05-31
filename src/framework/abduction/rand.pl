% random selection with compression computation for maximal posterior probability
rand(I,Acc,Cost,Args) :-
    get_arg(Args,costf,CostF),
    % consult all trials but unload them once the partition has been created
    trial_path(TrialPath),
    cost_cap(TotalCost),
    classification_matrix_path(CMPath),
    (exists_source(CMPath) -> consult(CMPath); true),
    output_path(abd,BasePath),
    atom_concat(BasePath,'random_with_compression_partition.pl',PartitionPath),
    % randomly sample a partition of size I
    sample_trial_partition_with_cost_limit(I,TotalCost,TrialPath,PartitionPath,[]),!,
    current_predicate(ex/2),
    abd_path(AbdPath),
    consult(AbdPath),
    % load trial outcomes
    % find consistent hypotheses
    ground_truth_path(GTPath),
    consult(GTPath),
    % sum the total trial cost
    trial_cost(CostF,Cost),
    % compute compression given this set of examples.
    compression_path(CompPath),
    compression(CompPath),
    unload_file(PartitionPath),
    hypoth_path(HypothPath),
    findall(abd(AId,A),abd(AId,A),Abds),
    write_facts_to_file(Abds,HypothPath),
    unload_file(AbdPath),
    unload_file(TrialPath),
    unload_file(GTPath),
    test_accuracy(Acc).

% random selection without compression computation
rand_no_comp(I,Acc,Cost,Args) :-
    get_arg(Args,costf,CostF),
    % consult all trials but unload them once the partition has been created
    trial_path(TrialPath),
    cost_cap(TotalCost),
    classification_matrix_path(CMPath),
    (exists_source(CMPath) -> consult(CMPath); true),
    output_path(abd,BasePath),
    atom_concat(BasePath,'random_partition_without_compression.pl',PartitionPath),
    % randomly sample a partition of size I
    sample_trial_partition_with_cost_limit(I,TotalCost,TrialPath,PartitionPath,[]),!,
    unload_file(TrialPath),
    current_predicate(ex/2),
    abd_path(AbdPath),
    consult(AbdPath),
    % sum the total trial cost
    trial_cost(CostF,Cost),
    hypoth_path(HypothPath),
    % load trial outcomes
    % find consistent hypotheses
    ground_truth_path(GTPath),
    consult(GTPath),
    findall(PId,(ex(PId,E),label(E,1)),PIds),
    findall(NId,(ex(NId,E),label(E,0)),NIds),
    length(PIds,PN),
    findall(abd(AId,A),(abd(AId,A),hypoth_coverage(PIds,NIds,AId,PN,0)),Abds),
    write_facts_to_file(Abds,HypothPath),
    unload_file(AbdPath),
    unload_file(GTPath),
    unload_file(PartitionPath),
    test_accuracy(Acc).
