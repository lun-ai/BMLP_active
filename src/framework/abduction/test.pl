:- [run].
:- [exp_select].
:- ['src/framework/lmatrix/lmarith.pl'].
:- ['src/framework/deduction/simulator.pl'].

ex(0,phenotypic_effect(b3708,[ac_e])).
ex(1,phenotypic_effect(b3708,[gal_e])).
ex(2,phenotypic_effect(b3708,[glcn_e])).

abd(0,[codes(b3708,enz100)]).
abd(1,[codes(b3708,enz1000)]).

abdm(0,5).
abdm(1,3).

h_stat(0,[codes(b3708,enz100)],1,2,0.8888888888888888,-1,-0.8888888888888888).
h_stat(1,[codes(b3708,enz1000)],-2,0.25,0.1111111111111111,-4,-0.4444444444444444).

unit_cost(1.0).

% assumes base metabolite cost is negligible
base_mcost(0.0).

mcost('ac_e',0.0748).
mcost('gal_e',0.534).
mcost('glcn_e',0.0359).
mcost('glc__D_e',0.0476).
mcost('glyc_e',0.07).
mcost('ala__L_e',0.81).
mcost('lac__L_e',0.0546).
mcost('malt_e',0.244).
mcost('mnl_e',0.0936).
mcost('acgam_e',2.93).
mcost('akg_e',0.437).
mcost('pyr_e',0.2776).
mcost('rib__D_e',0.993).
mcost('sbt__D_e',0.196).
mcost('succ_e',0.0825).
mcost('xyl__D_e',0.51).

:- begin_tests(compression).

test(comp_calc1) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0 %codes(b3708,enz100)
         ],
    PIds = [0,2],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),Terms),
    told,
    Comp is (1 - (1 / (2 + 0.1)) * (0 + 1)),
    TwoPowerComp is 2**Comp,
    assertion(
        Terms==[
                comp(0,[codes(b3708,enz100)],Comp,TwoPowerComp)
            ]
    ).

test(comp_calc2) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            1 %codes(b3708,enz1000)
         ],
    PIds = [0,2],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),Terms),
    told,
    Comp is (1 - (1 / (2 + 0.1)) * (1 + 1)),
    TwoPowerComp is 2**Comp,
    assertion(
        Terms==[
                    comp(1,[codes(b3708,enz1000)],Comp,TwoPowerComp)
               ]
    ).

test(single_comp3) :-
%    Pos=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
%    Neg=[
%            ex(2,phenotypic_effect(b3708,[glcn_e])),
%            ex(0,phenotypic_effect(b3708,[ac_e]))
%        ],
    AIds=[
         ],
    PIds = [1],
    NIds = [0,2],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),Terms),
    told,
    assertion(
        Terms==[]
    ).

test(multi_comp1) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0, % codes(b3708,enz100),
            1 % codes(b3708,enz1000)
         ],
    PIds = [0],
    NIds = [1,2],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),Terms),
    told,
    sort(Terms,SortedTerms),
    comp_calc(2,1,1,Comp1,TwoPowerComp1),
    comp_calc(2,1,1,Comp1,TwoPowerComp1),
    assertion(
        SortedTerms==[
                        comp(0,[codes(b3708,enz100)],Comp1,TwoPowerComp1),
                        comp(1,[codes(b3708,enz1000)],Comp1,TwoPowerComp1)
                     ]
    ).

:- end_tests(compression).

:- begin_tests(stat).

