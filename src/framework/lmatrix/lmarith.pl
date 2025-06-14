%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Logical Matrix arithmetic package
%	Author: Lun Ai and S.H. Muggleton
%	Date:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [setarith].
:- [utils].
:- use_module(library(thread)).
% SWI-Pl 9.2 requires setting max_integer byte size

:- op(700,xfy,is_lmatrix). 		% LMatrix expression evaluation
:- op(700,xfy,is_lmatrix_p).
:- op(500,yfx,'--').			% LMatrix minus intersection
:- op(300,xfy,'@@').

M is_lmatrix A^2 :- !,
	Ma is_lmatrix A,
	lm_square(Ma,M), !.
M is_lmatrix A \/ 1 :- !,
	Ma is_lmatrix A,
	lm_add_diagonal(Ma,M), !.
M is_lmatrix A * B :- !,
	Ma is_lmatrix A,
	Mb is_lmatrix B,
	!, lm_prod(Ma,Mb,M), !.
M is_lmatrix M :- !, nonvar(M), !.

% "_p" for multi-threading extensions
M @@ Path is_lmatrix_p A @@ Path ^2 :- !,
	Ma is_lmatrix A,
%	lm_square_p(Path,Ma,M), !.
	lm_square(Path,Ma,M), !.
M @@ Path is_lmatrix_p A @@ Path \/ 1  :- !,
	Ma is_lmatrix A,
	lm_add_diagonal(Path,Ma,M), !.
M @@ Path is_lmatrix_p A @@ Path * B @@ Path :- !,
	Ma is_lmatrix_p A @@ Path,
	Mb is_lmatrix_p B @@ Path,
%	!, lm_prod_p(Path,Ma,Mb,M), !.
	!, lm_prod(Path,Ma,Mb,M), !.
M @@ Path is_lmatrix_p M @@ Path:- !, nonvar(M), nonvar(Path), !.


% Square of lmatrices

lm_square(Path,[P,M1],[P,M2]) :- M2 is M1*2,
    lm_prod_trans(Path,[P,M1],[_TP,_TP_M1]),
	lm_prod(Path,[P,M1],[P,M1],[P,M2]), !.

lm_square_p(Path,[P,M1],[P,M2]) :- M2 is M1*2,
    lm_prod_trans_p(Path,[P,M1],[_TP,_TP_M1]),
	lm_prod_p(Path,[P,M1],[P,M1],[P,M2]), !.


% lm_prod/4 - Ms is product of matrices M1,M2

lm_prod(Path,[P1,M1],[P2,M2],[P3,M3]) :-
    (nonvar(M3);M3 is M1+M2),
	mfname(Path,P3,M3,M3name),
	tell(M3name),
	pprod([P1,M1],[P2,M2],[P3,M3]),
	told,
	consult(M3name),!.
%	lm_prod_trans([P,M3]), !.


lm_prod_p(Path,[P1,M1],[P2,M2],[P3,M3]) :-
    (nonvar(M3);M3 is M1+M2),
	pprod_p(Path,[P1,M1],[P2,M2],[P3,M3]),!.


% lm_prod_trans/2 - Generation of Transpose Matrix
lm_prod_trans(Path,[P,M]) :-
    lm_prod_trans(Path,[P,M],_).
lm_prod_trans(Path,[P,M],[TP,TP_M]) :-
	mname(t,P,TP), mfname(Path,TP,M,Mname),
	tell(Mname),
	mname(P,M,P_M), mname(TP,M,TP_M),
	writes(['% Transposed Union Matrix','\n']),
	% for m x n matrices where m < n
    once((
        setof(U,Z^V^V1^(call(P_M,Z,V),V1 is V + 1,U is msb(V1)),Dim),
        last(Dim,MaxDim),
	    numlist(0,MaxDim,Cols)
    )),
	member(Y,Cols),
	findall(X,(call(P_M,X,Ys),1 is getbit(Ys,Y)),Xs),
	lm_stob1(Xs,BXs),
	writes([TP_M,'(',Y,',',BXs,').','\n']), fail.
lm_prod_trans(Path,[P,M],[TP,TP_M]) :- !,
	told,
	mname(t,P,TP), mfname(Path,TP,M,Mname),
	mname(TP,M,TP_M),
	consult(Mname).


% lm_prod_trans_p/2 - parallel version of transpose matrix generation
lm_prod_trans_p(Path,[P,M]) :-
    lm_prod_trans_p(Path,[P,M],_).
