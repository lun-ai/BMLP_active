:- use_module(library(http/json_convert)).
:- use_module(library(http/json)).
:- use_module(library(csv)).
:- [growth_medium].
:- ['framework/lmatrix/utils.pl'].

% Define conversion between Prolog terms and JSON objects
:- json_object
    notes_(
        original_bigg_ids:list
    ),
    metabolite_(
        id:atom,
        name:atom,
        compartment:atom,
        charge:number,
        formula:atom,
        notes:any
    ),
    coding_(
        id:atom,
        name:atom,
        notes:any
    ),
    reaction_(
        id:atom,
        name:atom,
        metabolites:any,
        lower_bound:number,
        upper_bound:number,
        gene_reaction_rule:atom,
        subsystem:atom,
        notes:any
    ),
    model(
        reactions:list,
        metabolites:list,
        genes:list,
        id:atom,
        compartments:any,
        version:atom
    ).

model_json_path("src/models/iML1515/iML1515.json").
db_path("src/models/iML1515/iML1515_bk.pl").
model_path("src/models/iML1515/iML1515_pathway.pl").
lmarith_path("src/framework/lmatrix/lmarith.pl").
herbn_path("src/models/iML1515/herbn.pl").

% iML1515 gene knockout phenotype predictions against experimental data
experiment_data_path("src/models/iML1515/iML1515_predictions.csv").
experiment_db_path("src/framework/iML1515/labels.pl").
experiment_trials("src/framework/iML1515/all_trials.pl").
experiment_labels("src/framework/iML1515/labels.pl").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create prolog database by writing ground fact(s) to output stream
% terms are represented in double quotes for consistency (all in string format)
% preserve double quotes when writing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse json format model containing PDB domain-gene-protein-reaction dictionaries

parse_json(Model) :-
    % use the user defined format to parse model from json file
    model_json_path(Path),
    open(Path,read,InputStr),
    json_read(InputStr,JsonDict),
    json_to_prolog(JsonDict,Model),
    close(InputStr).

parse_GID_to_PID(_,"",[['']]) :- !.
parse_GID_to_PID(E,GIDStr,PIDList) :-
    parse_substrings(GIDStr," or ",[],Subs),
    findall(PIDs,
            (
                % parse an and/or expression of gene IDs
                % into a list of strings first
                member(Sub,Subs),
                split_string(Sub,"()","",Subs1),
                atomics_to_string(Subs1,Subs2),
                parse_substrings(Subs2," and ",[],GIDs),
                % convert gene IDs (strings) into terms
                findall(Y,(member(X,GIDs),atom_string(X1,X),member(encodes_protein(X1,Y),E)),PIDs)
            ),
            PIDList
    ).


% parse aux function
% find if separator is part of the string input
% if yes then remove the separator substring
% otherwise append the rest into result string list

parse_substrings(Str,Sep,Subs1,Subs2) :-
    sub_string(Str,S,L,E,Sep),!,
    N1 is E+L,
    N2 is S+L,
    sub_string(Str,0,S,N1,Sub),
    sub_string(Str,N2,E,_,Rest),!,
    append(Subs1,[Sub],Subs3),
    parse_substrings(Rest,Sep,Subs3,Subs2).
parse_substrings(Sub,_,Subs1,Subs2) :-
    append(Subs1,[Sub],Subs2).


parse_reactants_products(RID,M,R,P,LB,UB,reaction(RID,RNames,PNames,LB,UB)) :-
    % find all metabolites that act as reactants in the forward reaction
    findall(involves(RID,M1,N2),
            (
                member(M1=N1,M),
                N1 < 0,
                N2 is 0 - N1
            ),
            R),
    % find all metabolites that act as products in the forward reaction
    findall(involves(RID,M1,N1),
            (
                member(M1=N1,M),
                N1 > 0
            ),
            P),
    findall(M3,(member(involves(_,M3,_),R)),RNames1),
    sort(RNames1,RNames),
    findall(M3,(member(involves(_,M3,_),P)),PNames1),
    sort(PNames1,PNames).


parse_proteins(_,_,[],Enz,Enz) :- !.
parse_proteins(RID,N,[PIDs|PIDList],Enz1,Enz2) :-
    findall(Enz,
            (
                member(PID,PIDs),
                (PID \== '' -> Enz=protein(PID,RID,N); Enz=protein(import,RID,N))
            ),Enz3),
    append(Enz1,Enz3,Enz4),
    N1 is N+1,
    parse_proteins(RID,N1,PIDList,Enz4,Enz2).



