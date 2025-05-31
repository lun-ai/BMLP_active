% simulator module
:- ['src/framework/deduction/simulator.pl'].
% background knowledge
:- ['src/models/iML1515/iML1515_bk.pl'].
:- ['src/models/iML1515/iML1515_pathway.pl'].
:- ['src/models/iML1515/growth_medium.pl'].
% encoded background
:- ['src/models/iML1515/herbn.pl'].
:- ['src/models/iML1515/reaction.pl'].


:- current_prolog_flag(cpu_count,NCPU),format('% No. CPU available ~w\n',[NCPU]).

% top level calling of classifier given local growth medium definition
simulations(OutPath,ExPath,_LogPath,ResPath) :-
    consult(ExPath),
    findall([G,C],ex(_,phenotypic_effect(G,C)),Conds),
    findall([label,E],ex(_,E),Es),
    unload_file(ExPath),
    time(phenotypic_effects(OutPath,Conds,PredictedLabels)),!,
    maplist(last,Wrapped,PredictedLabels),
    maplist(append,Es,Wrapped,Args),
    maplist((=..),Pairs,Args),
    open(ResPath,append,Str),
    write_facts(Str,Pairs),
    close(Str).
