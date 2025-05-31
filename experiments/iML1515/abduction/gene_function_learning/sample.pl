:- ['src/framework/abduction/sample.pl'].
:- ['src/models/iML1515/growth_medium.pl'].


% removed the gene function associated with these genes using the generation function below
sampled_phenotypic_genes(
%    [b0121,b0242,b0596,b0720,b1090,b1136,b2751,b2780,b2838,b3018,b3199,b3208,b3256,b3258,b3469,b3629,b3729,b3771,b3941,b4244]
    [b0720,b1136,b3729]
).

generate_incomplete_pathways :-
    consult('src/models/iML1515/iML1515_bk.pl'),
    consult('src/models/iML1515/iML1515_pathway.pl'),
    tell('experiments/iML1515/abduction/gene_function_learning/incomplete_pathway.pl'),
    forall(enzyme(A,B,C,D,E,F,G),write_fact(enzyme(A,B,C,D,E,F,G))) ,
    forall(shared_orfs(A,B),write_fact(shared_orfs(A,B))),
    sampled_phenotypic_genes(Gs),
    findall(codes(G,Enz),(codes(G,Enz),\+memberchk(G,Gs)),Codes1),
    write_facts(Codes1),
    told,
    length(Codes1,L1),
    findall(codes(G,Enz),codes(G,Enz),Codes2),
    length(Codes2,L2),
    L3 is L2 - L1,
    format('% removed ~q gene-enzyme associations (including links in common)\n', L3),
    unload_file('src/models/iML1515/iML1515_pathway.pl').


candidate_enz(Enzs) :-
    % refer to the complete model for the missing enzyme functions
    consult('src/models/iML1515/iML1515_pathway.pl'),
    setof(
        E,
        Orf^(codes(Orf,E)),
        Enzs
    ),
    
    length(Enzs,L),
    format('% ~w enzymes\n',[L]),
    unload_file('src/models/iML1515/iML1515_pathway.pl').



% Sample candidate trials for active learning with up to 3 optional nutrients.
% Given 16 carbon sources as optional nutrients added to the medium.
% The number of different medium composition combinaitions is 696.

nutrient_combinations([[]|Combinations]) :-
    optional_nutrients(Ns),
    findall([N],member(N,Ns),Ns1),
    setof(U,N1^N2^(member(N1,Ns),member(N2,Ns),N1\==N2,sort([N1,N2],U)),Ns2),
    setof(V,
        T^N3^(member(T,Ns2),member(N3,Ns),\+member(N3,T),sort([N3|T],V)),Ns3),
    append(Ns1,Ns2,Ns4),
    append(Ns4,Ns3,Combinations),!.



generate_abds(Args,OutputPath) :-
    member([gene, ORF],Args),
    generate_incomplete_pathways,
    candidate_enz(Enzs),
    setof(
        abd_(codes(ORF,Enz)),
        (
            member(Enz,Enzs)
        ),
        Abds_
    ),
    findall(
        abd(I,[AbdTerm]),
        (nth1(I,Abds_,abd_(A)),A=..AbdTerm),
        Abds
    ),
    append([abd(0,[[]])],Abds,Abds1),
    tell(OutputPath),
    write_facts(Abds1),
    told,
    format("\n% Generated abducibles to ~w\n",[OutputPath]).


cond(ex,Args,Ex) :-
    member([gene, ORF],Args),
    nutrient_combinations(Comb),
    findall(ex(phenotypic_effect([ORF],N)),
        member(N,Comb),Ex1),
    findall(ex(I,E),nth0(I,Ex1,ex(E)),Ex).