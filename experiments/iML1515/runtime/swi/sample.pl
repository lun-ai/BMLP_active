:-use_module(library(random)).
:-['src/framework/lmatrix/utils.pl'].



% copy all examples from source to a target path
sample_(Str,all,ExSorted) :-
    current_predicate(l/2),!,
    findall(ex(E),l(E,_),Ex),
    sort(Ex,ExSorted),
    convert_ex(ExSorted,Ex1),
    write_facts(Str,Ex1).
sample_(Str,all,ExSorted) :-
    current_predicate(ex/2),!,
    findall(ex(I,E),ex(I,E),Ex),
    sort(Ex,ExSorted),
    write_facts(Str,ExSorted).



% sample N examples and try to even out pos and neg ratio
sample_(Pos,Neg,Str,even,N,ExSorted) :-
    length(Pos,NPos),
    length(Neg,NNeg),
    All is NPos + NNeg,
    Total is min(N,All),
    Half is Total // 2,
    N1 is min(Half,NPos),
    N2 is N - N1,
    random_permutation(Pos,Pos1),
    random_permutation(Neg,Neg1),
    length(Pos2,N1),
    prefix(Pos2,Pos1),
    length(Neg2,N2),
    prefix(Neg2,Neg1),!,
    append(Pos2,Neg2,Ex),
    sort(Ex,ExSorted),
    convert_ex(ExSorted,Ex1),
    write_facts(Str,Ex1).



sample(Source,Path,even,N) :-
    consult(Source),
    current_predicate(l/2),!,
    findall(ex(E),l(E,1),Pos),
    findall(ex(E),l(E,0),Neg),
    open(Path,write,Str),
    sample_(Pos,Neg,Str,even,N,_),!,
    close(Str).
sample(Source,Path,all) :-
    consult(Source),
    open(Path,write,Str),
    sample_(Str,all,_),
    close(Str).



% convert ex/1 to ex/2 by assigning an id to each example
convert_ex(E1,E2) :-
    findall(ex(I,E),nth0(I,E1,ex(E)),E2).
