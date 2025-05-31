:-['src/models/iML1515/iML1515_bk.pl'].
:-['src/models/iML1515/iML1515_pathway.pl'].
:-['src/framework/deduction/run.pl'].
:-['src/framework/lmatrix/utils.pl'].
:-['experiments/iML1515/runtime/examples'].
:- use_module(library(thread)).

runtime_multi :-
    make_directory('results/temp/'),
    tell('bmlp_multi.txt'),told,
    open('bmlp_multi.txt',write,WS),
    findall([G,M],ex(phenotypic_effect(G,M)),Conds),
    forall(member([G,M],Conds),(call_time(phenotypic_effect('results/temp/',G,M,_),Stats),get_dict(wall,Stats,T),writeln(WS,T))),
    close(WS).

runtime_multi_thread :-
    make_directory('results/temp/'),
    findall([[G],M],ex(phenotypic_effect(G,M)),Conds),
    call_time(phenotypic_effects('results/temp/',Conds,_),Stats),
    get_dict(wall,Stats,T),
    length(Conds,N),
    Avg_T is T/N,
    open('bmlp_multi_thread.txt',append,WS),
    writeln(WS,Avg_T),
    close(WS).
