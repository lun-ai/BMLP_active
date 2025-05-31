:- ['framework/lmatrix/utils.pl'].
:- [selected_genes].

:-  consult('models/iML1515/iML1515_bk.pl'),
    consult('models/iML1515/iML1515_pathway.pl'),
    tell('experiments/iML1515/abduction/isoenz/incomplete_pathway.pl'),
    forall(enzyme(A,B,C,D,E,F,G),write_fact(enzyme(A,B,C,D,E,F,G))) ,
    forall(shared_orfs(A,B),write_fact(shared_orfs(A,B))),
    selected(Gs),
    findall(codes(G,Enz),(encodes_protein(G,GId),\+memberchk(GId,Gs),codes(G,Enz)),Codes1),
    write_facts(Codes1),
    told,
    length(Codes1,L1),
    findall(codes(G,Enz),codes(G,Enz),Codes2),
    length(Codes2,L2),
    L3 is L2 - L1,
    format('% removed ~q gene-enzyme associations (including links in common)\n', L3),
    unload_file('models/iML1515/iML1515_pathway.pl').



