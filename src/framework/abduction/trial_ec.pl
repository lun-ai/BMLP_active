% default hypothesis size = 1
% refers back to the classification matrix given the example partition
% only computes compression for abduced terms for that partition
% needs:
%   - abd/2
%   - abdm/2
%   - ex/2

compression(CompPath) :-
    current_predicate(abd/2),!,
    findall(I,abd(I,_),AIds),
    hypoth_compression(AIds,CompPath),
    consult(CompPath).
% compute compression of hypotheses using the selected set of training examples
compression(LabelledEs,As,CompPath) :-
    current_predicate(abd/2),!,
    findall(I,member(abd(I,_),As),AIds),
    hypoth_compression(LabelledEs,AIds,CompPath),
    consult(CompPath).



% compute compression for each hypothesised term/clause
% given the classication matrix
%
% compression is computed as
%           compression = |E| + n
%           Progol's compression = |E+| - (|E+| / p) * (c + n)
%
% where E+ is the number of positive examples,
%       p is the number of positive examples predicted
%       n is the number of negative examples predicted
%       c is the size of the hypothesis

hypoth_compression(AIds,Path) :-
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
    findall(I,ex(I,_),EIds),
    concurrent_maplist(hypoth_compression_(EIds,PIds,NIds),AIds,CompTerms),
%    maplist(hypoth_compression_(PIds,NIds),AIds,CompTerms),
    write_facts_to_file(CompTerms,Path).
% alternatively take a specific set of training examples
hypoth_compression(LabelledEs,AIds,Path) :-
    findall(I,
            (
                member(ex(I,E),LabelledEs),
                label(E,1)
            ),
            PIds),
    findall(I,
            (
                member(ex(I,E),LabelledEs),
                label(E,0)
            ),
            NIds),
    findall(I,ex(I,_),EIds),
    concurrent_maplist(hypoth_compression_(EIds,PIds,NIds),AIds,CompTerms),
%    maplist(hypoth_compression_(EIds,PIds,NIds),AIds,CompTerms),
    write_facts_to_file(CompTerms,Path).

%hypoth_compression(Es,AId,CompTerm) :-
%    abd(AId,A),
%    length(A, HSize),
%    length(Es,N),
%    N > 0,!,
%    hypoth_coverage_(Es,AId,PN),
%    Generality is PN / N + 0.1,
%    log_base(2,Generality,Log),
%    Comp is Log - HSize,
%    TwoPowerComp is 2 ** Comp,
%    CompTerm=..[comp,AId,A,Comp,TwoPowerComp].
%hypoth_compression(_,_,'T').


hypoth_compression_(EIds,PIds,NIds,AId,CompTerm) :-
    abd(AId,A),
    length(PIds,_PN),
    length(A, HSize),
    hypoth_coverage(PIds,NIds,AId,_,NC),
    hypoth_coverage_(EIds,AId,CoverageN),
%    length(EIds,All),
%    NC is All - PC,
    comp_calc(CoverageN,NC,HSize,Comp,TwoPowerComp),
    CompTerm=..[comp,AId,A,Comp,TwoPowerComp].
%hypoth_compression_(_,_,_,AId,_) :-
%    format('% zero pos when compute compression for hypo ~w\n',[AId]),
%    fail.

% normalising to avoid float overflow and
% adding a small value to avoid zero division
comp_calc(CoverageN,NC,HSize,Comp,TwoPowerComp) :-
    Comp is (1 - (1 / (CoverageN + 0.1)) * (NC + HSize)),
    TwoPowerComp is 2**Comp.


% check ground truths and classification matrix
% output:
%       - the number of positive covered by h (true positives)
%       - the number of negative covered by h (false positives)

hypoth_coverage(PIds,NIds,AId,PCN,NCN) :-
    hypoth_coverage_(PIds,AId,PCN),
    hypoth_coverage_(NIds,AId,NCN).



% coverage(H) = {for all e in E, H /\ BK |= e}
% abdm/2 specifies the classification of all e given abduction with abduction Id
% convert bit set to number set which gives the example ids that are covered (with label "1")
%
% needs:
%   - abdm/2
%   - ex/2

hypoth_coverage_(EIds,AId,C) :-
    current_predicate(abdm/2),!,
    abdm(AId,Bs),
    lm_stob1(EIds,EBs),
    CoverageBs is EBs /\ Bs,
    count_ones(CoverageBs,C).


% lazy coverage computation.
% INSTEAD of generating the classification matrix before selecting experiments,
%   we simulate the phenotyping as we sample the candidate experiments.

hypoth_coverage_(Conds,AId,Coverage,C) :-
    current_predicate(ex/2),!,
    abd(AId,AbTerm),
    abduction_labels(AbTerm,Conds,Labels),
    findall(I,nth0(I,Labels,1),Coverage),
    length(Coverage,C).