% each reaction can be linked to protein and metabolites via
%   protein(protein,reaction,reactionNum)
%   involves(reaction,metabolite,number_molecule)

% reactionNum is an integer indicating if an enzyme requires multiple genes
% or can be encoded by different sets of genes

parse_reactions(E,R1,R2) :-
    findall(reaction__(
                Enzyme,
                Reactants,
                Products,
                Rule
            ),
            (
                member(reaction_(RID,_,json(Metabolites),LB,UB,GID,_,_),R1),
                % represent reaction ID (plain term or single quotes) depending on the format
                atom_string(RID1,RID),
                % make sure gene ID and/or expressions are expressed in strings
                % for sub-string matching
                atom_string(GID,GID1),
                findall(X,member(coding(_,_,X),E),Encodings),
                parse_GID_to_PID(Encodings,GID1,PIDList),
                findall(M1=N1,(member(M=N1,Metabolites),atom_string(M1,M)),Metabolites1),
                parse_reactants_products(RID1,Metabolites1,Reactants,Products,LB,UB,Rule),
                parse_proteins(RID1,0,PIDList,[],Enzyme)
            ),
            R2),
    length(R2,N),
    format("Parsed ~w reactions\n",[N]).


% each metabolite is associated with a compartment location

parse_metabolite_locations(M1,M2) :-
    findall(location(
                metabolite(MID1),
                is_located(MID1,Comp1)
            ),
            (
                member(metabolite_(MID,_,Comp,_,_,_),M1),
                atom_string(MID1,MID),
                atom_string(Comp1,Comp)
            ),
            M2),
    length(M2,N),
    format("Parsed ~w metabolites\n",[N]).



% a specific gene called s0001 codes an empty protein string
% each gene one-to-one encodes a protein

parse_codings(E1,E2) :-
    findall(coding(
                gene(GID1),
                protein(Protein1),
                encodes_protein(GID1,Protein1)
            ),
            (
                member(coding_(GID,Protein,_),E1),
                atom_string(GID1,GID),
                atom_string(Protein1,Protein)
            ),
            E2),
    length(E2,N),
    format("Parsed ~w genes/proteins/encodings\n",[N]).


