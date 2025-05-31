:- [selected_genes].
:- ['src/framework/abduction/sample.pl'].

gene_subset_size(33).


candidate_orfs(Orfs) :-
    consult('models/iML1515/iML1515_bk.pl'),
    selected(Orfs1),
    setof(
        GId,
        Orf^(member(Orf,Orfs1),encodes_protein(GId,Orf)),
        Orfs
    ),
    length(Orfs,L),
    format('% ~w genes\n',[L]).



% added metabolite asp__L_c which recovers b0928,b4054 double knockout from no growth to growth
nutrient_pool(['indole_e','phe__L_e','tyr__L_e','trp__L_e','skm_e','asp__L_c']).



nutrient_combinations([[]|Combinations]) :-
    nutrient_pool(Ns),
    findall([N],member(N,Ns),Combinations).



cond(ex,_Args,Ex) :-
    nutrient_combinations(Comb),
%    target(T),
    candidate_orfs(ORFs),
    setof(ex(phenotypic_effect(Cond,N)),
        O1^O2^N^(member(O1,ORFs),member(O2,ORFs),O1\==O2,sort([O1,O2],Cond),member(N,Comb)),Ex1),
    setof(ex(phenotypic_effect([O],N)),O^N^(member(O,ORFs),member(N,Comb)),Ex2),
    append(Ex1,Ex2,Ex3),!,
    findall(ex(I,E),nth0(I,Ex3,ex(E)),Ex),
    length(Comb,L),
    format("% ~w optional medium variations\n",[L]).




candidate_enz(Orfs,NewEnzNames,Nodes) :-
    % refer to the complete model for the missing enzyme functions
    consult('models/iML1515/iML1515_pathway.pl'),
    setof(
        E,
        Orf^(member(Orf,Orfs),codes(Orf,E)),
        Enzs
    ),
    length(Enzs,L),
    format('% ~w enzymes\n',[L]),
    setof(enzyme_(Rnames,A,B,C,D),I^Enz^Gs^Rnames^A^B^C^D^(nth0(I,Enzs,Enz),enzyme(Enz,Gs,Rnames,A,B,C,D)),Nodes1),
    findall(Node,(nth0(I,Nodes1,enzyme_(Rnames,A,B,C,D)),abd_sym(I,NewEnzName),
        enzyme(NewEnzName,[],Rnames,A,B,C,D)=..Node),Nodes),
    findall(NewEnzName,member([enzyme,NewEnzName|_],Nodes),NewEnzNames),
    unload_file('models/iML1515/iML1515_pathway.pl'),!.



generate_abds(_,OutputPath) :-
    gene_subset_size(N),
    candidate_orfs(Orfs),
    candidate_enz(Orfs,Enzs,NewEnzNodes),
    target(T),
    delete(Orfs,T,Orfs1),
    N1 is N - 1,
    length(Init,N1),
    random_permutation(Orfs1,Orfs2),
    append(Init,_,Orfs2),
    Orfs3 = [T|Init],!,
    consult('experiments/iML1515/abduction/isoenz_learning/pathway_without_tyrB.pl'),
    findall(
        abd_([AbdTerm1,[enzyme,Enz|Args]]),
        (
            member(Orf,Orfs3),
            member(Enz,Enzs),
            codes(Orf,Enz)=..AbdTerm1,
            member([enzyme,Enz|Args],NewEnzNodes),
            Args = [_,Rnames,A,B,C,D],
            not((enzyme(EnzExisting,_,Rnames,A,B,C,D),codes(Orf,EnzExisting)))
        ),
        Abds_1
    ),
    unload_file('experiments/iML1515/abduction/isoenz_learning/pathway_without_tyrB.pl'),
    sort([abd_([[]])|Abds_1],Abds_2),
    findall(
        abd(I,V),
        nth0(I,Abds_2,abd_(V)),
        Abds
    ),
    tell(OutputPath),
    write_facts(Abds),
    told,
    length(Abds,L),
    format('% gene subset ~w\n',[N]),
    format("% ~w abducibles\n",[L]),
    format("% Generated abducibles to ~w\n\n",[OutputPath]).


change_cm :-
    consult('experiments/iML1515/abduction/isoenz_learning/abducibles_with_redund.pl'),
    findall(abd(AId,Abd),abd(AId,Abd),Abds),
    unload_file('experiments/iML1515/abduction/isoenz_learning/abducibles_with_redund.pl'),
    consult('experiments/iML1515/abduction/isoenz_learning/abducibles.pl'),
    findall(AId1-AId2,(member(abd(AId1,Abd),Abds),abd(AId2,Abd)),Mapping),
    consult('experiments/iML1515/abduction/isoenz_learning/cm_with_redund.pl'),
    findall(abdm(AId2,BS),(member(AId1-AId2,Mapping),abdm(AId1,BS)),Matrix),
    tell('experiments/iML1515/abduction/isoenz_learning/cm.pl'),
    write_facts(Matrix),
    told.