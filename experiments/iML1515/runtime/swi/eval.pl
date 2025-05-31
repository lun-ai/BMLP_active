:-['src/models/iML1515/iML1515_bk.pl'].
:-['src/models/iML1515/iML1515_pathway.pl'].
:-[static_know].
:-['src/framework/lmatrix/utils.pl'].
:-['experiments/iML1515/runtime/examples.pl'].
:- use_module(library(thread)).

runtime :-
    tell('time_stats.log'),told,
    call_time(\+phenotypic_effect(b3708,[ac_e]),Stats),!,
    get_dict(wall,Stats,T),
    open('time_stats.log',write,WS),
    writeln(WS,T),
    close(WS).

runtime_multi :-
    tell('swi_multi.txt'),told,
    open('swi_multi.txt',write,WS),
    forall(ex(E),(call_time((E;true),Stats),get_dict(wall,Stats,T),writeln(WS,T))),
    close(WS).

runtime_multi_thread :-
    call_time(concurrent_forall(ex(E),(call(E);true)),Stats),
    get_dict(wall,Stats,T),
    findall(1,ex(E),Ex),
    length(Ex,N),
    Avg_T is T/N,
    open('swi_multi_thread.txt',append,WS),
    writeln(WS,Avg_T),
    close(WS).
