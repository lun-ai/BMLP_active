:- dynamic(output_path/2).

%get_steps(Args,Steps) :-
%    get_arg(Args,iter,MaxItr),
%    get_arg(Args,steps,Steps),
%    get_arg(Args,expstep,ExpStep),
%    get_steps_(MaxItr,Steps,ExpStep,Steps).
%get_steps_(MaxItr,_,true,Steps) :-
%    numlist(0,MaxItr,NumL),
%    findall(Int1,(member(Int,NumL),Int1 is 2 ** Int),Steps),!.
%get_steps_(MaxItr,StepSize,false,Steps) :-
%    MaxItr1 is MaxItr // StepSize,
%    numlist(1,MaxItr1,NumL),
%    findall(Int1,(member(Int,NumL),Int1 is Int * StepSize),Steps),!.


% run MaxItr No. Active Selection of Experiemts
% for i rounds where 1 <= i <= MaxItr with multiple repeats

exp_selection_itr(BasePath,JsonFilePath,Method,Args) :-
    get_arg(Args,rep,Repeat),
    get_arg(Args,steps,Steps),!,
    format("% parameters: ~w  \n",[Args]),
    get_arg(Args,costCap,[TotalCost]),
    asserta(total_cost(TotalCost)),
    get_arg(Args,trial_partition_size,N),
    assert(trial_partition_size(N)),
    assert(output_path(abd,BasePath)),
    exp_selection(Method,Repeat,Steps,Args,[],Acc,[],Costs),
    tell(JsonFilePath),
    writes(['{\n\t\"method\": \"',Method,'\",\n']),
    writes(['\t\"stepsizes\": ',Steps,',\n']),
    writes(['\t\"accuracy\": ',Acc,',\n']),
    writes(['\t\"cost\": ',Costs,'\n}']),
    told.



exp_selection_itr(BasePath,JsonFilePath,Method,Args) :-
    get_arg(Args,rep,Repeat),!,
    format("% parameters: ~w  \n",[Args]),
    get_arg(Args,costCap,TotalCosts),
    get_arg(Args,trial_partition_size,N),
    assert(trial_partition_size(N)),
    asserta(output_path(abd,BasePath)),
    abd_path(AbdPath),
    consult(AbdPath),
    classification_matrix_path(CMPath),
    consult(CMPath),
    ground_truth_path(GTPath),
    consult(GTPath),!,
    findall([Acc,Cost],
        (
            member(TotalCost,TotalCosts),
            once((
                    format("% Running ~w selection under cost ~w with ~w repeat(s) left \n",[Method, TotalCost, Repeat]),
                    asserta(total_cost(TotalCost)),
                    (exp_selection_(Method,Repeat,TotalCost,Args,[],Acc,[],Cost)
                        -> retract(total_cost(TotalCost));retract(total_cost(TotalCost)))
                ))
        ),
        Res
        ),
    findall(Acc,member([Acc,_],Res),Accs),
    findall(Cost,member([_,Cost],Res),Costs),
    tell(JsonFilePath),
    writes(['{\n\t\"method\": \"',Method,'\",\n']),
    writes(['\t\"totalCost\": ',TotalCosts,',\n']),
    writes(['\t\"accuracy\": ',Accs,',\n']),
    writes(['\t\"cost\": ',Costs,'\n}']),
    told.



exp_selection(_,_,[],_,Acc1,Acc2,Cs1,Cs2) :- reverse(Acc1,Acc2),reverse(Cs1,Cs2),!.
exp_selection(Method,Repeat,[I|L],Args,Acc1,Acc2,Cs1,Cs2) :-
    (get_arg(Args,costCap,_) ->
        true;
        format("% Running ~w selection of ~w trials with ~w repeat(s) left\n",[Method, I, Repeat])),!,
    exp_selection_(Method,Repeat,I,Args,[],Accs,[],Costs),
    exp_selection(Method,Repeat,L,Args,[Accs|Acc1],Acc2,[Costs|Cs1],Cs2).
exp_selection_(_,0,_,_,Acc,Acc,Costs,Costs) :- !.
exp_selection_(Method,N,I,Args,Acc1,Acc2,Cost1,Cost2) :-
    N1 is N - 1,
    rm_abducible_temp,
    rm_candidate_temp,
    (call(Method,I,Acc,Cost,Args) -> true;Cost = 0,test_accuracy(Acc)),
    format(' ... done - Accuracy: ~w\n',[Acc]),
    exp_selection_(Method,N1,I,Args,[Acc|Acc1],Acc2,[Cost|Cost1],Cost2).


% define how to compute cost of trials
trial_cost(material,Cost) :-
    current_predicate(ex/2),!,
    findall(C,(ex(_,E),cost(E,C)),Cs),
    sum_elements_in_list(Cs,Cost).
