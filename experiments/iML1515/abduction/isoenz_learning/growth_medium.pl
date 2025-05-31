% composition as the single knockout library with some additions
growth_medium_composition(
    [
        o2_e,
        cl_e,
        na1_e,
        pi_e,
        cl_e,
        h_e,
        mg2_e,
        ca2_e,
        h2o_e,
        so4_e,
        nh4_e,
        k_e,
        co2_e,
        atp_c,
        nad_c,
        nadph_c,
        nadp_c,
        % optional metabolites
        'ACP_c', % Acyl carrier protein
        flxr_c, % Flavodoxin reduced
        moco_c,
        thm_c,
        adocbl_c,
        lipopb_c,
        sufbcd_c,
        sufse_c,
        trdrd_c,
        trnaglu_c,
        coa_c,

        glc__D_e % added to the base metabolites only for 2KO
    ]
).

:- write('% Base growth medium: '), growth_medium_composition(N), writeln(N).

optional_nutrients(['indole_e','phe__L_e','tyr__L_e','trp__L_e','skm_e']).

ends(['10fthf_c','2dmmql8_c','2fe2s_c','4fe4s_c','5mthf_c',accoa_c,adocbl_c,ala__L_c,amet_c,arg__L_c,asn__L_c,asp__L_c,atp_c,btn_c,ca2_c,chor_c,cl_c,clpn160_p,clpn161_p,clpn181_p,coa_c,cobalt2_c,colipa_e,ctp_c,cu2_c,cys__L_c,datp_c,dctp_c,dgtp_c,dttp_c,enter_c,fad_c,fe2_c,fe3_c,gln__L_c,glu__L_c,gly_c,glycogen_c,gthrd_c,gtp_c,h2o_c,hemeO_c,his__L_c,ile__L_c,k_c,leu__L_c,lipopb_c,lys__L_c,malcoa_c,met__L_c,mg2_c,mlthf_c,mn2_c,mobd_c,mococdp_c,mocogdp_c,mql8_c,murein3p3p_p,murein3px4p_p,murein4p4p_p,murein4px4p_p,murein4px4px4p_p,nad_c,nadh_c,nadp_c,nadph_c,nh4_c,ni2_c,pe160_p,pe161_p,pe181_p,pg160_p,pg161_p,pg181_p,phe__L_c,pheme_c,pro__L_c,ptrc_c,pydx5p_c,q8h2_c,ribflv_c,ser__L_c,sheme_c,so4_c,spmd_c,succoa_c,thf_c,thmpp_c,thr__L_c,trp__L_c,tyr__L_c,udcpdp_c,utp_c,val__L_c,zn2_c]).

% updated by Shishun on 26/5/2023
protein_targets([
    tnaA,
    trpE,
    aroH,
    pheA,
%    trpR,
    trpD,
    tyrA,
    aroF,
    aroC,
    tyrB,
    aroL,
    aroE,
    aspC,
    trpA,
    trpB,
    cysJ,
    purH,
    purM,
    purK,
    metE,
    pyrD,
    pyrE,
    cysQ,
    serC,
    cysI,
    purL,
    carB,
    purC,
    ilvE,
    thrC,
    trpC,
    pyrF,
    atpB,
    pdxH
]).

all_orfs(ORFs) :-
    consult('framework/iML1515/iML1515_bk'),
    protein_targets(Ps),
    findall(ORF,(member(P,Ps),encodes_protein(ORF,P)),ORFs).

test :-
    all_orfs(O),
    consult('abduction/cand_orfs_preds_213.pl'),
    setof(O1,(member(O1,O),\+label(phenotypic_effect(O1,_),_)),ORFs),
    unload_file('abduction/cand_orfs_preds_213.pl'),
    consult('iML1515_bk.pl'),
    writeln(ORFs),
    findall(P,(member(O2,ORFs),encodes_protein(O2,P)),Proteins),
    writeln(Proteins),!,
    consult('results/04_11_2023_14:36:15/results.pl'),
    findall(phenotypic_effect([O1,O2],Cond),(member(O1,ORFs),member(O2,ORFs),label(phenotypic_effect([O1,O2],Cond),1)),Effects),
    writeln(Effects).

% increase cost for floating point computation
unit_cost(0.0346).
mcost('indole_e',0.0428).
mcost('phe__L_e',0.0346).
mcost('tyr__L_e',0.0346).
mcost('trp__L_e',0.0346).
mcost('skm_e',8.2).
mcost('asp__L_c',0.0156).
% the base medium is M9 medium (growth_medium_composition)
%   its cost is M9 medium's cost
%   otherwise will keep selecting empty medium experiments
base_mcost(4.58532).
