:- ['src/framework/lmatrix/lmarith.pl'].

% perform phenotypic effect simulations to create the classification table
%   which is used for active selection of experiment based on MDL analysis

% the order of the labels matches of that of the example Id
% the bitset of example id is reverse of the bitset of the labels

abduction(AbdPath,ResPath) :-
    consult(AbdPath),
    abd(I,AbdEncap),
    expand_abd(abd(I,AbdEncap),AbdTerms),
    format("% Abduced term: ~w\n",[AbdTerms]),
    findall([Orf,C],ex(_,phenotypic_effect(Orf,C)),Conds),
    call_time(abduction_bs(AbdTerms,Conds,Bs),Stats),
    writeln(Stats),nl,
    tell(ResPath),
    write_fact(abdm(I,Bs)),
    told,!.
abduction_bs(AbdTerms,Conds,Bs) :-
    forall(member(AbdTerm,AbdTerms),assert(AbdTerm)),
    phenotypic_effects_bitset(Conds,Bs),
    forall(member(AbdTerm,AbdTerms),retract(AbdTerm)),!.
abduction_labels(AbdTerms,Conds,Labels) :-
    forall(member(AbdTerm,AbdTerms),assert(AbdTerm)),
    phenotypic_effects(Conds,Labels),
    forall(member(AbdTerm,AbdTerms),retract(AbdTerm)),!.

% top level calling of classifier given local growth medium definition
simulations(Path,Dependency,AbdPath,ResPath) :-
    consult(Dependency),
    consult(AbdPath),
    abd(I,AbdEncap),
    expand_abd(abd(I,AbdEncap),AbdTerms),
    format("% Abduced term: ~w\n",[AbdTerms]),
    findall([G,C],ex(_,phenotypic_effect(G,C)),Conds),
    findall([label,E],ex(_,E),Es),
    forall(member(AbdTerm,AbdTerms),assert(AbdTerm)),!,
    time(phenotypic_effects(Path, Conds,PredictedLabels)),
    forall(member(AbdTerm,AbdTerms),retract(AbdTerm)),
    maplist(last,Wrapped,PredictedLabels),
    maplist(append,Es,Wrapped,Args),
    maplist((=..),Pairs,Args),
    open(ResPath,append,Str),
    write_facts(Str,Pairs),
    close(Str).

concat_abd_labels(I,LabelsPath,ResPath) :-
    consult('src/framework/lmatrix/lmarith.pl'),
    consult(LabelsPath),
    findall(L,label(_,L),Labels),
    reverse(Labels,Labels1),
    lm_ltob(Labels1,Bs),!,
    open(ResPath,append,Str),
    write_fact(Str,abdm(I,Bs)),
    close(Str).