test(single_stat1) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0 %codes(b3708,enz100)
         ],
    PIds = [0,2],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),CompTerms),
    told,
    sort(CompTerms,SortedCompTerms),
    findall(TwoPowerComp,member(comp(_,_,_,TwoPowerComp),SortedCompTerms),TwoPowerComps),
    sum_elements_in_list(TwoPowerComps,Sum),
    tell('/dev/null'),
    findall(StatTerm,
            (
                member(comp(AId,A,Comp,TwoPowerComp),SortedCompTerms),
                hypoth_stat_(AId,A,Comp,TwoPowerComp,Sum,StatTerm)
            ),
            StatTerms),
    told,
    SortedCompTerms=[comp(0,[codes(b3708,enz100)],Comp,TwoPowerComp)],
    sort(StatTerms,SortedStatTerms),
    assertion(SortedStatTerms==[
                                    h_stat(0,[codes(b3708,enz100)],Comp,TwoPowerComp,1.0,0,0.0)
                               ]).

test(multi_stat1) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0, % codes(b3708,enz100),
            1 % codes(b3708,enz1000)
         ],
    PIds = [0,2],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),CompTerms),
    told,
    sort(CompTerms,SortedCompTerms),
    assertion(
        SortedCompTerms==[
                        comp(0,[codes(b3708,enz100)],0.5238095238095238,1.4377466974450177),
                        comp(1,[codes(b3708,enz1000)],0.04761904761904767,1.0335577830070277)
                     ]
    ),
    findall(TwoPowerComp,member(comp(_,_,_,TwoPowerComp),SortedCompTerms),TwoPowerComps),
    sum_elements_in_list(TwoPowerComps,Sum),
    tell('/dev/null'),
    findall(StatTerm,
            (
                member(comp(AId,A,Comp,TwoPowerComp),SortedCompTerms),
                hypoth_stat_(AId,A,Comp,TwoPowerComp,Sum,StatTerm)
            ),
            StatTerms),
    told,
    sort(StatTerms,SortedStatTerms),
    assertion(SortedStatTerms==[
                                    h_stat(0,[codes(b3708,enz100)],0.5238095238095238,1.4377466974450177,0.5817764297428978,-1,-0.5817764297428978),
                                    h_stat(1,[codes(b3708,enz1000)],0.04761904761904767,1.0335577830070277,0.41822357025710233,-2,-0.8364471405142047)
                               ]).

:- end_tests(stat).


:- begin_tests(ec).

test(negative_ex_only1) :-
%    Pos=[],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0 % codes(b3708,enz100)
         ],
    PIds = [],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),CompTerms),
    told,
    sort(CompTerms,SortedCompTerms),
    assertion(SortedCompTerms==[comp(0,[codes(b3708,enz100)],-9.0,0.001953125)]),
    findall(TwoPowerComp,member(comp(_,_,_,TwoPowerComp),SortedCompTerms),TwoPowerComps),
    sum_elements_in_list(TwoPowerComps,Sum),
    assertion(Sum==0.001953125),
    tell('/dev/null'),
    told.

test(single_ec1) :-
%    Pos=[
%            ex(0,phenotypic_effect(b3708,[ac_e])),
%            ex(2,phenotypic_effect(b3708,[glcn_e]))
%        ],
%    Neg=[
%            ex(1,phenotypic_effect(b3708,[gal_e]))
%        ],
    AIds=[
            0 % codes(b3708,enz100)
         ],
    PIds = [0,2],
    NIds = [1],
    append(PIds,NIds,EIds),
    tell('/dev/null'),
    findall(Term,(member(AId,AIds),hypoth_compression_(EIds,PIds,NIds,AId,Term)),CompTerms),
    told,
    sort(CompTerms,SortedCompTerms),
    assertion(
        SortedCompTerms==[
                        comp(0,[codes(b3708,enz100)],0.5238095238095238,1.4377466974450177)
                     ]
    ),
    findall(TwoPowerComp,member(comp(_,_,_,TwoPowerComp),SortedCompTerms),TwoPowerComps),
    sum_elements_in_list(TwoPowerComps,Sum),
    tell('/dev/null'),
    findall(StatTerm,
            (
                member(comp(AId,A,Comp,TwoPowerComp),SortedCompTerms),
                hypoth_stat_(AId,A,Comp,TwoPowerComp,Sum,StatTerm)
            ),
            StatTerms),
    told,
    sort(StatTerms,SortedStatTerms),
    assertion(SortedStatTerms==[
                                    h_stat(0,[codes(b3708,enz100)],0.5238095238095238,1.4377466974450177,1.0,0,0.0)
                               ]),
    mean_cost([0,1,2],MC),
    expected_cost(MC,3,2,TC,RestMC,PS,CEC,IEC,EC),
    assertion(TC==0.0359),
    assertion(RestMC==0.3044),
    assertion(PS==0.8888888888888888),
    assertion(CEC==0.27057777777777775),
    assertion(IEC==0.13528888888888888),
    assertion(EC==0.29144567901234564).

