:- ['src/framework/lmatrix/lmarith.pl'].

% Define how the cost of a phenotyping trial is computed

cost(ex(_,Trial),TrialCost) :-
    cost(Trial,TrialCost).

cost(phenotypic_effect(_,Ns),RelativeSum) :-
    findall(C,(member(N,Ns),(current_predicate(mcost/2) -> mcost(N,C);C=1)),Costs),
    (current_predicate(base_mcost/1) -> base_mcost(BC);BC=0),
    sum_elements_in_list([BC|Costs],Sum),
    (current_predicate(unit_cost/1) -> unit_cost(U);U=1),
    RelativeSum is Sum / U.

growth_medium_composition(N,M,S) :-
    growth_medium_composition(M),
    union(N,M,M1),
    lm_stob(M1,S).

target_growth_composition(E) :-
    ends(Ends),
    lm_stob(Ends,E).


lm_cycle(10).



% phenotypic_effect/2 tests if knocking off one set of ORFs has an effect
%   on growth given *** one growth medium composition ***
% It uses transitive closure in the form of boolean logic matrices
%
% ORF can be either a ground term or a list of ground terms.

phenotypic_effect(OutPath,ORF,Nutrients) :-
    phenotypic_effect(OutPath,ORF,Nutrients,_SNum,MutantBSet),
    \+reach_endbs(MutantBSet),!.
phenotypic_effect(_,_,_).

phenotypic_effect(OutPath,ORF,Nutrients,MutantBSet) :-
    phenotypic_effect(OutPath,ORF,Nutrients,_SNum,MutantBSet).
phenotypic_effect(OutPath,ORF,Nutrients,SNum,MutantBSet) :-
    growth_medium_composition(Nutrients,_M,StartBitSet),
    knocked_out_reactions(ORF,_,DeletedReactions),
    findall(Id,
           (
            member(R,DeletedReactions),
            rid(R,Id)
           ),Rs),
    lm_stob1(Rs,DeletedReactionsBS),

    % define possible reaction pool
    write_row_matrix(OutPath,mstate,2,0,DeletedReactionsBS),

    % define metabolic state 1 (start with label 5)
    write_row_matrix(OutPath,mstate,5,0,StartBitSet),

    % create transpose product matrix
    atomic_list_concat([OutPath,tmstate,3],TMName),
    (exists_source(TMName) -> true;
        lm_prod_trans(OutPath,[mstate,3])),

    % start from state 1 (label 5)
    reaction_closure(OutPath,mstate,5,SNum),!,
    mname(mstate,SNum,Final),
    call(Final,0,MutantBSet).



partition(N,L,Ls1,Ls2) :-
    N > 0,
    length(L1,N),
    append(L1,L2,L),!,
    partition(N,L2,[L1|Ls1],Ls2).
partition(N,[],Ls1,Ls2) :-
    N > 0,
    reverse(Ls1,Ls2),!.
partition(N,L,Ls1,Ls2) :-
    N > 0,
    reverse([L|Ls1],Ls2),!.



% Conversion from 0/1 classified labels in term order to bitset order
% reverse the order of labels (list, FIFO) to match the orientation of bitset
% whose lowest magnitude side is the rhs

phenotypic_effects_bitset(OutPath,Conds,Bs) :-
    phenotypic_effects(OutPath,Conds,Labels),
    reverse(Labels,LabelsReversed),
    lm_ltob(LabelsReversed,Bs),!.



% phenotypic_effects/2 is the batch-running version of phenotypic effect
%   simulator growth given *** mulitple growth medium compositions ***
%
% Conds is a list of ground terms with each element being [ORFs:Term/list,Nutrients:list].
phenotypic_effects(OutPath,Conds,Labels) :-
    phenotypic_effects(OutPath,Conds,_,Labels).
phenotypic_effects(OutPath,Conditions,SNum,Labels) :-
    Conditions = [_|_],!,
    target_growth_composition(EndBitSet),
    convert_composition(OutPath,mstate,Conditions,N),
%    trace,
    lm_prod_trans_p(OutPath,[mstate,3]),

    % saturate metabolites based on reactant/product matrices
    reaction_closure_p(OutPath,mstate,5,SNum),

    % without batch parallelisation
%    reaction_closure(mstate,5,SNum),

%    current_prolog_flag(max_integer_size,Max),
%    current_prolog_flag(stack_limit,Max1),

    mname(mstate,SNum,MFinal),
    numlist(0,N,NL),
    findall(L,
            (
                member(X,NL),
                call(MFinal,X,Y),
                (bit_subset_chk(EndBitSet,Y) -> L = 0; L = 1)
            ),
            Labels).



%phenotypic_effects_par(OutPath,[Conds|Cs],CurLabels,AllLabels) :-
%    phenotypic_effects(OutPath,Conds,_,Labels1),
%    append(CurLabels,Labels1,Labels2),!,
%    phenotypic_effects_par(OutPath,Cs,Labels2,AllLabels).
%phenotypic_effects_par(_,[],Labels,Labels).



reaction_closure(OutPath,P,N,SNum) :-
    % get possible reactions as bitsets
    % write reaction bitset as a new reaction state
    % state No + 1

    all_submatrix(OutPath,[P,N],[P,1],[P,N1]),

    % subtract the prohibited reaction indices
    % state No + 2

    lm_subtract(OutPath,[P,N1],[P,2],[P,N2]),

    % allowed reactions (BSet) * reaction product matrix
    % parallelising is not faster due to only one row
    % of allowed reactions
    %
    % reach a new metabolite composition state
    % state No + 3

    lm_prod(OutPath,[P,N2],[P,3],[P,N3]),

    % add produced metabolites to previous state
    % state No + 4

    N4 is N3 + 4,
    lm_add(OutPath,[P,N],[P,N3],[P,N4]),

    % compare with the previous state
    \+lm_eq([P,N],[P,N4]),!,
    reaction_closure(OutPath,P,N4,SNum).
