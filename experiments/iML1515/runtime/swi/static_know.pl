%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% growth environment definitions at the start
% and end of a cycle

growth_medium_composition(
    [
        o2_e,
        cl_e,
        na1_e,
        pi_e,
        cl_e,
        h_e,
        mg2_e,
        ca2_e,
        h2o_e,
        so4_e,
        nh4_e,
        k_e,
        co2_e,
        atp_c,
        nad_c,
        nadph_c,
        nadp_c,
        % optional metabolites
        'ACP_c', % Acyl carrier protein
        flxr_c, % Flavodoxin reduced
        moco_c,
        thm_c,
        adocbl_c,
        lipopb_c,
        sufbcd_c,
        sufse_c,
        trdrd_c,
        trnaglu_c,
        coa_c
    ]
).

optional_metabolites(
    [
        'ACP_c', % Acyl carrier protein
        flxr_c, % Flavodoxin reduced
        moco_c,
        thm_c,
        adocbl_c,
        lipopb_c,
        sufbcd_c,
        sufse_c,
        trdrd_c,
        trnaglu_c,
        coa_c
    ]
).

start(o2_e).
start(cl_e).
start(na1_e).
start(pi_e).
start(cl_e).
start(h_e).
start(mg2_e).
start(ca2_e).
start(h2o_e).
start(so4_e).
start(nh4_e).
start(k_e).
start(co2_e).
start(atp_c).
start(nad_c).
start(nadph_c).
start(nadp_c).
start('ACP_c').
start(flxr_c).
start(moco_c).
start(thm_c).
start(adocbl_c).
start(lipopb_c).
start(sufbcd_c).
start(sufse_c).
start(trdrd_c).
start(trnaglu_c).
start(coa_c).


% BIGG ids of essential metabolites

ends(['10fthf_c','2dmmql8_c','2fe2s_c','4fe4s_c','5mthf_c',accoa_c,adocbl_c,ala__L_c,amet_c,arg__L_c,asn__L_c,asp__L_c,atp_c,btn_c,ca2_c,chor_c,cl_c,clpn160_p,clpn161_p,clpn181_p,coa_c,cobalt2_c,colipa_e,ctp_c,cu2_c,cys__L_c,datp_c,dctp_c,dgtp_c,dttp_c,enter_c,fad_c,fe2_c,fe3_c,gln__L_c,glu__L_c,gly_c,glycogen_c,gthrd_c,gtp_c,h2o_c,hemeO_c,his__L_c,ile__L_c,k_c,leu__L_c,lipopb_c,lys__L_c,malcoa_c,met__L_c,mg2_c,mlthf_c,mn2_c,mobd_c,mococdp_c,mocogdp_c,mql8_c,murein3p3p_p,murein3px4p_p,murein4p4p_p,murein4px4p_p,murein4px4px4p_p,nad_c,nadh_c,nadp_c,nadph_c,nh4_c,ni2_c,pe160_p,pe161_p,pe181_p,pg160_p,pg161_p,pg181_p,phe__L_c,pheme_c,pro__L_c,ptrc_c,pydx5p_c,q8h2_c,ribflv_c,ser__L_c,sheme_c,so4_c,spmd_c,succoa_c,thf_c,thmpp_c,thr__L_c,trp__L_c,tyr__L_c,udcpdp_c,utp_c,val__L_c,zn2_c]).
end('10fthf_c').
end('2dmmql8_c').
end('2fe2s_c').
end('4fe4s_c').
end('5mthf_c').
end(accoa_c).
end(adocbl_c).
end(ala__L_c).
end(amet_c).
end(arg__L_c).
end(asn__L_c).
end(asp__L_c).
end(atp_c).
end(btn_c).
end(ca2_c).
end(chor_c).
end(cl_c).
end(clpn160_p).
end(clpn161_p).
end(clpn181_p).
end(coa_c).
end(cobalt2_c).
end(colipa_e).
end(ctp_c).
end(cu2_c).
end(cys__L_c).
end(datp_c).
end(dctp_c).
end(dgtp_c).
end(dttp_c).
end(enter_c).
end(fad_c).
end(fe2_c).
end(fe3_c).
end(gln__L_c).
end(glu__L_c).
end(gly_c).
end(glycogen_c).
end(gthrd_c).
end(gtp_c).
end(h2o_c).
end(hemeO_c).
end(his__L_c).
end(ile__L_c).
end(k_c).
end(leu__L_c).
end(lipopb_c).
end(lys__L_c).
end(malcoa_c).
end(met__L_c).
end(mg2_c).
end(mlthf_c).
end(mn2_c).
end(mobd_c).
end(mococdp_c).
end(mocogdp_c).
end(mql8_c).
end(murein3p3p_p).
end(murein3px4p_p).
end(murein4p4p_p).
end(murein4px4p_p).
end(murein4px4px4p_p).
end(nad_c).
end(nadh_c).
end(nadp_c).
end(nadph_c).
end(nh4_c).
end(ni2_c).
end(pe160_p).
end(pe161_p).
end(pe181_p).
end(pg160_p).
end(pg161_p).
end(pg181_p).
end(phe__L_c).
end(pheme_c).
end(pro__L_c).
end(ptrc_c).
end(pydx5p_c).
end(q8h2_c).
end(ribflv_c).
end(ser__L_c).
end(sheme_c).
end(so4_c).
end(spmd_c).
end(succoa_c).
end(thf_c).
end(thmpp_c).
end(thr__L_c).
end(trp__L_c).
end(tyr__L_c).
end(udcpdp_c).
end(utp_c).
end(val__L_c).
end(zn2_c).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inhibitor(+orf,[+reaction_id|Enzymes],+enz_class,[+met|Metabolites])