lm_prod_trans_p(Path,[P,M],[TP,M]) :-
    mname(t,P,TP), mfname(Path,TP,M,Mname),
	mname(P,M,P_M), mname(TP,M,TP_M),
	tell(Mname),
	writes(['% Transposed Union Matrix','\n']),
	told,
	once((
        setof(U,Z^V^V1^(call(P_M,Z,V),V1 is V + 1,U is msb(V1)),Dim),
        last(Dim,MaxDim),
	    numlist(0,MaxDim,Cols)
    )),
	concurrent_forall(
	    member(Y,Cols),
	    call(lm_prod_trans_p_,Mname,P_M,TP_M,Y)),
	consult(Mname),!.
lm_prod_trans_p_(Mfname,P_M,TP_M,Y):-
    findall(X,(call(P_M,X,Ys),1 is getbit(Ys,Y)),Xs),
    lm_stob1(Xs,BXs),
    open(Mfname,append,Str,[lock(write)]),
    writes(Str,[TP_M,'(',Y,',',BXs,').','\n']),
    close(Str).


% lm_prods of list of lmatrices

lm_prods(_,P,[Depth],[P,Depth]) :- !.
lm_prods(Path,P,[D|Ds],M) :-
	lm_prods(Path,P,Ds,M1),
	M is_lmatrix [P,D] * M1.
%	lm_prod([P,D],M1,M).



% Printing product of lmatrices
% Avoid meta-level calls
% write dedicated helpers on arithmetics for the compiler to optimise

pprod([P,M1],[P,M2],[P,M3]) :-
    % Name of Transpose Matrix
	mname(t,P,TP),
	mname(P,M1,P_M1), mname(TP,M2,TP_M2), mname(P,M3,P_M3),
	call(P_M1,X,BXs),
	findall(Y,(call(TP_M2,Y,BYs),BZs is BXs/\BYs,BZs>0),Ys1),
	lm_stob1(Ys1,BYs1),
	writes([P_M3,'(',X,',',BYs1,').','\n']), fail.
pprod(_,_,_).



pprod_p(Path,[P,M1],[P,M2],[P,M3]) :-
    mname(t,P,TP),
	mname(P,M1,P_M1), mname(TP,M2,TP_M2), mname(P,M3,P_M3),
	mfname(Path,P,M3,M3fname),
	tell(M3fname),
	writes(['% Matrix product of matrices ',M1,' and ',M2,'\n']),
	told,
	concurrent_forall(
	    call(P_M1,X,BXs),
	    (
	        pprod_p_(TP_M2,P_M3,X,BXs,Row),
	        open(M3fname,append,Str,[lock(write)]),
	        writes(Str,Row),
	        close(Str)
	    )
	),
	consult(M3fname),!.
pprod_p_(TP_M,P_M3,X,BXs,[P_M3,'(',X,',',BYs1,').','\n']) :-
    findall(Y,(call(TP_M,Y,BYs),BXs/\BYs>0),Ys1),!,
	lm_stob1(Ys1,BYs1).
pprod_p__(P_M,TP_M,X,Y,Y) :-
	call(P_M,X,BXs),
	call(TP_M,Y,BYs),
    BZs is BXs/\BYs,
    BZs>0,!.
pprod_p__(_,_,_,_,-1).



% Add diagonal to a given logical matrix

lm_add_diagonal(Path,[P,M],[Pu,M]) :-
	name(P,P1), name('1U',U1), 
	appends([P1,U1],Pu1), name(Pu,Pu1),
	mfname(Path,Pu,M,Mfname),
	tell(Mfname),
	pdiagonal([P,M],[Pu,M]),
	told,
	consult(Mfname), !.



% Printing Matrix with diagonal added

pdiagonal([P,M],[Pu1,M]) :-
	writes(['% Matrix with diagonal added','\n']),
	mname(P,M,P_M), mname(Pu1,M,Pu1_M),
	call(P_M,X,_), lm_add_diagonal1(P_M,X,Y),
	writes([Pu1_M,'(',X,',',Y,')','.','\n']), fail.
%pdiagonal([P,M],[Pu1,M]) :-
%	writes(['% Transpose Matrix with diagonal added','\n']),
%	mname(P,M,P_M), mname(Pu1,M,Pu1_M),
%	mname(t,P_M,TP_M), mname(t,Pu1_M,TPu1_M),
%	call(TP_M,X,_), lm_add_diagonal1(TP_M,X,Y),
%	writes([TPu1_M,'(',X,',',Y,')','.','\n']), fail.
pdiagonal(_,_).



% Add_diagonal into a row of the matrix

lm_add_diagonal1(P_M,X,Y) :-
	call(P_M,X,Y1), Y is Y1\/1<<X, !.
	