:- end_tests(ec).

:- begin_tests(abduction_batch).

% TBC
%test(multi_sim_multi_conds3) :-
%    phenotypic_effects(
%        [
%            [[b3708],[ac_e]],
%            [[b1249],[acgam_e]],
%            [[b0002],[pyr_e]],
%            [[b0009],[acgam_e]],
%            [[b0033],[mnl_e]],
%            [[b0038],[succ_e]],
%            [[b0047],[sbt__D_e]],
%            [[b0054],[glc__D_e]],
%            [[b0091],[ala__L_e]],
%            [[b0142],[pyr_e]]
%        ],
%        _,Ids
%    ),
%    phenotypic_effects(
%        2,
%        [
%            [[b3708],[ac_e]],
%            [[b1249],[acgam_e]],
%            [[b0002],[pyr_e]],
%            [[b0009],[acgam_e]],
%            [[b0033],[mnl_e]],
%            [[b0038],[succ_e]],
%            [[b0047],[sbt__D_e]],
%            [[b0054],[glc__D_e]],
%            [[b0091],[ala__L_e]],
%            [[b0142],[pyr_e]]
%        ],
%        Ids1
%    ),
%    phenotypic_effects_bitset(
%        2,
%        [
%            [[b3708],[ac_e]],
%            [[b1249],[acgam_e]],
%            [[b0002],[pyr_e]],
%            [[b0009],[acgam_e]],
%            [[b0033],[mnl_e]],
%            [[b0038],[succ_e]],
%            [[b0047],[sbt__D_e]],
%            [[b0054],[glc__D_e]],
%            [[b0091],[ala__L_e]],
%            [[b0142],[pyr_e]]
%        ],Bs
%    ),
%    assertion(Ids==[0,0,0,0,0,0,0,1,1,1]),
%    assertion(Ids==Ids1),
%    reverse(Ids,Ids2),
%    lm_ltob(Ids2,Bs1),
%    assertion(Bs==Bs1).
%
%
%% check if results of partitioned simulations
%%   with different sizes are consistent
%
%test(multi_sim_multi_conds4) :-
%    phenotypic_effects_bitset(
%        3,
%        [
%            [[b3708],[ac_e]],
%            [[b1249],[acgam_e]],
%            [[b0002],[pyr_e]],
%            [[b0009],[acgam_e]],
%            [[b0033],[mnl_e]],
%            [[b0038],[succ_e]],
%            [[b0047],[sbt__D_e]],
%            [[b0054],[glc__D_e]],
%            [[b0091],[ala__L_e]],
%            [[b0142],[pyr_e]]
%        ],Bs
%    ),
%    phenotypic_effects_bitset(
%        2,
%        [
%            [[b3708],[ac_e]],
%            [[b1249],[acgam_e]],
%            [[b0002],[pyr_e]],
%            [[b0009],[acgam_e]],
%            [[b0033],[mnl_e]],
%            [[b0038],[succ_e]],
%            [[b0047],[sbt__D_e]],
%            [[b0054],[glc__D_e]],
%            [[b0091],[ala__L_e]],
%            [[b0142],[pyr_e]]
%        ],Bs1
%    ),
%    assertion(Bs==Bs1).

:- end_tests(abduction_batch).