% inhibitor/4 states that each of the given list of metabolites
% inhibits the function of the enzyme(s) coded for by the given ORF


% orf - open reading fram
% reaction_id - unique enzyme id number
% enz_class - Enzyme Commision enzyme class
% met - metabolite number

inhibitor(_,[],_,[]).

% new_enzyme/4 - find/test non-import reactions

new_enzyme(EnzId,EnzClass,Reactants,Products) :-
       enzyme(EnzId,Orfs,EnzClass,_Direction,_Day,Reactants,Products),
       \+Orfs == [import].


% used to convert metabolites appearing in 2nd argument of phenotypic_effect/2

change_all_metabolites([],RDone,Changed) :-
       reverse(RDone,Changed).

change_all_metabolites([M|Metabolites],Done,Changed) :-
       change_metabolite(M,CM),!,
       change_all_metabolites(Metabolites,[CM|Done],Changed).


change_metabolite(Metabolite,NewMetabolite) :-
       name(Metabolite,[_C|Ascii]),
       conc([73],Ascii,NewAscii),
       name(NewMetabolite,NewAscii).

% inhibited/2 - test whether an enzyme is inhibited by the
% current cell contents

inhibited(EnzId1,Starts) :-
       inhibitor(_Orf,EnzIds,_,List),
       member(EnzId1,EnzIds),
       member(Inhib,Starts),
       member(Inhib,List).


same_enzyme(EnzId1,EnzId2) :-
       EnzId1 == EnzId2.


% same_enzyme_function/9 is true if those metabolites on the RHS
% that belong to the main pathway are the same for each enzyme,
% A metabolite belongs to the main pathway if it appears in the
% starts,is an end product,or appears in the LHS lists of the enzyme
% definitions.

% assumes only forwards direction - could be made reversible if
% direction was taken into account and the RHS was used when the
% system ran backwards

% may cause exhaustion of resource and no termination
% as some reactions are blocked but member/2 in enzyme1/8
% may cause it to backtrack.

same_enzyme_function(EnzClass1,EnzClass2,
                   Lefts,_LHS1,RHS1,_LHS2,RHS2) :-
       EnzClass1 == EnzClass2,
       main_pathway_rights(RHS1,Lefts,[],Mains1),
       main_pathway_rights(RHS2,Lefts,[],Mains2), !,%
       quicksort_mets(Mains1,SortedMains1),
       quicksort_mets(Mains2,SortedMains2),
       SortedMains1 == SortedMains2.
       %write(Enzyme:Enzyme2),nl,
       %write(Reactants:R1),nl,
       %write(Products:R2),nl.
       %write('evaluate_enzyme succeeded'),nl.


% gene_sharing/2 tests to see if an enzyme (reaction_id) can be made by two
% or more genes (shared)

% BIGG data have a unique id for each orf (gene) which may appear in
% two reactions if enzymes share the same (gene)

% complex enzyme can take serval orfs to encode
% check if orfs are shared by multiple enzymes in different reactions
% then see if two enzymes of interests belong to that set