parse_db(Model,TotalComp,Encodings,Metabolites,Reactions) :- !,
    Model=model(Reactions_,Metabolites_,Encodings_,_,TotalComp,_),
    parse_codings(Encodings_,Encodings),
    parse_metabolite_locations(Metabolites_,Metabolites),
    parse_reactions(Encodings,Reactions_,Reactions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse genes and proteins in the iML1515 model into prolog predicates

% swipl -s src/models/iML1515/parser.pl -t parse_bk -q
parse_bk :-
    parse_json(Model),
    parse_db(Model,C,E,M,R),
    db_path(Path),
    open(Path,write,OutputStr),!,
    writeln(OutputStr,"% all enzymes"),
    forall(member(reaction__(Enzymes,_,_,_),R),write_facts(OutputStr,Enzymes)),
    nl(OutputStr),
    writeln(OutputStr,"% all reactants (metabolites)"),
    forall(member(reaction__(_,Reactants,_,_),R),write_facts(OutputStr,Reactants)),
    nl(OutputStr),
    writeln(OutputStr,"% all reaction products"),
    forall(member(reaction__(_,_,Products,_),R),write_facts(OutputStr,Products)),
    nl(OutputStr),
    writeln(OutputStr,"% all reactions"),
    forall(member(reaction__(_,_,_,Rule),R),write_fact(OutputStr,Rule)),
    nl(OutputStr),
    % write metabolite compartment links
    writeln(OutputStr,"% metabolite compartment locations"),
    forall(member(location(_,Location),M),write_fact(OutputStr,Location)),
    nl(OutputStr),
    % write gene and protein links
    writeln(OutputStr,"% all proteins"),
    forall((member(coding(_,Protein,Codes),E),Protein\=protein('')),write_fact(OutputStr,Codes)),
    nl(OutputStr),
    % write metabolite terms
    writeln(OutputStr,"% all metabolites"),
    forall(member(location(Metabolite,_),M),write_fact(OutputStr,Metabolite)),
    nl(OutputStr),
    % write gene terms
    writeln(OutputStr,"% all genes"),
    forall(member(coding(Gene,_,_),E),write_fact(OutputStr,Gene)),
    nl(OutputStr),
    % write protein terms
    writeln(OutputStr,"% describe one-to-one mapping between gene and protein"),
    forall((member(coding(_,Protein,_),E),Protein\=protein('')),write_fact(OutputStr,Protein)),
    nl(OutputStr),
    % write metabolite compartments
    writeln(OutputStr,"% all compartments - cytosol, extracellular space, periplasm"),
    forall((C=json(Comps),member(Comp=_,Comps),atom_string(Comp1,Comp)),
           write_fact(OutputStr,compartment(Comp1))),
    close(OutputStr).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_csv(Data) :-
    experiment_data_path(Path),
    csv_read_file(Path,[_|Data],[functor(data),arity(8)]).


% prediction label is one of [TP,FN,TN,FP], where TP stands for true positive
% prediction labels are not converted to strings as they are excluded from the experiment data

parse_prediction(Ds,Preds) :-
    findall(prediction(G2,P,C2),
            (
                member(data(_,G1,P,_,_,_,C1,_),Ds),
                atom_string(G2,G1),
                atom_string(C2,C1)
            ),
            Preds),
    length(Preds,N),
    format("Parsed ~w experiments\n",[N]).


pred_2_ob(prediction(G,P,C),phenotypic_effect(G,M,0)) :-
    (P=='TP';P=='FN'),
    carbon_source(C,M).
pred_2_ob(prediction(G,P,C),phenotypic_effect(G,M,1)) :-
    (P=='TN';P=='FP'),
    carbon_source(C,M).
preds_2_obs(Preds,Obs) :-
    findall(Ob,
            (
                member(Pred,Preds),
                pred_2_ob(Pred,Ob)
            ),
            Obs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse iML1515 single gene deletion data (csv) into prolog predicates
% https://www.nature.com/articles/nbt.3956#Sec1

% swipl -s src/models/iML1515/parser.pl -t trial_and_example -q

trial_and_example :-
    parse_csv(Ds),
    parse_prediction(Ds,Preds),
    preds_2_obs(Preds,Obs),
    experiment_db_path(Path),!,
    open(Path,write,OutputStr),
    writeln(OutputStr,"% phenotypic effect experimental observations included in iML1515 data"),
    writeln(OutputStr,"% positive examples"),
    forall(member(phenotypic_effect(G,M,1),Obs),
           write_fact(OutputStr,phenotypic_effect(G,[M]))),
    nl(OutputStr),
    writeln(OutputStr,"% negative examples"),
    forall(member(phenotypic_effect(G,M,0),Obs),
           write_neg_fact(OutputStr,phenotypic_effect(G,[M]))),
    close(OutputStr),
    experiment_trials(Path1),
    open(Path1,write,OutputStr1),
    writeln(OutputStr1,"% phenotypic effect experimental trials"),
    forall(member(phenotypic_effect(G,M,_),Obs),
           write_fact(OutputStr1,trial(phenotypic_effect(G,[M])))),
    close(OutputStr1),
    experiment_labels(Path2),
    open(Path2,write,OutputStr2),
    writeln(OutputStr2,"% positive examples"),
    forall(member(phenotypic_effect(G,M,1),Obs),
           write_fact(OutputStr2,l(phenotypic_effect(G,[M]),1))),
    nl(OutputStr2),
    writeln(OutputStr2,"% negative examples"),
    forall(member(phenotypic_effect(G,M,0),Obs),
           write_fact(OutputStr2,l(phenotypic_effect(G,[M]),0))),
    close(OutputStr2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generate_enz_id(N,N1,EnzId) :-
    N1 is N + 1,
    atom_concat(enz,N,EnzId).
generate_import_id(N,N1,EnzId) :-
    N1 is N + 1,
    atom_concat(i,N,EnzId).

find_all_enzyme_parts(RName,Gs) :-
    setof(Id,E^protein(E,RName,Id),Ids),
    findall(Es,(member(Id,Ids),find_all_enzyme_parts_(RName,Id,Es)),Gs).
find_all_enzyme_parts_(RName,Id,Gs) :-
    findall(Gene,(protein(E,RName,Id),
                (encodes_protein(G,E)->Gene=G;Gene=import)),Gs1),
    sort(Gs1,Gs).


%enzyme_mapping_entry(N,N1,[import],RName,[R],[],LB,UB,M,[enzyme_(EnzId,[import],[RName],[[R]],[[R1]],LB,UB)|M]) :-
%    generate_import_id(N,N1,EnzId),
%    (atom_concat(A,'_e',R); atom_concat(A,'_p',R)) -> atom_concat(A,'_c',R1).
%enzyme_mapping_entry(N,N1,[import],RName,[R],[],M,[enzyme_(EnzId,[import],[RName],[[R]],[[R1]])|M]) :-
%    generate_import_id(N,N1,EnzId),
%    atom_concat(A,'_c',R),
%    atom_concat(A,'_e',R1).
%enzyme_mapping_entry(N,N1,[import],RName,R,[],_LB,UB,M,[enzyme_(EnzId,[import],[RName],[R],[[]],-1.0,UB)|M]) :-
%    generate_import_id(N,N1,EnzId),!.
enzyme_mapping_entry(N,N1,[import],RName,R,P,LB,UB,M,[enzyme_(EnzId,[import],[RName],[R],[P],LB,UB)|M]) :-
    generate_import_id(N,N1,EnzId),!.
enzyme_mapping_entry(N,N1,Orfs,RName,R,P,LB,UB,M,[enzyme_(EnzId,Orfs,[RName],[R],[P],LB,UB)|M]) :-
    generate_enz_id(N,N1,EnzId),
    \+member(enzyme_(_,Orfs,_,_,_,LB,UB),M),!.
enzyme_mapping_entry(N,N,Orfs,RName,R,P,LB,UB,M,[enzyme_(E,Orfs,[RName|RNames],[R|Rs],[P|Ps],LB,UB)|M1]) :-
    setof(enzyme_(EnzId,Orfs1,RNames1,Rs1,Ps1,LB1,UB1),
            (
                member(enzyme_(EnzId,Orfs1,RNames1,Rs1,Ps1,LB1,UB1),M),
                (Orfs1 \== Orfs;[LB1,UB1] \== [LB,UB])
            ),
         M1),
    member(enzyme_(E,Orfs,RNames,Rs,Ps,LB,UB),M).


generate_enzyme_pathway_(N,N,[],_,_,_,_,_,M,M).
generate_enzyme_pathway_(N,N1,[Orfs|Gs],RName,R,P,LB,UB,M,M1) :-
    enzyme_mapping_entry(N,N2,Orfs,RName,R,P,LB,UB,M,M2),
    generate_enzyme_pathway_(N2,N1,Gs,RName,R,P,LB,UB,M2,M1).


generate_enzyme_pathway(N,N,[],M,M).
generate_enzyme_pathway(N,N2,[reaction(RName,R,P,LB,UB)|Rs],M,M1) :-
    find_all_enzyme_parts(RName,Gs),
    generate_enzyme_pathway_(N,N1,Gs,RName,R,P,LB,UB,M,M2),!,
    generate_enzyme_pathway(N1,N2,Rs,M2,M1).

shared_orfs(Orf,Enzs,Ids) :-
    findall(Enz,(member(enzyme_(Enz,Orfs,_,_,_,_,_),Enzs),member(Orf,Orfs)),Ids),
    \+length(Ids,1),
    \+length(Ids,0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creates metabolic pathway in prolog for ASE-progol based on the bk database file
% it requires iML1515_bk.pl, outputs enzyme pathways, enzyme sharing of ORFs and
% known enzyme coding functions

% swipl -s src/models/iML1515/parser.pl -t metabolic_pathway -q

metabolic_pathway :-
    db_path(Path),
    consult(Path),!,
    setof(reaction(RName,R,P,LB,UB),reaction(RName,R,P,LB,UB),Rs),
    generate_enzyme_pathway(0,_N,Rs,[],EP),
    reverse(EP,Pathway),
    model_path(Path1),
    open(Path1,write,OutputStr),
    findall(enzyme(Enz,Orfs,RNames,1,1,Rs1,Ps1),(member(enzyme_(Enz,Orfs,RNames,Rs1,Ps1,LB,_),Pathway),LB>=0),Pathway1),
    findall(enzyme(Enz,Orfs,RNames,2,1,Rs1,Ps1),(member(enzyme_(Enz,Orfs,RNames,Rs1,Ps1,LB,_),Pathway),LB<0),Pathway2),
    append(Pathway1,Pathway2,Pathway3),
    writeln(OutputStr,"% enzymatic relations in the pathway model"),
    write_facts(OutputStr,Pathway3),nl(OutputStr),
    findall(shared_orfs(Orf,Ids),(gene(Orf),shared_orfs(Orf,Pathway,Ids)),Shared),
    writeln(OutputStr,"% all enzymes sharing the same orfs"),
    write_facts(OutputStr,Shared),nl(OutputStr),
    findall(codes(G,Enz),(member(enzyme_(Enz,Orfs,_,_,_,_,_),Pathway),member(G,Orfs),G\==import),Codes),
    writeln(OutputStr,"% all gene functions"),
    sort(Codes,Codes1),
    write_facts(OutputStr,Codes1),
    close(OutputStr),
    length(Pathway3,N1),
    format("Created ~w enzyme paths\n",[N1]),
    length(Shared,N2),
    format("Found ~w shared orfs\n",[N2]),
    length(Codes,N3),
    format("Created ~w gene functions\n",[N3]).

reaction_matrix(Path) :-
    findall(reaction(N,R,P,L,H),reaction(N,R,P,L,H),Rs),
    tell(Path),
    write(':- discontiguous(rid/2), discontiguous(mstate1/2), discontiguous(mstate3/2).\n\n'),
    write(':- dynamic rid/2, mstate1/2, mstate3/2.\n\n'),
    reaction_matrix(0,Rs),
    told.



% all reactions         - 2712 (iML1515 claims to have 2719 which was an error)
% forward reactions     - 2049 (313 without product)
% backward reactions    - 663
% total compiled        - 3062

reaction_matrix(_,[]).
reaction_matrix(N,[R|Rs]) :-
    R=reaction(Name,Reactants,Products,L,_H),
    Products \== [],
    L>=0.0,!,
    lm_stob(Reactants,Rn),
    append(Reactants,Products,AllInvolved),
    lm_stob(AllInvolved,PRn),
    write_fact(rid(Name,N)),
    % reactant matrix for forward reactions
    write_fact(mstate1(N,Rn)),
    % reactant + product matrix for forward reactions
    write_fact(mstate3(N,PRn)),nl,
    N1 is N + 1,
    reaction_matrix(N1,Rs).
reaction_matrix(N,[R|Rs]) :-
    R=reaction(Name,Reactants,Products,L,_H),
    L<0.0,!,
    lm_stob(Reactants,Rn),
    lm_stob(Products,Pn),
    append(Reactants,Products,AllInvolved),
    lm_stob(AllInvolved,PRn),
    write_fact(rid(Name,N)),
    % reactant matrix for forward reactions
    write_fact(mstate1(N,Rn)),
    % product matrix for forward reactions
    write_fact(mstate3(N,PRn)),nl,
    N1 is N + 1,
    write_fact(rid(Name,N1)),
    % reactant matrix for backward reactions
    write_fact(mstate1(N1,Pn)),
    % reactant + product matrix for backward reactions
    write_fact(mstate3(N1,PRn)),nl,
    N2 is N1 + 1,
    reaction_matrix(N2,Rs).
reaction_matrix(N,[_|Rs]) :-!,
    % neglect forward reactions without a product for network traversal
    reaction_matrix(N,Rs).

matrix_path('framework/iML1515/lmatrix/reaction.pl').

metabolite_herbn :-
    db_path(Path),
    consult(Path),
    lmarith_path(Path1),
    consult(Path1),
    herbn_path(Path2),
    atom_string(PathA,Path2),
    setof(M,metabolite(M),Ms),
    lm_mkcton(Ms,PathA),!,
    consult(PathA),
    matrix_path(Path3),
    reaction_matrix(Path3).


%ends(['10fthf_c','2dmmql8_c','2fe2s_c','4fe4s_c','5mthf_c',accoa_c,adocbl_c,ala__L_c,amet_c,arg__L_c,asn__L_c,asp__L_c,atp_c,btn_c,ca2_c,chor_c,cl_c,clpn160_p,clpn161_p,clpn181_p,coa_c,cobalt2_c,colipa_e,ctp_c,cu2_c,cys__L_c,datp_c,dctp_c,dgtp_c,dttp_c,enter_c,fad_c,fe2_c,fe3_c,gln__L_c,glu__L_c,gly_c,glycogen_c,gthrd_c,gtp_c,h2o_c,hemeO_c,his__L_c,ile__L_c,k_c,leu__L_c,lipopb_c,lys__L_c,malcoa_c,met__L_c,mg2_c,mlthf_c,mn2_c,mobd_c,mococdp_c,mocogdp_c,mql8_c,murein3p3p_p,murein3px4p_p,murein4p4p_p,murein4px4p_p,murein4px4px4p_p,nad_c,nadh_c,nadp_c,nadph_c,nh4_c,ni2_c,pe160_p,pe161_p,pe181_p,pg160_p,pg161_p,pg181_p,phe__L_c,pheme_c,pro__L_c,ptrc_c,pydx5p_c,q8h2_c,ribflv_c,ser__L_c,sheme_c,so4_c,spmd_c,succoa_c,thf_c,thmpp_c,thr__L_c,trp__L_c,tyr__L_c,udcpdp_c,utp_c,val__L_c,zn2_c]).
%
%print_ends :-
%    forall((ends(L),member(M,L),atom_string(S,M)),(writeq(end(S)),writeln('.'))).