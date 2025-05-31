:-['src/framework/lmatrix/utils.pl'].

predictions(N,ExPath,LogPath,ResPath) :-
    consult(ExPath),
    findall(predictions(E,LogPath,ResPath),ex(E),Goals),
    unload_file(ExPath),
    length(Goals,L),
    NCPUS is N - 1,
    numlist(0,NCPUS,CPUS),
    consult('src/models/iML1515_bk.pl'),
    consult('src/models/iML1515_pathway.pl'),
    consult('experiments/iML1515/runtime/swi/static_know.pl'),
    concurrent(N,Goals,[queue_max_size(L),affinity(CPUS)]).


predictions(E,LogPath,ResPath) :-
    E=phenotypic_effect(A,[B]),
    atomics_to_string([LogPath,"_",A,"_",B],LogFile),
    open(LogFile,write,LogStr),
    set_output(LogStr),
    call_time(predict(E,L),Time),
    dict_pairs(Time,_,Res),
    format("% resource ~w, ~w, ~w\n",Res),
    close(LogStr),
    open(ResPath,append,Str),
    write_fact(Str,label(E,L)),
    close(Str).


predict(E,1) :-
    call(E),!.
predict(_,0).