gene_sharing(EnzId1,EnzId2) :-
       shared_orfs(_Gene,EnzIds),
       member(EnzId1,EnzIds),
       member(EnzId2,EnzIds).

% An enzyme can't be used if is the same enzyme as those produced
% by the knocked out orf (including those enzymes ``shared'' - i.e.
% where two or more orfs are required to produce the enzyme)

cant_use_enzyme(CantUse,EnzId1,EnzId2,_EnzClass1,_EnzClass2,
                _Lefts,_LHS1,_RHS1,_LHS2,_RHS2) :-
       member(EnzId1,CantUse),
       member(EnzId2,CantUse).

cant_use_enzyme(_CantUse,EnzId1,EnzId2,_EnzClass1,_EnzClass2,
                _Lefts,_LHS1,_RHS1,_LHS2,_RHS2) :-
       same_enzyme(EnzId1,EnzId2).

% fails when multiple enzymes are related to the same gene
% only one path is deleted, these enzymes may not have the
% same enzyme function
%cant_use_enzyme(_Knockout,EnzId1,EnzId2,EnzClass1,EnzClass2,
%                Lefts,LHS1,RHS1,LHS2,RHS2) :-
%       same_enzyme_function(EnzClass1,EnzClass2,
%                   Lefts,LHS1,RHS1,LHS2,RHS2),
%       same_enzyme(EnzId1,EnzId2).
%
%cant_use_enzyme(_Knockout,EnzId1,EnzId2,EnzClass1,EnzClass2,
%                Lefts,LHS1,RHS1,LHS2,RHS2) :-
%       same_enzyme_function(EnzClass1,EnzClass2,
%                   Lefts,LHS1,RHS1,LHS2,RHS2),
%       gene_sharing(EnzId1,EnzId2).


% uses Transitive Closure

% All Metabolites added to the minimal media are converted to import
% metabolites and added to the starts. Pathway reactions are
% tested by evaluating each enzyme at a time - deciding whether
% the enzyme is available (i.e not produced by a knocked out ORF)
% and adding any metabolites formed by the reaction.

% backtracking ensures all (allowable) reactions are tested. If
% the end products are not found in the results from this process
% the procedure succeeds i.e. phenotypic_effect/2 succeeds if
% there is NO GROWTH for the given ORF and nutrients (metabolites
% added to the minimal media)

% When the model is used in hypotheses generation,the encodes/5
% fact is constructed by the learning step and appears in the
% hypotheses generated (the codes/7 facts are omitted from the model)

phenotypic_effect(ORF,Nutrients) :-
       growth_medium_composition(Minimal),
       union(Minimal,Nutrients,Starts),
       nl,write('% Starts: '),write(Starts),nl,
       bagof(End,end(End),Ends),
       find_knocked_out_enzymes(ORF,ALL,KnockedOut),!,
       all_lefts(Lefts),
       write('% Knockout enzymes: '),writeln(KnockedOut),nl,
       new_enzyme(EnzId,EnzClass,LHS,RHS),
       encodes(ORF,EnzId,EnzClass,LHS,RHS),
%       write('% Path deleted: '),write(ORF),ns,writeln(EnzId),nl,
       connected_without_this_step(ALL,KnockedOut,Starts,MutantProducts,
                                    EnzId,EnzClass,Lefts,LHS,RHS,1),
       sort(MutantProducts,M1),
       nl,write('% Mutant products: '),write_list(M1),nl,
       \+subset(Ends,MutantProducts),
       nl,write('% Missing products: '),
       bagof(P,(member(P,Ends),not(member(P,MutantProducts))),Ps),
       write_list(Ps),nl,
       writeln('% Phenotypic effect confirmed!'),nl.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% connected_without_this_step/5 succeeds if all of the end points can
% be reached from the start points without involving the reaction
% specified in the 3rd,4th and 5th terms.

connected_without_this_step(Enzymes,KnockedOut,Starts1,Ends,EnzId,EnzClass,
                            Lefts,Reactants,Products,Day) :-
       expand_without_this_step(Enzymes,KnockedOut,Starts1,Starts2,EnzId,EnzClass,
                                 Lefts,Reactants,Products,Day,RestEnzymes),!,
       connected_without_this_step(RestEnzymes,KnockedOut,Starts2,Ends,EnzId,EnzClass,
                                    Lefts,Reactants,Products,Day).