trial_cost(sequence,Cost) :-
    current_predicate(ex/2),!,
    setof(Cond,N^Orfs^Cond^(ex(N,phenotypic_effect(Orfs,Cond))),Cs),
    length(Cs,Cost).


% test accuracy when using the compression function
% using compression would sometimes select empty hypothesis
%   where there is not enough training examples
test_accuracy(Accuracy) :-
    % load examples
    trial_path(TrialPath),
    consult(TrialPath),
    % load compression values
    compression_path(CompPath),
    exists_source(CompPath),
    consult(CompPath),
    % load final hypotheses
    hypoth_path(HypothPath),
    exists_source(HypothPath),
    consult(HypothPath),
    find_max_comp(MaxComp),!,
    % load labels
    ground_truth_path(GTPath),
    consult(GTPath),
    findall(I,comp(I,_,MaxComp,_),AIds),
    random_select(AId,AIds,_),
    length(AIds,AN),
    findall(I,
            (
                ex(I,E),
                label(E,1)
            ),
            PIds),
    findall(I,
            (
                ex(I,E),
                label(E,0)
            ),
            NIds),
    !,
    hypoth_coverage_(PIds,AId,PCN),
    hypoth_coverage_(NIds,AId,NCN),
    length(PIds,PN),
    length(NIds,NN),
    Accuracy is (NN - NCN + PCN) / (PN + NN),
    format(' - No. Hypothesis: ~w, Hypothesis: ~w ', [AN,AIds]),
    unload_file(TrialPath),
    unload_file(HypothPath),
    unload_file(CompPath),
    unload_file(GTPath).

% test accuracy when not using compression
test_accuracy(Accuracy) :-
    % load examples
    trial_path(TrialPath),
    consult(TrialPath),
    % load final hypotheses
    hypoth_path(HypothPath),
    exists_source(HypothPath),
    consult(HypothPath),
    current_predicate(abd/2),!,
    % load labels
    ground_truth_path(GTPath),
    consult(GTPath),
    findall(I,abd(AId,_),AIds),
    random_select(AId,AIds,_),
    length(AIds,AN),
    findall(I,
            (
                ex(I,E),
                label(E,1)
            ),
            PIds),
    findall(I,
            (
                ex(I,E),
                label(E,0)
            ),
            NIds),
    !,
    hypoth_coverage_(PIds,AId,PCN),
    hypoth_coverage_(NIds,AId,NCN),
    length(PIds,PN),
    length(NIds,NN),
    Accuracy is (NN - NCN + PCN) / (PN + NN),
    format(' - No. Hypothesis: ~w, Hypothesis: ~w ', [AN,AIds]),
    unload_file(TrialPath),
    unload_file(HypothPath),
    unload_file(GTPath).

% if does not learn a hypothesis, assume the empty hypothesis
test_accuracy(Accuracy) :-
    % load empty hypothesis
    abd_path(AbdPath),
    consult(AbdPath),
    abd(AId,[[]]),
    % load examples
    trial_path(TrialPath),
    consult(TrialPath),
    % load labels
    ground_truth_path(GTPath),
    consult(GTPath),
    findall(I,
            (
                ex(I,E),
                label(E,1)
            ),
            PIds),
    findall(I,
            (
                ex(I,E),
                label(E,0)
            ),
            NIds),
    !,
    hypoth_coverage_(PIds,AId,PCN),
    hypoth_coverage_(NIds,AId,NCN),
    length(PIds,PN),
    length(NIds,NN),
    Accuracy is (NN - NCN + PCN) / (PN + NN),
    unload_file(TrialPath),
    unload_file(AbdPath),
    unload_file(GTPath).
% if does not learn a hypothesis, assume the empty hypothesis
%test_accuracy(Acc) :-
%     % load examples
%    trial_path(TrialPath),
%    consult(TrialPath),
%    hypoth_path(HypothPath),
%    compression_path(CompPath),
%    % load labels
%    ground_truth_path(GTPath),
%    consult(GTPath),
%    findall(Score,
%            (
%                ex(_,E),
%                random_between(0,1,R),
%                label(E,L),
%                (L == R -> Score is 1 ; Score is 0)
%            ),
%            Scores),
%    length(Scores,N),
%    sum_elements_in_list(Scores,ScoreSum),
%    Acc is ScoreSum / N,
%    unload_file(TrialPath),
%    unload_file(HypothPath),
%    unload_file(CompPath),
%    unload_file(GTPath).


rm_abducible_temp :-
    output_path(abd,BasePath),
    atom_concat(BasePath,'abducibles_*.pl',FilePathWildCard),
    expand_file_name(FilePathWildCard,TempPathList),
    forall(member(Temp,TempPathList),delete_file(Temp)).
rm_candidate_temp :-
    output_path(abd,BasePath),
    atom_concat(BasePath,'partition_*.pl',FilePathWildCard),
    expand_file_name(FilePathWildCard,TempPathList),
    forall(member(Temp,TempPathList),delete_file(Temp)).