element(X,[X|_]).
element(X,[_|T]) :- element(X,T).

mfname(Path,P,M,Fname) :-
	atomic_list_concat([Path,P,M],Fname),!.

mname(P,M,Mname) :-
	atomic_concat(P,M,Mname),!.

mnames([Name],Name) :- !.
mnames([H|T],Name) :-
	mnames(T,NameT),
	mname(H,NameT,Name), !.



% lm_eq/3 - test if two matrices are identical
%   in every row
% is_lmatrix/2 checks if two matrices have the same id

lm_eq([P,M1],[P,M2]) :-
    mname(P,M1,PM1), mname(P,M2,PM2),
    \+((call(PM1,X,Y1),call(PM2,X,Y2),Y1 =\= Y2)).



%lm_eq_p([P,M1],[P,M2]) :-
%    mname(P,M1,PM1), mname(P,M2,PM2),
%    concurrent_forall(
%        (call(PM1,X,Y1),call(PM2,X,Y2)),
%        Y1 == Y2
%    ).

% lm_submatrix/2 - test whether every row of 1st matrix is a subset
%   of the corresponding row of the second

lm_submatrix([P,M1],[P,M2]) :-
	mname(P,M1,PM1), mname(P,M2,PM2),
	\+((call(PM1,X,Y1),call(PM2,X,Y2),\+(bit_subset_chk(Y1,Y2)))).



% lm_submatrix/4 - find all rows of the 2nd matrix that is a subset
%   of the Xth row of the 1st matrix

lm_submatrix(X,[P,M1],[P,M2],Ns) :-
    mname(P,M1,P_M1), mname(P,M2,P_M2),
    lm_submatrix_(X,P_M1,P_M2,Ns).

lm_submatrix_(X,P_M1,P_M2,Ns) :-
    findall(Y,(call(P_M1,X,Y1),call(P_M2,Y,Y2),bit_subset_chk(Y2,Y1)),Ns).

% skip ith row in the 2nd matrix if ith bit in filter is 1
lm_submatrix_f_(X,F,P_M1,P_M2,Ns) :-
    findall(Y,(call(P_M1,X,Y1),call(P_M2,Y,Y2),1 is getbit(F,Y),bit_subset_chk(Y2,Y1)),Ns).

% reverse of lm_submatrix_ operation by switching the 1st and 2nd matrix
lm_submatrix_r_(X,P_M1,P_M2,Ns) :-
    findall(Y,(call(P_M1,X,Y1),call(P_M2,Y,Y2),bit_subset_chk(Y1,Y2)),Ns).



% For all row i in the first matrix, find all indices j of rows
% in the second matrix where the row j contains row i