% compute a set of numeric values (h_stat/4) based on compression of h
%   these values are used in computation of
%       1) the probability of h
%       2) the expect cost of binary decision tree
% only computes for abduced h in the partition (has comp/4 generated)
%
% write to file h_stat/4 with:
%   - p(h) as normalised 2**compression
%   - floor(log2 p(h)) via log base change which is negative
%   - p(h) floor(log2 p(h)), as negative mean encoding length of h
%
% needs:
%   - comp/4

hypoth_stat(StatPath) :-
    findall(TwoPowerComp,comp(_,_,_,TwoPowerComp),TwoPowerComps),
    sum_elements_in_list(TwoPowerComps,Sum),
    tell(StatPath),
    forall(comp(AId,A,Comp,TwoPowerComp),hypoth_stat_(AId,A,Comp,TwoPowerComp,Sum,_)),
    told,consult(StatPath).
hypoth_stat_(AId,A,Comp,TwoPowerComp,Sum,StatTerm) :-
    NormProb is TwoPowerComp / Sum,

    % multiply by 1/ln(2) to convert loge to log2.
    log_base(2,NormProb,LogNorm),

	% floor, rather than ceil, since log of probability will be negative.
	LogNormProb is floor(LogNorm),

	Product is NormProb * LogNormProb,
	StatTerm=..[h_stat,AId,A,Comp,TwoPowerComp,NormProb,LogNormProb,Product],
	write_fact(StatTerm).



% compute approximation of expected cost of trials
%
% needs:
%   - abdm/2
%   - cost/2
%   - ex/2
%   - h_stat/7

% if entropy has been computed
expected_costs(ECPath) :-
    findall(I,(ex(I,_),trial_entropy(I,_)),EIds),
    EIds \== [],!,
	mean_cost(EIds,MeanCost),
	length(EIds,N),
	N > 1,!,
    concurrent_maplist(expected_costs_(MeanCost,N),EIds,ECTerms),
    write_facts_to_file(ECTerms,ECPath),
    consult(ECPath).
% calculate mean costs if entropy cannot be/has not been computed
expected_costs(ECPath) :-
    findall(I,(ex(I,_)),EIds),
	mean_cost(EIds,MeanCost),
	length(EIds,N),
	N > 1,!,
    concurrent_maplist(expected_costs_(MeanCost,N),EIds,ECTerms),
    write_facts_to_file(ECTerms,ECPath),
    consult(ECPath).
expected_costs_(MC,N,I,ECTerm) :-
    expected_cost(MC,N,I,_TC,_RestMC,_PS,_CEC,_IEC,EC),!,
    ECTerm=..[exp_cost,I,EC].

expected_cost(MeanCost,N,TrialId,TrialCost,MeanCost1,ProbSum,ConEC,InconEC,EC):-
    ex(TrialId,E),!,
    cost(E,TrialCost),
    N1 is N - 1,
    MeanCost1 is (MeanCost * N - TrialCost) / N1,
	% based on negative product sum
	%   product = (- p(h) log2 p(h))
	expected_cost(TrialId,MeanCost1,1,ConEC),
	expected_cost(TrialId,MeanCost1,0,InconEC),
	% hypothesis consistent with a positive outcome of trial T
	get_covered_AIds(TrialId,1,AIds),
    sum_h_prob(AIds,ProbSum),
	EC is (TrialCost + (ProbSum * ConEC) + ((1 - ProbSum) * InconEC)).

expected_cost(TrialId,MeanCost,Label,EC):-
	get_covered_AIds(TrialId,Label,AIds),
    sum_h_prod(AIds,ProdSum),
	EC is (- MeanCost) * ProdSum.



% compute mean cost for those trials with cost/2 definitions
%
% needs:
%   - cost/2

mean_cost(TrialIds,MC) :-
    findall(Cost,(member(Id,TrialIds),ex(Id,T),cost(T,Cost)),AllCosts),
    sum_elements_in_list(AllCosts,Total),
    length(AllCosts,N),
    MC is Total / N.



% given a set of abducible ids of hypothesis, sum up the probabilities of those hypotheses
%
% needs:
%   - h_stat/7

sum_h_prob(AIds,ProbSum) :-
    findall(Prob,(member(AId,AIds),h_stat(AId,_,_,_,Prob,_,_)),Probs),
	sum_elements_in_list(Probs,ProbSum).



% given a set of abducible ids of hypothesis, compute the entropy of all hypotheses
% by summing up the average encoding length of individual hypothesis
%
% needs:
%   - h_stat/7

sum_h_prod(AIds,ProdSum) :-
    findall(Prod,(member(AId,AIds),h_stat(AId,_,_,_,_,_,Prod)),Prods),
	sum_elements_in_list(Prods,ProdSum).