connected_without_this_step(_Enzymes,_KnockedOut,Starts,Starts,_EnzId,_EnzClass,
                            _Lefts,_Reactants,_Products,_Day).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% expand_without_this_step/9 attempts to add new metabolites from a
% reaction checking that the enzyme catalysing the reaction is:

%    1) Not inhibited by any of the current cell products
%    2) Available for use (not coded for by the knocked out gene)


expand_without_this_step(Enzymes,CantUse,Starts1,Starts2,EnzId1,EnzClass1,Lefts,
                      Reactants,Products,Day,RestEnzymes) :-
       enzyme1(Enzymes,EnzId2,Orfs,EnzClass2,R1,R2,Starts1,Day),
       \+pseudo_reaction(EnzId2,Orfs,EnzClass2),
       \+inhibited(EnzId2,Starts1),
       \+cant_use_enzyme(CantUse,EnzId1,EnzId2,EnzClass1,EnzClass2,
                               Lefts,Reactants,Products,R1,R2),
       valid_reactants(R1,R2,Starts1,1,I,RHS),
       union(RHS,Starts1,Starts2),
       has_visited(Enzymes,EnzId2,Orfs,EnzClass2,I,RestEnzymes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% neglect some pseudo reactions

pseudo_reaction(EnzId,Orfs,EC) :-
    enzyme(EnzId,Orfs,EC,1,_,_,[[]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see if some reactions have been visited

has_visited(Enzymes,EnzId,[G],[R],_I,Rest) :-
    delete(Enzymes,enzyme(EnzId,[G],[R],_Direction,_Day,_Reactants,_Products),Rest).
has_visited(Enzymes,EnzId,Orfs,Reactions,I,
            [enzyme(EnzId,Orfs,ReactionsRest,Direction,Day,ReactantsRest,ProductsRest)|Rest]):-
    nth1(_,Enzymes,enzyme(EnzId,Orfs,Reactions,Direction,Day,Reactants,Products),Rest),
    nth1(I,Reactions,_,ReactionsRest),
    nth1(I,Reactants,_,ReactantsRest),
    nth1(I,Products,_,ProductsRest),!.

%not_visited(EnzId) :-
%    \+visited(EnzId),!.
%
%has_visited(EnzId,[_Reaction]) :-
%    asserta(visited(EnzId)),!.
%has_visited(_,_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mandatory_nutrients/1

mandatory_nutrients([]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ignoring Direction and Day:
% Direction is always forward only
% Only considering Day = 1

encodes(ORF,EnzId,Type,Reactants1,Reactants2) :-
       codes(ORF,EnzId,Type,_Direction,_Day,Reactants1,Reactants2).
codes(ORF,EnzId,Type,_,_,Reactants1,Reactants2) :-
    enzyme(EnzId,_,Type,_,_,Reactants1,Reactants2),
    codes(ORF,EnzId).
%codes(ORF,EnzId,Type,_,_,Reactants1,Reactants2) :-
%    enzyme(EnzId,Orfs,Type,_,_,Reactants1,Reactants2),
%    member(ORF,Orfs).


%enzyme(EnzId,Orfs,Type,Reactants1,Reactants2) :-
%       enzyme(EnzId,Orfs,Type,Direction,Day,Reactants1,Reactants2).

enzyme1(Enzymes,EnzId,Orfs,Enzyme,R1,R2,_Starts,Day) :-
       enz(Enzymes,EnzId,Orfs,Enzyme,R1,R2,Day).


enz(Enzymes,EnzId,Orfs,Ec,R1,R2,Day) :-
       member(enzyme(EnzId,Orfs,Ec,1,D,R1,R2),Enzymes),     % non reverse
       D =< Day.                                            % tests time

enz(Enzymes,EnzId,Orfs,Ec,R1,R2,Day) :-
       member(enzyme(EnzId,Orfs,Ec,2,D,R1,R2),Enzymes),     % reverse
       D =< Day.

enz(Enzymes,EnzId,Orfs,Ec,R2,R1,Day) :-
       member(enzyme(EnzId,Orfs,Ec,2,D,R1,R2),Enzymes),     % reverse
       D =< Day.

% valid_reactants/6 ensures that a new reaction is evaluated when an
% enzyme evaluated - used when more than one reaction is coded for by
% one ORF

% i.e. all new metabolites are are eventually added

valid_reactants([LHS|_Lefts],Rights,Starts,I,I,RHS) :-
       subset(LHS,Starts),
       find_pos(1,I,Rights,RHS),
       \+subset(RHS,Starts).

valid_reactants([_LHS|Lefts],Rights,Starts,I,I3,RHS) :-
       I2 is I + 1,
       valid_reactants(Lefts,Rights,Starts,I2,I3,RHS).


find_pos(I,N,[RHS|_Rights],RHS) :-
       I == N.

find_pos(I,N,[_RHS|Rights],Found) :-
       I2 is I + 1,
       find_pos(I2,N,Rights,Found).



in_mets_list(Metabolite,[MList|_LHS]) :-
       member(Metabolite,MList).

in_mets_list(Metabolite,[_MList|LHS]) :-
       in_mets_list(Metabolite,LHS).


in_lhs(Metabolite,[LHS|_Lefts]) :-
       in_mets_list(Metabolite,LHS).

in_lhs(Metabolite,[_LHS|Lefts]) :-
       in_lhs(Metabolite,Lefts).


main_pathway(Metabolite,_Lefts) :-
       start(Metabolite).

main_pathway(Metabolite,Lefts) :-
       in_lhs(Metabolite,Lefts).

main_pathway(Metabolite,_Lefts) :-
       end(Metabolite).


all_lefts(Lefts) :-
       bagof(LHS,EId^Genes^EC^Dir^Day^RHS^enzyme(EId,Genes,EC,Dir,Day,LHS,RHS),Lefts).


main_pathway_rhs([],_Lefts,Mains,Mains).

main_pathway_rhs([Met|Metabolites],Lefts,Done,Mains) :-
       main_pathway(Met,Lefts),
       main_pathway_rhs(Metabolites,Lefts,[Met|Done],Mains).

main_pathway_rhs([_Met|Metabolites],Lefts,Done,Mains) :-
       main_pathway_rhs(Metabolites,Lefts,Done,Mains).


main_pathway_rights([],_Lefts,Mains,Mains).

main_pathway_rights([RHS|Rights],Lefts,Done,Mains) :-
       main_pathway_rhs(RHS,Lefts,[],Found),
%       conc to union
       union(Done,Found,NewDone),
       main_pathway_rights(Rights,Lefts,NewDone,Mains).


quicksort_mets([],[]).

quicksort_mets([X|Tail],Sorted) :-
         split_mets(X,Tail,Small,Big),
         quicksort_mets(Small,SortedSmall),
         quicksort_mets(Big,SortedBig),
         append(SortedSmall,[X|SortedBig],Sorted).

split_mets(_,[],[],[]).

split_mets(X,[Y|Tail],[Y|Small],Big) :-
         X @> Y,!,
         split_mets(X,Tail,Small,Big).

split_mets(X,[Y|Tail],Small,[Y|Big]) :-
         split_mets(X,Tail,Small,Big).


find_all_enzymes(Enzymes) :-
       bagof(enzyme(EnzId,Orfs,EnzClass,Direction,Day,LHS,RHS),
             enzyme(EnzId,Orfs,EnzClass,Direction,Day,LHS,RHS),Enzymes).

knocked_out_enzymes(_Orf,[],KnockedOut,KnockedOut).

knocked_out_enzymes(Orf,[Enz|Enzymes],Done,KnockedOut) :-
       Enz = enzyme(EnzId,Orfs,_EnzClass,_Direction,_Day,_LHS,_RHS),
       member(Orf,Orfs),
       knocked_out_enzymes(Orf,Enzymes,[EnzId|Done],KnockedOut).

knocked_out_enzymes(Orf,[_Enz|Enzymes],Done,KnockedOut) :-
       knocked_out_enzymes(Orf,Enzymes,Done,KnockedOut).


% find which enzymes are affected by KOing the orf
% return the list of enzymes (enzId) affected
% these enzIds can be used to track down reactions affected

find_knocked_out_enzymes(Orf,Enzymes,KnockedOut) :-
       find_all_enzymes(Enzymes),
       knocked_out_enzymes(Orf,Enzymes,[],KnockedOut).


knocked_out_enzyme(EnzId,KnockedOut) :-
       member(EnzId,KnockedOut).

cost(phenotypic_effect(_,Ms),N) :-
    length(Ms,N).