reaction_closure(_,_,N,N) :- !.



reaction_closure_p(OutPath,P,N,SNum) :-
    % get possible reactions as bitsets
    % write reaction bitset as a new reaction state
    % state No + 1

    all_submatrix_p(OutPath,[P,N],[P,1],[P,N1]),

    % subtract the prohibited reaction indices
    % state No + 2

    lm_subtract_p(OutPath,[P,N1],[P,2],[P,N2]),

    % allowed reactions (BSet) * reaction product matrix
    % parallelising is not faster due to only one row
    % reach a new metabolite composition state
    % state No + 3

    lm_prod_p(OutPath,[P,N2],[P,3],[P,N3]),

    % add produced metabolites to previous state
    % state No + 4

    N4 is N3 + 4,
    lm_add_p(OutPath,[P,N],[P,N3],[P,N4]),

    % compare with the previous state
    \+lm_eq([P,N],[P,N4]),!,
    reaction_closure_p(OutPath,P,N4,SNum).
reaction_closure_p(_,_,N,N) :- !.



% Conversion of medium compositions into bitset format
% identify KO enzymes and reactions to be prohibited
% as bitsets for binary operations

convert_composition(OutPath,P,Conds,N) :-
    % recreate allowed reaction matrix
    create_row_matrix(OutPath,P,2,_),
    % recreate starting state matrix
    create_row_matrix(OutPath,P,5,_),
    convert_composition(OutPath,P,0,N,Conds).
convert_composition(OutPath,P,I1,I2,[[ORF,Nutrients]|Cond]) :-
    growth_medium_composition(Nutrients,_,StartBitSet),
    knocked_out_reactions(ORF,_,DeletedReactions),
    findall(Id,
           (
            member(R,DeletedReactions),
            rid(R,Id)
           ),Rs),
    lm_stob1(Rs,DeletedReactionsBS),
    write_row_matrix(OutPath,P,2,I1,DeletedReactionsBS,append),
    % define metabolic state 1
    write_row_matrix(OutPath,P,5,I1,StartBitSet,append),
    I3 is I1 + 1,!,
    convert_composition(OutPath,P,I3,I2,Cond).
convert_composition(_,_,I,I,[]).


% All reactions/enzymes should fire unless a knockout
% prevents them from firing
%
% All related enzyme functions are recognised using codes/2

knocked_out_enzymes_([],G,G,R,R).

knocked_out_enzymes_([Enz|Enzs],G1,G2,R1,R2) :-
    enzyme(Enz,_,RNames,_Direction,_Day,_LHS,_RHS),
    findall(ORF,codes(ORF,Enz),ORFs),!,
    union(ORFs,G1,G3),
    append(R1,RNames,R3),
    knocked_out_enzymes_(Enzs,G3,G2,R3,R2).

knocked_out_enzymes_([_|Enzs],G1,G2,R1,R2) :-
    knocked_out_enzymes_(Enzs,G1,G2,R1,R2).



% Find which enzymes are affected by KOing the ORF(s)
% return the list of reactions affected

% If alternative enzymes can still catalyse some reactions,
% these reactions are excluded from the prohibited set

knocked_out_reactions(ORFs,RelatedORFs,Rs) :-
    ORFs = [_|_],!,
    findall(Enz,(member(ORF,ORFs),codes(ORF,Enz)),KnockedOutEnz),
    affected_reactions(ORFs,KnockedOutEnz,RelatedORFs,Rs).


knocked_out_reactions(ORF,RelatedORFs,Rs) :-
    findall(Enz,codes(ORF,Enz),KnockedOutEnz),
    affected_reactions([ORF],KnockedOutEnz,RelatedORFs,Rs).



% Identify which reactions are affected by KO ORF(s)
% keep those reactions with alternative ORF sources
%
% Given enzyme functions related to KOed ORFs,
% this also gives all reactions that are affected
%
% However, actual affected reactions would be a subset
% due to possible alternative genes/enzymes firing,
% represented by codes/2.
%
% These reactions are exempted from being prohibited.

affected_reactions(ORFs,KnockedOut,RelatedORFs,RsSet) :-
    % get all ORFs related to the knockout enzymes
    knocked_out_enzymes_(KnockedOut,[],RelatedORFs,[],Rs1),!,
    % identify reactions/enzymes with unaffected alternative ORF sources
    findall(R,
        (
            member(R,Rs1),
            % reaction with alternative enzymes
            (
                % which enzyme/7 catalyses a given reaction
                enzyme(Enz,_,Rnames,_,_,_,_),
                memberchk(R,Rnames),
                \+((
                        codes(G,Enz),
                        memberchk(G,ORFs)
                ))
            )
        ),
        Rs2),
    % exempt these reactions from deletion in the database
    subtract(Rs1,Rs2,Rs),
    sort(Rs,RsSet).



% evaluate if the defined growth condition has been satisfied
% provides methods for checking both bitset and term

reach_endbs(BitSet) :-
    target_growth_composition(EndBitSet),
    bit_subset(EndBitSet,BitSet),!,
    writeln('\n% No effect on growth!\n').
reach_endbs(_) :-
    writeln("\n% Phenotypic effect confirmed!\n"),fail.

reach_end(Set) :-
    ends(Ends),
    subset(Ends,Set),!,
    writeln('\n% No effect on growth!\n').
reach_end(_) :-
    writeln("\n% Phenotypic effect confirmed!\n"),fail.