% given a trial and an expected outcome (1/0)
% get all ids of hypotheses that with the expected classification outcome
%
% needs:
%   - abdm/2
%   - ex/2

get_covered_AIds(TrialId,0,AIds):- !,
    inconsistent_AIds(TrialId,AIds).
get_covered_AIds(TrialId,1,AIds):- !,
    consistent_AIds(TrialId,AIds).

consistent_AIds(TrialId,AIds):- !,
    TrialBitS is 1 << TrialId,
    findall(AId,(abdm(AId,BitS),bit_subset_chk(TrialBitS,BitS)),AIds).
inconsistent_AIds(TrialId,AIds):- !,
    TrialBitS is 1 << TrialId,
    findall(AId,(abdm(AId,BitS),\+bit_subset_chk(TrialBitS,BitS)),AIds).

consistent_AIds_(TrialId,AIds):- !,
    TrialBitS is 1 << TrialId,
    findall(AId,(abd(AId,_),abdm(AId,BitS),bit_subset_chk(TrialBitS,BitS)),AIds).
inconsistent_AIds_(TrialId,AIds):- !,
    TrialBitS is 1 << TrialId,
    findall(AId,(abd(AId,_),abdm(AId,BitS),\+bit_subset_chk(TrialBitS,BitS)),AIds).


minimal_reduction_ratio(TrialId,Ratio,CN,ICN) :-
    consistent_AIds_(TrialId,ConAIds1),
    inconsistent_AIds_(TrialId,InConAIds2),
    length(ConAIds1,CN),
    length(InConAIds2,ICN),
    Min is min(CN,ICN),
    Ratio is Min / (CN + ICN).
trial_entropy(TrialId,Entropy) :- !,
    consistent_AIds_(TrialId,ConAIds1),
    inconsistent_AIds_(TrialId,InConAIds2),
    length(ConAIds1,CN),
    length(InConAIds2,ICN),
    CN \== 0,
    ICN \== 0,
    PEx is CN / (CN + ICN),
    PEx2 is 1 - PEx,
    log_base(2,PEx,LogPEx),
    log_base(2,PEx2,LogPEx2),
    Entropy is - PEx * LogPEx - PEx2 * LogPEx2.

% find trial with the maximal entropy value
initial_trial(max_entropy,TotalCost,TrialIds,MaxEntTrialId) :-
    findall([T,Entropy],(member(T,TrialIds),trial_entropy(T,Entropy)),Ents),
    findall(Entropy,(member([_T,Entropy],Ents)),EntValues),
    max_list(EntValues,MaxEnt),
    findall(T,(member([T,MaxEnt],Ents)),MaxEntTrials),
    %length(MaxEntTrials,L),
    %format("# max entropy example No. ~w",[L]),
    MaxEntTrials = [MaxEntTrialId|_],
    ex(MaxEntTrialId,E),
    cost(E,Cost),
    TotalCost >= Cost,!.
% find trial with the maximal entropy value and the minimal trial cost
initial_trial(min_cost_max_entropy,TotalCost,TrialIds,MaxEntCostTrialId) :-
    findall([T,Entropy],(member(T,TrialIds),trial_entropy(T,Entropy)),Ents),
    findall(Entropy,(member([_T,Entropy],Ents)),EntValues),
    max_list(EntValues,MaxEnt),
    findall(T,(member([T,MaxEnt],Ents)),MaxEntTrials),
    findall(Cost,(member(T,MaxEntTrials),ex(T,E),cost(E,Cost)),Costs),
    min_list(Costs,MinCost),
    TotalCost >= MinCost,!,
    nth0(I,Costs,MinCost),
    nth0(I,MaxEntTrials,MaxEntCostTrialId).
% if trial cost is too high, random select on trial
initial_trial(_,_TotalCost,TrialIds,RandCostTrialId) :-
%    findall(T,(member(T,TrialIds),ex(T,E),cost(E,Cost),Cost=<TotalCost),MinCostTrials),
%    random_member(RandCostTrial,MinCostTrials).
    random_member(RandCostTrialId,TrialIds).
%    min_list(Costs,MinCost),!,
%    nth0(I,Costs,MinCost),
%    nth0(I,TrialIds,MinCostTrial).

find_max_comp(MaxComp) :-
    current_predicate(abd/2),
    current_predicate(comp/4),
    findall(Comp,(abd(I,A),comp(I,A,Comp,_)),Comps),
    max_list(Comps,MaxComp),!.



trial_with_lowest_EC(ex(Id,Trial)) :-
    findall(EC,(exp_cost(_,EC)),Costs),
    sort(Costs,[MinCost|_]),
    exp_cost(Id,MinCost),!,
    ex(Id,Trial).


log_base(Base,N,Log) :-
    Log is log(N) / log(Base).