all_submatrix(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Submatrix indices of matrix ',M2,'\n']),
	told,
    forall(call(P_M1,X,_),
            (
                lm_submatrix(X,[P,M1],[P,M2],Rn),
                lm_stob1(Rn,Y),
                write_row_matrix(Path,P,M3,X,Y,append)
            )).


%filter_submatrix(Path,[P,F],[P,M1],[P,M2],[P,M3]) :-
%    (nonvar(M3);M3 is M1 + M2),!,
%    mname(P,M1,P_M1),
%    mname(P,M2,P_M2),
%    mname(P,F,P_F),
%    call(P_F,X,Filter),
%    mfname(Path,P,M3,M3fname),
%    tell(M3fname),
%	writes(['% Submatrix indices of matrix ',M2,'\n']),
%	told,
%    forall(call(P_M1,X,_),
%            (
%                lm_submatrix_f_(X,Filter,P_M1,P_M2,Rn),
%                lm_stob1(Rn,Y),
%                write_row_matrix(Path,P,M3,X,Y,append)
%            )).


%all_submatrix_p([P,M1],[P,M2],[P,M3]) :-
%    (nonvar(M3);M3 is M1 + M2),!,
%    mname(P,M1,P_M1),
%    mname(P,M2,P_M2),
%    mname(P,M3,P_M3),
%    mfname(P,M3,M3fname),
%    tell(M3fname),
%	writes(['% Submatrix indices','\n']),
%	told,
%    forall(
%        (call(P_M1,X,_)),
%        (
%            create_row_matrix('subm',X,SubfN),
%%            mfname('subm',X,SubfN),
%%            tell(SubfN),told,
%            mname('subm',X,SubN),
%	        all_submatrix_p_(SubfN,P_M1,P_M2,SubN,X),
%	        consult(SubfN),
%            call(SubN,X,Rn),
%            unload_file(SubfN),
%            lm_stob1(Rn,U),
%            write_row_matrix_(M3fname,P_M3,X,U,append)
%        )
%    ),
%    consult(M3fname),!.
%all_submatrix_p_(SubfN,P_M1,P_M2,SubN,X) :-
%    open(SubfN,append,Str),
%    writes(Str,[SubN,"(",X,",["]),
%    close(Str),
%    concurrent_forall(
%        (call(P_M1,X,Y1),call(P_M2,Y,Y2)),
%        (
%            (
%                Y2 is Y2 /\ Y1 ->
%                (open(SubfN,append,Str1),
%                 writes(Str1,[Y,","]),
%                 close(Str1));
%%                write_row_matrix_(SubfN,SubN,X,Y,append);
%                true
%            )
%        )
%    ),
%    open(SubfN,append,Str2),
%    writes(Str2,["-1])."]),
%    close(Str2).

all_submatrix_p(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mname(P,M2,P_M2),
    mname(P,M3,P_M3),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Submatrix indices of matrix ',M2,'\n']),
	told,
    concurrent_forall(
        call(P_M1,X,_),
        all_submatrix_p_(M3fname,P_M1,P_M2,P_M3,X)
    ),
    consult(M3fname),!.
all_submatrix_p_(Mfname,P_M1,P_M2,P_M3,X) :-
    lm_submatrix_(X,P_M1,P_M2,Rn),
    lm_stob1(Rn,Y),
    write_row_matrix_(Mfname,P_M3,X,Y,append).



% For all indices i of rows, subtract row i in the second matrix
% from row i in the first matrix

lm_subtract(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mname(P,M2,P_M2),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Subtract Matrix ',M2,' from Matrix ',M1,'\n']),
	told,
    forall((call(P_M1,X,Y1),call(P_M2,X,Y2)),
            (
                Y3 is Y1 /\ \Y2,
	            write_row_matrix(Path,P,M3,X,Y3,append)
            )).


lm_subtract_p(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mname(P,M2,P_M2),
    mname(P,M3,P_M3),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Subtract Matrix ',M2,' from Matrix ',M1,'\n']),
	told,
    concurrent_forall(
        (call(P_M1,X,Y1),call(P_M2,X,Y2)),
            (
                Y3 is Y1 /\ \Y2,
	            write_row_matrix_(M3fname,P_M3,X,Y3,append)
            )),
    consult(M3fname),!.



% For all indices i of rows, add row i in the second matrix
% with row i in the first matrix

lm_add(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mname(P,M2,P_M2),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Union between two matrices ',M1,' and ',M2,'\n']),
	told,
    forall((call(P_M1,X,Y1),call(P_M2,X,Y2)),
            (
                Y3 is Y1 \/ Y2,
                write_row_matrix(Path,P,M3,X,Y3,append)
            )).


lm_add_p(Path,[P,M1],[P,M2],[P,M3]) :-
    (nonvar(M3);M3 is M1 + M2),!,
    mname(P,M1,P_M1),
    mname(P,M2,P_M2),
    mname(P,M3,P_M3),
    mfname(Path,P,M3,M3fname),
    tell(M3fname),
	writes(['% Union between two matrices ',M1,' and ',M2,'\n']),
	told,
    concurrent_forall(
            (call(P_M1,X,Y1),call(P_M2,X,Y2)),
            (
                Y3 is Y1 \/ Y2,
                write_row_matrix_(M3fname,P_M3,X,Y3,append)
            )),
    consult(M3fname),!.


% lm_mkcton/1 - make one-one mapping from Herbrand Base to Natural numbers
%	and create auxiliary primitives based on frequent pairings.

lm_mkcton(Cs) :-
	File= 'herbn.pl',
	lm_mkcton(Cs,File).


lm_mkcton(Cs,File) :-
    \+number(File),
	tell(File),
	writes([':- discontiguous(cton/2), discontiguous(ntoc/2).','\n','\n']),
	lm_mkcton(Cs,0),
	told, consult(File), !.

lm_mkcton([],_) :- !.
lm_mkcton([H|T],N) :-
	portray_clause(cton(H,N)), write(' '),
	portray_clause(ntoc(N,H)), nl,
	N1 is N+1,
	lm_mkcton(T,N1), !.

lm_mkcton_mul(Ps,File) :-
    \+number(File),
	tell(File),
	writes([':- discontiguous(cton/3), discontiguous(ntoc/3).','\n','\n']),
	lm_mkcton_mul_(Ps,File),
	told, consult(File), !.

lm_mkcton_mul_([],_) :- !.
lm_mkcton_mul_([(P,Cs)|T],File) :-
	lm_mkcton(P,Cs,0),
	lm_mkcton_mul_(T,File).

lm_mkcton(_,[],_) :- !.
lm_mkcton(P,[H|T],N) :-
	portray_clause(cton(P,H,N)), write(' '),
	portray_clause(ntoc(P,N,H)), nl,
	N1 is N+1,
	lm_mkcton(P,T,N1), !.



% lm_stob/2 - convert a subset of the Herbrand Base to a Bitset

lm_stob(Set,Bitset) :-
	lm_stob(Set,0,Bitset).

lm_stob([],Bs,Bs) :- !.
lm_stob([H|T],Bs1,Bs2) :-
	cton(H,N),
	Bs3 is Bs1\/1<<N,
	lm_stob(T,Bs3,Bs2), !.



% lm_stob1/2 - convert a set of Numbers to a Bitset

lm_stob1(NSet,Bitset) :-
    set_max_integer_size,
	lm_stob1(NSet,0,Bitset).

lm_stob1([],Bs,Bs) :- !.
lm_stob1([N|T],Bs1,Bs2) :-
   N < 0,!,
   lm_stob1(T,Bs1,Bs2).
lm_stob1([N|T],Bs1,Bs2) :-
	Bs3 is Bs1\/1<<N,
	lm_stob1(T,Bs3,Bs2), !.

% lm_btos/2 - convert a Bitset to a subset of the Herbrand Base

lm_btos(Bitset,Set) :-
    set_max_integer_size,
	lm_btos(Bitset,[],Set).

lm_btos(0,Set,Set) :- !.
lm_btos(Bs1,Set1,[H|Set2]) :-
	N is lsb(Bs1), ntoc(N,H),
	Bs2 is Bs1/\ \(1<<N),
	lm_btos(Bs2,Set1,Set2), !.

% lm_btos1/2 - convert a Bitset to a set of Numbers

lm_btos1(Bitset,Set) :-
    set_max_integer_size,
	lm_btos1(Bitset,[],Set).

lm_btos1(0,Set,Set) :- !.
lm_btos1(Bs1,Set1,[N|Set2]) :-
	N is lsb(Bs1),
	Bs2 is Bs1/\ \(1<<N),
	lm_btos1(Bs2,Set1,Set2), !.

lm_ltob(Bl,Bs) :-
    set_max_integer_size,
    lm_ltob(Bl,0,Bs).
lm_ltob([1],Bs1,Bs2) :- !,
    Bs2 is Bs1 + 1.
lm_ltob([0],Bs,Bs) :- !.
lm_ltob([B|Bl],Bs1,Bs2) :-
    Bs3 is (Bs1 \/ B) << 1,
    lm_ltob(Bl,Bs3,Bs2),!.

count_ones(Bs,N) :-
    set_max_integer_size,
    count_ones(Bs,0,N).
count_ones(0,N,N) :- !.
count_ones(Bs,N1,N2) :-
    1 is Bs /\ 1,!,
    Bs1 is Bs >> 1,
    N3 is N1 + 1,
    count_ones(Bs1,N3,N2).
count_ones(Bs,N1,N2) :-
    Bs1 is Bs >> 1,
    count_ones(Bs1,N1,N2).


% reverse a bitset given a bitset max length
reverse_bs(_,0,0) :- !.
reverse_bs(M,Bs1,Bs2) :-
    lm_btos1(Bs1,S1),
    findall(N2,(member(N1,S1),N2 is M-1-N1),S2),
    lm_stob1(S2,Bs2).


% reverse a bitset
reverse_bs(0,0) :- !.
reverse_bs(Bs1,Bs2) :-
    lm_btos1(Bs1,S1),
    L is msb(Bs1),
    findall(N2,(member(N1,S1),N2 is L-N1),S2),
    lm_stob1(S2,Bs2).

create_row_matrix(Path,P,M,Mf) :-
    mfname(Path,P,M,Mf),
    tell(Mf),
    told.
write_row_matrix(Path,P,M,N,BitSet) :-
    create_row_matrix(Path,P,M,_),
    write_row_matrix(Path,P,M,N,BitSet,write).
write_row_matrix(Path,P,M,N,BitSet,Mode) :-
    mname(P,M,P_M),
    mfname(Path,P,M,Mf),
    write_row_matrix_(Mf,P_M,N,BitSet,Mode),
    consult(Mf).
write_row_matrix_(Mf,M,N,BitSet,Mode) :-
    set_max_integer_size,
    open(Mf,Mode,Str,[lock(write)]),
    writes(Str,[M,"(",N,",",BitSet,").",'\n']),
    close(Str).