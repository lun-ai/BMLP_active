%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% growth environment definitions at the start
% and end of a cycle

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
        coa_c
    ]
).

%:- writeln('% Base growth medium'), growth_medium_composition(N), writeln(N), told.

% BIGG ids of essential metabolites (iML1515 biomass function)
ends(['10fthf_c','2dmmql8_c','2fe2s_c','4fe4s_c','5mthf_c',accoa_c,adocbl_c,ala__L_c,amet_c,arg__L_c,asn__L_c,asp__L_c,atp_c,btn_c,ca2_c,chor_c,cl_c,clpn160_p,clpn161_p,clpn181_p,coa_c,cobalt2_c,colipa_e,ctp_c,cu2_c,cys__L_c,datp_c,dctp_c,dgtp_c,dttp_c,enter_c,fad_c,fe2_c,fe3_c,gln__L_c,glu__L_c,gly_c,glycogen_c,gthrd_c,gtp_c,h2o_c,hemeO_c,his__L_c,ile__L_c,k_c,leu__L_c,lipopb_c,lys__L_c,malcoa_c,met__L_c,mg2_c,mlthf_c,mn2_c,mobd_c,mococdp_c,mocogdp_c,mql8_c,murein3p3p_p,murein3px4p_p,murein4p4p_p,murein4px4p_p,murein4px4px4p_p,nad_c,nadh_c,nadp_c,nadph_c,nh4_c,ni2_c,pe160_p,pe161_p,pe181_p,pg160_p,pg161_p,pg181_p,phe__L_c,pheme_c,pro__L_c,ptrc_c,pydx5p_c,q8h2_c,ribflv_c,ser__L_c,sheme_c,so4_c,spmd_c,succoa_c,thf_c,thmpp_c,thr__L_c,trp__L_c,tyr__L_c,udcpdp_c,utp_c,val__L_c,zn2_c]).

optional_nutrients(
    [
        'ac_e',
        'gal_e',
        'glcn_e',
        'glc__D_e',
        'glyc_e',
        'ala__L_e',
        'lac__L_e',
        'malt_e',
        'mnl_e',
        'acgam_e',
        'akg_e',
        'pyr_e',
        'rib__D_e',
        'sbt__D_e',
        'succ_e',
        'xyl__D_e',
        'cit_e'
    ]
).


% cost of optional metabolites
%   unit cost is the cost of the cheapest metabolite
unit_cost(0.0359).
%unit_cost(1).

% the base medium is M9 medium (growth_medium_composition)
%   its cost is M9 medium's cost
%base_mcost(4.58532).
% account for only added metabolites since amount of medium used in experiment differ greatly from
%   optional metabolites
base_mcost(0.0).

mcost('ac_e',0.0748).
mcost('gal_e',0.534).
mcost('glcn_e',0.0359).
mcost('glc__D_e',0.0476).
mcost('glyc_e',0.07).
mcost('ala__L_e',0.81).
mcost('lac__L_e',0.0546).
mcost('malt_e',0.244).
mcost('mnl_e',0.0936).
mcost('acgam_e',2.93).
mcost('akg_e',0.437).
mcost('pyr_e',0.2776).
mcost('rib__D_e',0.993).
mcost('sbt__D_e',0.196).
mcost('succ_e',0.0825).
mcost('xyl__D_e',0.51).

energy(_,1).