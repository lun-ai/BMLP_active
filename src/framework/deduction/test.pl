:- ['src/models/iML1515/iML1515_bk.pl'].
:- ['src/models/iML1515/iML1515_pathway.pl'].
:- [run].
:- use_module(library(random)).

mutant_product(1,['10fthf_c','12dgr120_c','12dgr120_p','12dgr140_c','12dgr140_p','12dgr141_c','12dgr141_p','12dgr160_c','12dgr160_p','12dgr161_c','12dgr161_p','12dgr180_c','12dgr180_p','12dgr181_c','12dgr181_p','12ppd__R_c','12ppd__R_e','12ppd__R_p','12ppd__S_c','12ppd__S_e','12ppd__S_p','13dpg_c','14dhncoa_c','15dap_c','15dap_e','15dap_p','1agpe120_p','1agpe140_p','1agpe141_p','1agpe160_p','1agpe161_p','1agpe180_p','1agpe181_p','1agpg120_p','1agpg140_p','1agpg141_p','1agpg160_p','1agpg161_p','1agpg180_p','1agpg181_p','1ddecg3p_c','1ddecg3p_p','1hdec9eg3p_c','1hdec9eg3p_p','1hdecg3p_c','1hdecg3p_p','1odec11eg3p_c','1odec11eg3p_p','1odecg3p_c','1odecg3p_p','1pyr5c_c','1tdec7eg3p_c','1tdec7eg3p_p','1tdecg3p_c','1tdecg3p_p','23ddhb_c','23dhb_c','23dhba_c','23dhbzs3_c','23dhbzs_c','23dhdp_c','23dhmb_c','23dhmp_c','25aics_c','25drapp_c','26dap_LL_c','26dap__M_c','2agpe120_c','2agpe120_p','2agpe140_c','2agpe140_p','2agpe141_c','2agpe141_p','2agpe160_c','2agpe160_p','2agpe161_c','2agpe161_p','2agpe180_c','2agpe180_p','2agpe181_c','2agpe181_p','2agpg120_c','2agpg120_p','2agpg140_c','2agpg140_p','2agpg141_c','2agpg141_p','2agpg160_c','2agpg160_p','2agpg161_c','2agpg161_p','2agpg180_c','2agpg180_p','2agpg181_c','2agpg181_p','2ahbut_c','2amsa_c','2aobut_c','2cpr5p_c','2dda7p_c','2ddara_c','2ddecg3p_c','2ddecg3p_p','2ddg6p_c','2dh3dgal6p_c','2dhp_c','2dmmq8_c','2dmmql8_c','2dr1p_c','2dr5p_c','2fe1s_c','2fe2s_c','2h3oppan_c','2hdec9eg3p_c','2hdec9eg3p_p','2hdecg3p_c','2hdecg3p_p','2ippm_c','2mahmp_c','2mcacn_c','2mcit_c','2me4p_c','2mecdp_c','2obut_c','2odec11eg3p_c','2odec11eg3p_p','2odecg3p_c','2odecg3p_p','2ohph_c','2ombzl_c','2omhmbl_c','2ommbl_c','2omph_c','2oph_c','2p4c2me_c','2pg_c','2sephchc_c','2shchc_c','2tdec7eg3p_c','2tdec7eg3p_p','2tdecg3p_c','2tdecg3p_p','2tpr3dpcoa_c','34hpp_c','35cgmp_c','36dahx_c','3amac_c','3c2hmp_c','3c3hmp_c','3c4mop_c','3dhq_c','3dhsk_c','3fe4s_c','3haACP_c','3hbcoa_c','3hcddec5eACP_c','3hcmrs7eACP_c','3hcpalm9eACP_c','3hcvac11eACP_c','3hdcoa_c','3hddcoa_c','3hddecACP_c','3hdecACP_c','3hhcoa_c','3hhdcoa_c','3hhexACP_c','3hmrsACP_c','3hocoa_c','3hoctACP_c','3hoctaACP_c','3hodcoa_c','3hpalmACP_c','3hpp_c','3hpp_e','3hpp_p','3htdcoa_c','3ig3p_c','3mob_c','3mop_c','3ocddec5eACP_c','3ocmrs7eACP_c','3ocpalm9eACP_c','3ocvac11eACP_c','3odcoa_c','3oddcoa_c','3oddecACP_c','3odecACP_c','3ohcoa_c','3ohdcoa_c','3ohexACP_c','3ohodcoa_c','3omrsACP_c','3oocoa_c','3ooctACP_c','3ooctdACP_c','3opalmACP_c','3ophb_c','3otdcoa_c','3pg_c','3php_c','3psme_c','4abut_c','4abut_e','4abut_p','4abutn_c','4abz_c','4abzglu_c','4abzglu_e','4abzglu_p','4adcho_c','4ampm_c','4c2me_c','4crsol_c','4fe4s_c','4hbz_c','4hbz_p','4hthr_c','4mop_c','4pasp_c','4per_c','4ppan_c','4ppcys_c','4r5au_c','56dura_c','5aizc_c','5aop_c','5aprbu_c','5apru_c','5caiz_c','5dglcn_c','5dglcn_e','5dglcn_p','5drib_c','5fthf_c','5mta_c','5mthf_c','5mtr_c','5mtr_e','5mtr_p','5pg35pg_c','6hmhpt_c','6hmhptpp_c','6pgc_c','6pgl_c','8aonn_c','ACP_c','LalaDgluMdapDala_c','LalaDgluMdapDala_e','LalaDgluMdapDala_p','LalaDgluMdap_c','LalaDgluMdap_e','LalaDgluMdap_p','LalaDglu_c','LalaLglu_c','N1aspmd_c','S2hglut_c','aacoa_c','aact_c','acACP_c','ac_c','ac_e','ac_p','acald_c','acald_e','acald_p','acanth_c','accoa_c','acetol_c','acg5p_c','acg5sa_c','acgam1p_c','acgam6p_c','acgam_c','acglc__D_c','acglu_c','acmanap_c','acmet_c','acmum6p_c','acolipa_e','acolipa_p','acon_C_c','acon_T_c','aconm_c','acorn_c','acser_c','acser_e','acser_p','actACP_c','actp_c','ade_c','ade_e','ade_p','adn_c','adn_e','adn_p','adocbl_c','adp_c','adpglc_c','adphep_DD_c','adphep_LD_c','adprib_c','agm_c','agm_e','agm_p','ahcys_c','ahdt_c','aicar_c','air_c','akg_c','akg_e','akg_p','ala_B_c','ala__D_c','ala__D_e','ala__D_p','ala__L_c','ala__L_e','ala__L_p','alaala_c','alaala_e','alaala_p','alac__S_c','all6p_c','alltn_c','alltn_e','alltn_p','alltt_c','allul6p_c','amet_c','ametam_c','amob_c','amp_c','anhgm3p_c','anhgm3p_p','anhgm4p_c','anhgm4p_p','anhgm_c','anhgm_e','anhgm_p','anhm3p_c','anhm4p_c','anhm_c','anth_c','ap4a_c','apg120_c','apg140_c','apg141_c','apg160_c','apg161_c','apg180_c','apg181_c','appl_c','aps_c','ara5p_c','arab__D_c','arg__L_c','arg__L_e','arg__L_p','argsuc_c','asn__L_c','asn__L_e','asn__L_p','asp__L_c','asp__L_e','asp__L_p','aspsa_c','athr__L_c','athtp_c','atp_c','b2coa_c','bglycogen_c','btcoa_c','btn_c','but2eACP_c','butACP_c','ca2_c','ca2_e','ca2_p','camp_c','cbasp_c','cbl1_c','cbm_c','cbp_c','cddec5eACP_c','cdec3eACP_c','cdg_c','cdigmp_c','cdp_c','cdpdddecg_c','cdpdhdec9eg_c','cdpdhdecg_c','cdpdodec11eg_c','cdpdodecg_c','cdpdtdec7eg_c','cdpdtdecg_c','cgly_c','cgly_e','cgly_p','chor_c','cit_c','cit_e','cit_p','citr__L_c','ckdo_c','cl_c','cl_e','cl_p','clpn120_p','clpn140_p','clpn141_p','clpn160_p','clpn161_p','clpn180_p','clpn181_p','cmp_c','co2_c','co2_e','co2_p','coa_c','cobalt2_c','cobalt2_e','cobalt2_p','colipa_c','colipa_e','colipa_p','colipap_e','colipap_p','cpe160_c','cpe180_c','cpg160_c','cpg180_c','cph4_c','cpmp_c','cpppg3_c','csn_c','ctp_c','cu2_c','cu2_e','cu2_p','cxsam_c','cys__L_c','cys__L_e','cys__L_p','cyst__L_c','cytd_c','cytd_e','cytd_p','dad_2_c','dad_5_c','dadp_c','damp_c','dann_c','datp_c','db4p_c','dc2coa_c','dcaACP_c','dca_c','dcacoa_c','dcamp_c','dcdp_c','dcmp_c','dctp_c','dcyt_c','dd2coa_c','ddcaACP_c','ddca_c','ddca_p','ddcacoa_c','ddcap_c','dgdp_c','dgmp_c','dgslnt_c','dgsn_c','dgtp_c','dha_c','dha_e','dha_p','dhap_c','dhf_c','dhgly_c','dhmpt_c','dhmptp_c','dhna_c','dhnpt_c','dhor__S_c','dhpmp_c','dhpt_c','dhptd_c','dhptdd_c','dhptdp_c','didp_c','dimp_c','din_c','ditp_c','dmlz_c','dmpp_c','dnad_c','dpcoa_c','dscl_c','dtbt_c','dtdp4aaddg_c','dtdp4addg_c','dtdp4d6dg_c','dtdp4d6dm_c','dtdp_c','dtdpglu_c','dtdprmn_c','dtmp_c','dttp_c','dudp_c','dump_c','duri_c','dutp_c','dxyl5p_c','dxylnt_c','dxylnt_e','dxylnt_p','e4p_c','eca2und_p','eca3und_p','eca4colipa_e','eca4colipa_p','eca4und_p','egmeACP_c','eig3p_c','enlipa_e','enlipa_p','enter_c','enter_e','enter_p','epmeACP_c','erthrs_c','etha_c','etha_e','etha_p','etoh_c','etoh_e','etoh_p','f6p_c','fad_c','fad_e','fad_p','fadh2_c','fc1p_c','fdp_c','fe2_c','fe2_e','fe2_p','fe3_c','fe3_e','fe3_p','fe3dcit_e','fe3dcit_p','fe3dhbzs3_c','feenter_c','feenter_e','feenter_p','fgam_c','flxr_c','flxso_c','fmn_c','fmn_e','fmn_p','fmnh2_c','for_c','for_e','for_p','fpram_c','fprica_c','frdp_c','fru_c','frulysp_c','fum_c','fum_e','fum_p','g1p_c','g3p_c','g3pe_c','g3pe_e','g3pe_p','g3pg_c','g3pg_e','g3pg_p','g6p_c','gagicolipa_c','gal1p_c','gal_c','gam1p_c','gam6p_c','gar_c','gcald_c','gdp_c','gdpddman_c','gdpfuc_c','gdpmann_c','gdpofuc_c','gdptp_c','gg4abut_c','ggagicolipa_c','ggbutal_c','gggagicolipa_c','ggptrc_c','ghb_c','gicolipa_c','glc__D_c','glc__D_e','glc__D_p','glcn_c','glcn_e','glcn_p','gln__L_c','glu1sa_c','glu5p_c','glu5sa_c','glu__D_c','glu__L_c','glu__L_e','glu__L_p','glucys_c','glutrna_c','glx_c','gly_c','gly_e','gly_p','glyald_c','glyald_e','glyald_p','glyc3p_c','glyc3p_e','glyc3p_p','glyc__R_c','glyc__R_e','glyc__R_p','glyc_c','glyc_e','glyc_p','glyclt_c','glyclt_e','glyclt_p','glycogen_c','gmeACP_c','gmhep17bp_c','gmhep1p_c','gmhep7p_c','gmp_c','grdp_c','gslnt_c','gsn_c','gsn_e','gsn_p','gthox_c','gthrd_c','gthrd_e','gthrd_p','gtp_c','gtspmd_c','gua_c','gua_e','gua_p','h2_c','h2_e','h2_p','h2mb4p_c','h2o2_c','h2o_c','h2o_e','h2o_p','h2s_c','h2s_e','h2s_p','h_c','h_e','h_p','hco3_c','hcys__L_c','hdca_c','hdca_p','hdcap_c','hdcea_c','hdcea_p','hdceap_c','hdcoa_c','hdd2coa_c','hdeACP_c','hemeO_c','hexACP_c','hgmeACP_c','hhlipa_c','his__L_c','his__L_e','his__L_p','hisp_c','histd_c','hlipa_c','hmbil_c','hom__L_c','hom__L_e','hom__L_p','hphhlipa_c','hpmeACP_c','hpyr_c','hx2coa_c','hxa_c','hxa_e','hxa_p','hxan_c','hxan_e','hxan_p','hxcoa_c','iasp_c','ichor_c','icit_c','icolipa_c','idon__L_c','idon__L_e','idon__L_p','idp_c','ile__L_c','ile__L_e','ile__L_p','imacp_c','imp_c','indole_c','indole_e','indole_p','ins_c','ins_e','ins_p','ipdp_c','itp_c','k_c','k_e','k_p','kdo2lipid4L_c','kdo2lipid4_c','kdo2lipid4_e','kdo2lipid4_p','kdo2lipid4p_c','kdo8p_c','kdo_c','kdolipid4_c','kphphhlipa_c','lac__D_c','lac__D_e','lac__D_p','lac__L_c','lac__L_e','lac__L_p','lald__D_c','lald__L_c','leu__L_c','leu__L_e','leu__L_p','lgt__S_c','lipa_c','lipa_cold_c','lipa_cold_e','lipa_cold_p','lipa_e','lipa_p','lipidA_c','lipidAds_c','lipidX_c','lipopb_c','lkdr_c','lys__L_c','lys__L_e','lys__L_p','malACP_c','mal__L_c','mal__L_e','mal__L_p','malcoa_c','malcoame_c','man1p_c','man6p_c','man_c','mdhdhf_c','meoh_c','meoh_e','meoh_p','mercppyr_c','met__L_c','met__L_e','met__L_p','methf_c','metsox_R__L_c','metsox_S__L_c','mg2_c','mg2_e','mg2_p','micit_c','mlthf_c','mmcoa__S_c','mn2_c','mn2_e','mn2_p','mnl1p_c','mobd_c','mobd_e','mobd_p','moco_c','mococdp_c','mocogdp_c','mql8_c','mqn8_c','msa_c','mthgxl_c','mththf_c','mththf_e','mththf_p','murein3p3p_p','murein3px3p_p','murein3px4p_p','murein4p3p_p','murein4p4p_p','murein4px4p4p_p','murein4px4p_p','murein4px4px4p_p','murein5p3p_p','murein5p4p_p','murein5p5p5p_p','murein5p5p_p','murein5px3p_p','murein5px4p_p','murein5px4px4p_p','myrsACP_c','n8aspmd_c','na15dap_c','na1_c','na1_e','na1_p','nac_c','nad_c','nadh_c','nadhx__R_c','nadhx__S_c','nadp_c','nadph_c','nadphx__R_c','nadphx__S_c','ncam_c','nh4_c','nh4_e','nh4_p','ni2_c','ni2_e','ni2_p','nicrnt_c','nmn_c','o2_c','o2_e','o2_p','o2s_c','oaa_c','oc2coa_c','ocACP_c','occoa_c','ocdcaACP_c','ocdca_c','ocdca_p','ocdcap_c','ocdcea_c','ocdcea_p','ocdceap_c','octa_c','octapb_c','octdp_c','octeACP_c','od2coa_c','odecoa_c','ogmeACP_c','ohpb_c','opmeACP_c','orn_c','orn_e','orn_p','orot5p_c','orot_c','oxam_c','oxur_c','pa120_c','pa120_p','pa140_c','pa140_p','pa141_c','pa141_p','pa160_c','pa160_p','pa161_c','pa161_p','pa180_c','pa180_p','pa181_c','pa181_p','palmACP_c','pan4p_c','pant__R_c','pap_c','paps_c','pdx5p_c','pe120_c','pe120_p','pe140_c','pe140_p','pe141_c','pe141_p','pe160_c','pe160_p','pe161_c','pe161_p','pe180_c','pe180_p','pe181_c','pe181_p','pep_c','pg120_c','pg120_p','pg140_c','pg140_p','pg141_c','pg141_p','pg160_c','pg160_p','pg161_c','pg161_p','pg180_c','pg180_p','pg181_c','pg181_p','pgp120_c','pgp120_p','pgp140_c','pgp140_p','pgp141_c','pgp141_p','pgp160_c','pgp160_p','pgp161_c','pgp161_p','pgp180_c','pgp180_p','pgp181_c','pgp181_p','phe__L_c','phe__L_e','phe__L_p','pheme_c','pheme_e','pheme_p','phhlipa_c','phom_c','phphhlipa_c','phpyr_c','phthr_c','pi_c','pi_e','pi_p','pimACP_c','pmeACP_c','pmtcoa_c','pnto__R_c','poaac_c','ppa_c','ppap_c','ppbng_c','ppcoa_c','ppgpp_c','pphn_c','ppi_c','ppp9_c','pppg9_c','pppi_c','pram_c','pran_c','prbamp_c','prbatp_c','preq0_c','preq1_c','prfp_c','prlp_c','pro__L_c','pro__L_e','pro__L_p','prpncoa_c','prpp_c','ps120_c','ps140_c','ps141_c','ps160_c','ps161_c','ps180_c','ps181_c','psd5p_c','pser__L_c','ptrc_c','ptrc_e','ptrc_p','puacgam_c','puacgam_p','pyam5p_c','pydam_c','pydx5p_c','pydx_c','pydxn_c','pyr_c','pyr_e','pyr_p','q8_c','q8h2_c','quln_c','r15bp_c','r1p_c','r2hglut_c','r5p_c','rbflvrd_c','rbl__D_c','rhcys_c','rhmn_c','rib__D_c','ribflv_c','ribflv_p','rml1p_c','ru5p__D_c','ru5p__L_c','s17bp_c','s7p_c','sbt6p_c','sbzcoa_c','scl_c','sel_c','sel_e','sel_p','seln_c','selnp_c','ser__D_c','ser__L_c','ser__L_e','ser__L_p','seramp_c','sheme_c','skm5p_c','skm_c','sl26da_c','sl2a6o_c','slnt_c','slnt_e','slnt_p','so3_c','so4_c','so4_e','so4_p','spmd_c','spmd_e','spmd_p','stcoa_c','sucarg_c','sucbz_c','succ_c','succ_e','succ_p','succoa_c','sucglu_c','sucgsa_c','suchms_c','sucorn_c','sucsal_c','sufbcd_2fe2s2_c','sufbcd_2fe2s_c','sufbcd_4fe4s_c','sufbcd_c','sufse_c','sufsesh_c','t3c11vaceACP_c','t3c5ddeceACP_c','t3c7mrseACP_c','t3c9palmeACP_c','tagdp__D_c','td2coa_c','tdcoa_c','tddec2eACP_c','tdeACP_c','tdec2eACP_c','tdecoa_c','thdp_c','thex2eACP_c','thf_c','thm_c','thmmp_c','thmnp_c','thmpp_c','thr__L_c','thr__L_e','thr__L_p','thym_c','thym_e','thym_p','thymd_c','thymd_e','thymd_p','tmrs2eACP_c','toct2eACP_c','toctd2eACP_c','tpalm2eACP_c','trdox_c','trdrd_c','tre6p_c','tre_c','trnaglu_c','trp__L_c','trp__L_e','trp__L_p','ttdca_c','ttdca_p','ttdcap_c','ttdcea_c','ttdcea_p','ttdceap_c','tungs_c','tungs_e','tungs_p','tyr__L_c','tyr__L_e','tyr__L_p','u23ga_c','u3aga_c','u3hga_c','uLa4fn_c','uLa4n_c','uLa4n_p','uaagmda_c','uaccg_c','uacgam_c','uacmam_c','uacmamu_c','uagmda_c','uama_c','uamag_c','uamr_c','udcpdp_c','udcpdp_p','udcpgl_c','udcpp_c','udcpp_p','udpLa4fn_c','udpLa4n_c','udpLa4o_c','udp_c','udpg_c','udpgal_c','udpgalfur_c','udpglcur_c','ugmd_c','ugmda_c','um4p_c','ump_c','unaga_c','unagamu_c','unagamuf_c','unagamuf_p','uppg3_c','ura_c','ura_e','ura_p','uracp_c','urate_c','urdgci_c','urdglyc_c','urea_c','urea_e','urea_p','uri_c','uri_e','uri_p','utp_c','val__L_c','val__L_e','val__L_p','xan_c','xan_e','xan_p','xdp_c','xmp_c','xtp_c','xtsn_c','xtsn_e','xtsn_p','xu5p__D_c','zn2_c','zn2_e','zn2_p']).
mutant_product(2,['10fthf_c','12dgr120_c','12dgr120_p','12dgr140_c','12dgr140_p','12dgr141_c','12dgr141_p','12dgr160_c','12dgr160_p','12dgr161_c','12dgr161_p','12dgr180_c','12dgr180_p','12dgr181_c','12dgr181_p','12ppd__R_c','12ppd__R_e','12ppd__R_p','12ppd__S_c','12ppd__S_e','12ppd__S_p','13dpg_c','14dhncoa_c','15dap_c','15dap_e','15dap_p','1agpe120_p','1agpe140_p','1agpe141_p','1agpe160_p','1agpe161_p','1agpe180_p','1agpe181_p','1agpg120_p','1agpg140_p','1agpg141_p','1agpg160_p','1agpg161_p','1agpg180_p','1agpg181_p','1ddecg3p_c','1ddecg3p_p','1hdec9eg3p_c','1hdec9eg3p_p','1hdecg3p_c','1hdecg3p_p','1odec11eg3p_c','1odec11eg3p_p','1odecg3p_c','1odecg3p_p','1pyr5c_c','1tdec7eg3p_c','1tdec7eg3p_p','1tdecg3p_c','1tdecg3p_p','23ddhb_c','23dhb_c','23dhba_c','23dhbzs3_c','23dhbzs_c','23dhdp_c','23dhmb_c','23dhmp_c','25aics_c','25drapp_c','26dap_LL_c','26dap__M_c','2agpe120_c','2agpe120_p','2agpe140_c','2agpe140_p','2agpe141_c','2agpe141_p','2agpe160_c','2agpe160_p','2agpe161_c','2agpe161_p','2agpe180_c','2agpe180_p','2agpe181_c','2agpe181_p','2agpg120_c','2agpg120_p','2agpg140_c','2agpg140_p','2agpg141_c','2agpg141_p','2agpg160_c','2agpg160_p','2agpg161_c','2agpg161_p','2agpg180_c','2agpg180_p','2agpg181_c','2agpg181_p','2ahbut_c','2amsa_c','2aobut_c','2cpr5p_c','2dda7p_c','2ddara_c','2ddecg3p_c','2ddecg3p_p','2ddg6p_c','2dh3dgal6p_c','2dhp_c','2dmmq8_c','2dmmql8_c','2dr1p_c','2dr5p_c','2fe1s_c','2fe2s_c','2h3oppan_c','2hdec9eg3p_c','2hdec9eg3p_p','2hdecg3p_c','2hdecg3p_p','2ippm_c','2mahmp_c','2mcacn_c','2mcit_c','2me4p_c','2mecdp_c','2obut_c','2odec11eg3p_c','2odec11eg3p_p','2odecg3p_c','2odecg3p_p','2ohph_c','2ombzl_c','2omhmbl_c','2ommbl_c','2omph_c','2oph_c','2p4c2me_c','2pg_c','2sephchc_c','2shchc_c','2tdec7eg3p_c','2tdec7eg3p_p','2tdecg3p_c','2tdecg3p_p','2tpr3dpcoa_c','34hpp_c','35cgmp_c','36dahx_c','3amac_c','3c2hmp_c','3c3hmp_c','3c4mop_c','3dhq_c','3dhsk_c','3fe4s_c','3haACP_c','3hbcoa_c','3hcddec5eACP_c','3hcmrs7eACP_c','3hcpalm9eACP_c','3hcvac11eACP_c','3hdcoa_c','3hddcoa_c','3hddecACP_c','3hdecACP_c','3hhcoa_c','3hhdcoa_c','3hhexACP_c','3hmrsACP_c','3hocoa_c','3hoctACP_c','3hoctaACP_c','3hodcoa_c','3hpalmACP_c','3hpp_c','3hpp_e','3hpp_p','3htdcoa_c','3ig3p_c','3mob_c','3mop_c','3ocddec5eACP_c','3ocmrs7eACP_c','3ocpalm9eACP_c','3ocvac11eACP_c','3odcoa_c','3oddcoa_c','3oddecACP_c','3odecACP_c','3ohcoa_c','3ohdcoa_c','3ohexACP_c','3ohodcoa_c','3omrsACP_c','3oocoa_c','3ooctACP_c','3ooctdACP_c','3opalmACP_c','3ophb_c','3otdcoa_c','3pg_c','3php_c','3psme_c','4abut_c','4abut_e','4abut_p','4abutn_c','4abz_c','4abzglu_c','4abzglu_e','4abzglu_p','4adcho_c','4ampm_c','4c2me_c','4crsol_c','4fe4s_c','4hbz_c','4hbz_p','4hthr_c','4mop_c','4pasp_c','4per_c','4ppan_c','4ppcys_c','4r5au_c','56dura_c','5aizc_c','5aop_c','5aprbu_c','5apru_c','5caiz_c','5dglcn_c','5dglcn_e','5dglcn_p','5drib_c','5fthf_c','5mta_c','5mthf_c','5mtr_c','5mtr_e','5mtr_p','5pg35pg_c','6hmhpt_c','6hmhptpp_c','6pgc_c','6pgl_c','8aonn_c','ACP_c','LalaDgluMdapDala_c','LalaDgluMdapDala_e','LalaDgluMdapDala_p','LalaDgluMdap_c','LalaDgluMdap_e','LalaDgluMdap_p','LalaDglu_c','LalaLglu_c','N1aspmd_c','S2hglut_c','aacoa_c','aact_c','acACP_c','ac_c','ac_e','ac_p','acald_c','acald_e','acald_p','acanth_c','accoa_c','acetol_c','acg5p_c','acg5sa_c','acgam1p_c','acgam6p_c','acgam_c','acgam_e','acgam_p','acglc__D_c','acglu_c','acmanap_c','acmet_c','acmum6p_c','acolipa_e','acolipa_p','acon_C_c','acon_T_c','aconm_c','acorn_c','acser_c','acser_e','acser_p','actACP_c','actp_c','ade_c','ade_e','ade_p','adn_c','adn_e','adn_p','adocbl_c','adp_c','adpglc_c','adphep_DD_c','adphep_LD_c','adprib_c','agm_c','agm_e','agm_p','ahcys_c','ahdt_c','aicar_c','air_c','akg_c','akg_e','akg_p','ala_B_c','ala__D_c','ala__D_e','ala__D_p','ala__L_c','ala__L_e','ala__L_p','alaala_c','alaala_e','alaala_p','alac__S_c','all6p_c','alltn_c','alltn_e','alltn_p','alltt_c','allul6p_c','amet_c','ametam_c','amob_c','amp_c','anhgm3p_c','anhgm3p_p','anhgm4p_c','anhgm4p_p','anhgm_c','anhgm_e','anhgm_p','anhm3p_c','anhm4p_c','anhm_c','anth_c','ap4a_c','apg120_c','apg140_c','apg141_c','apg160_c','apg161_c','apg180_c','apg181_c','appl_c','aps_c','ara5p_c','arab__D_c','arg__L_c','arg__L_e','arg__L_p','argsuc_c','asn__L_c','asn__L_e','asn__L_p','asp__L_c','asp__L_e','asp__L_p','aspsa_c','athr__L_c','athtp_c','atp_c','b2coa_c','bglycogen_c','btcoa_c','btn_c','but2eACP_c','butACP_c','ca2_c','ca2_e','ca2_p','camp_c','cbasp_c','cbl1_c','cbm_c','cbp_c','cddec5eACP_c','cdec3eACP_c','cdg_c','cdigmp_c','cdp_c','cdpdddecg_c','cdpdhdec9eg_c','cdpdhdecg_c','cdpdodec11eg_c','cdpdodecg_c','cdpdtdec7eg_c','cdpdtdecg_c','cgly_c','cgly_e','cgly_p','chor_c','cit_c','cit_e','cit_p','citr__L_c','ckdo_c','cl_c','cl_e','cl_p','clpn120_p','clpn140_p','clpn141_p','clpn160_p','clpn161_p','clpn180_p','clpn181_p','cmp_c','co2_c','co2_e','co2_p','coa_c','cobalt2_c','cobalt2_e','cobalt2_p','colipa_c','colipa_e','colipa_p','colipap_e','colipap_p','cpe160_c','cpe180_c','cpg160_c','cpg180_c','cph4_c','cpmp_c','cpppg3_c','csn_c','ctp_c','cu2_c','cu2_e','cu2_p','cxsam_c','cys__L_c','cys__L_e','cys__L_p','cyst__L_c','cytd_c','cytd_e','cytd_p','dad_2_c','dad_5_c','dadp_c','damp_c','dann_c','datp_c','db4p_c','dc2coa_c','dcaACP_c','dca_c','dcacoa_c','dcamp_c','dcdp_c','dcmp_c','dctp_c','dcyt_c','dd2coa_c','ddcaACP_c','ddca_c','ddca_p','ddcacoa_c','ddcap_c','dgdp_c','dgmp_c','dgslnt_c','dgsn_c','dgtp_c','dha_c','dha_e','dha_p','dhap_c','dhf_c','dhgly_c','dhmpt_c','dhmptp_c','dhna_c','dhnpt_c','dhor__S_c','dhpmp_c','dhpt_c','dhptd_c','dhptdd_c','dhptdp_c','didp_c','dimp_c','din_c','ditp_c','dmlz_c','dmpp_c','dnad_c','dpcoa_c','dscl_c','dtbt_c','dtdp4aaddg_c','dtdp4addg_c','dtdp4d6dg_c','dtdp4d6dm_c','dtdp_c','dtdpglu_c','dtdprmn_c','dtmp_c','dttp_c','dudp_c','dump_c','duri_c','dutp_c','dxyl5p_c','dxylnt_c','dxylnt_e','dxylnt_p','e4p_c','eca2und_p','eca3und_p','eca4colipa_e','eca4colipa_p','eca4und_p','egmeACP_c','eig3p_c','enlipa_e','enlipa_p','enter_c','enter_e','enter_p','epmeACP_c','erthrs_c','etha_c','etha_e','etha_p','etoh_c','etoh_e','etoh_p','f6p_c','fad_c','fad_e','fad_p','fadh2_c','fc1p_c','fdp_c','fe2_c','fe2_e','fe2_p','fe3_c','fe3_e','fe3_p','fe3dcit_e','fe3dcit_p','fe3dhbzs3_c','feenter_c','feenter_e','feenter_p','fgam_c','flxr_c','flxso_c','fmn_c','fmn_e','fmn_p','fmnh2_c','for_c','for_e','for_p','fpram_c','fprica_c','frdp_c','fru_c','frulysp_c','fum_c','fum_e','fum_p','g1p_c','g3p_c','g3pe_c','g3pe_e','g3pe_p','g3pg_c','g3pg_e','g3pg_p','g6p_c','gagicolipa_c','gal1p_c','gal_c','gam1p_c','gam6p_c','gar_c','gcald_c','gdp_c','gdpddman_c','gdpfuc_c','gdpmann_c','gdpofuc_c','gdptp_c','gg4abut_c','ggagicolipa_c','ggbutal_c','gggagicolipa_c','ggptrc_c','ghb_c','gicolipa_c','glc__D_c','glc__D_e','glc__D_p','glcn_c','glcn_e','glcn_p','gln__L_c','glu1sa_c','glu5p_c','glu5sa_c','glu__D_c','glu__L_c','glu__L_e','glu__L_p','glucys_c','glutrna_c','glx_c','gly_c','gly_e','gly_p','glyald_c','glyald_e','glyald_p','glyc3p_c','glyc3p_e','glyc3p_p','glyc__R_c','glyc__R_e','glyc__R_p','glyc_c','glyc_e','glyc_p','glyclt_c','glyclt_e','glyclt_p','glycogen_c','gmeACP_c','gmhep17bp_c','gmhep1p_c','gmhep7p_c','gmp_c','grdp_c','gslnt_c','gsn_c','gsn_e','gsn_p','gthox_c','gthrd_c','gthrd_e','gthrd_p','gtp_c','gtspmd_c','gua_c','gua_e','gua_p','h2_c','h2_e','h2_p','h2mb4p_c','h2o2_c','h2o_c','h2o_e','h2o_p','h2s_c','h2s_e','h2s_p','h_c','h_e','h_p','hco3_c','hcys__L_c','hdca_c','hdca_p','hdcap_c','hdcea_c','hdcea_p','hdceap_c','hdcoa_c','hdd2coa_c','hdeACP_c','hemeO_c','hexACP_c','hgmeACP_c','hhlipa_c','his__L_c','his__L_e','his__L_p','hisp_c','histd_c','hlipa_c','hmbil_c','hom__L_c','hom__L_e','hom__L_p','hphhlipa_c','hpmeACP_c','hpyr_c','hx2coa_c','hxa_c','hxa_e','hxa_p','hxan_c','hxan_e','hxan_p','hxcoa_c','iasp_c','ichor_c','icit_c','icolipa_c','idon__L_c','idon__L_e','idon__L_p','idp_c','ile__L_c','ile__L_e','ile__L_p','imacp_c','imp_c','indole_c','indole_e','indole_p','ins_c','ins_e','ins_p','ipdp_c','itp_c','k_c','k_e','k_p','kdo2lipid4L_c','kdo2lipid4_c','kdo2lipid4_e','kdo2lipid4_p','kdo2lipid4p_c','kdo8p_c','kdo_c','kdolipid4_c','kphphhlipa_c','lac__D_c','lac__D_e','lac__D_p','lac__L_c','lac__L_e','lac__L_p','lald__D_c','lald__L_c','leu__L_c','leu__L_e','leu__L_p','lgt__S_c','lipa_c','lipa_cold_c','lipa_cold_e','lipa_cold_p','lipa_e','lipa_p','lipidA_c','lipidAds_c','lipidX_c','lipopb_c','lkdr_c','lys__L_c','lys__L_e','lys__L_p','malACP_c','mal__L_c','mal__L_e','mal__L_p','malcoa_c','malcoame_c','man1p_c','man6p_c','man_c','mdhdhf_c','meoh_c','meoh_e','meoh_p','mercppyr_c','met__L_c','met__L_e','met__L_p','methf_c','metsox_R__L_c','metsox_S__L_c','mg2_c','mg2_e','mg2_p','micit_c','mlthf_c','mmcoa__S_c','mn2_c','mn2_e','mn2_p','mnl1p_c','mobd_c','mobd_e','mobd_p','moco_c','mococdp_c','mocogdp_c','mql8_c','mqn8_c','msa_c','mthgxl_c','mththf_c','mththf_e','mththf_p','murein3p3p_p','murein3px3p_p','murein3px4p_p','murein4p3p_p','murein4p4p_p','murein4px4p4p_p','murein4px4p_p','murein4px4px4p_p','murein5p3p_p','murein5p4p_p','murein5p5p5p_p','murein5p5p_p','murein5px3p_p','murein5px4p_p','murein5px4px4p_p','myrsACP_c','n8aspmd_c','na15dap_c','na1_c','na1_e','na1_p','nac_c','nad_c','nadh_c','nadhx__R_c','nadhx__S_c','nadp_c','nadph_c','nadphx__R_c','nadphx__S_c','ncam_c','nh4_c','nh4_e','nh4_p','ni2_c','ni2_e','ni2_p','nicrnt_c','nmn_c','o2_c','o2_e','o2_p','o2s_c','oaa_c','oc2coa_c','ocACP_c','occoa_c','ocdcaACP_c','ocdca_c','ocdca_p','ocdcap_c','ocdcea_c','ocdcea_p','ocdceap_c','octa_c','octapb_c','octdp_c','octeACP_c','od2coa_c','odecoa_c','ogmeACP_c','ohpb_c','opmeACP_c','orn_c','orn_e','orn_p','orot5p_c','orot_c','oxam_c','oxur_c','pa120_c','pa120_p','pa140_c','pa140_p','pa141_c','pa141_p','pa160_c','pa160_p','pa161_c','pa161_p','pa180_c','pa180_p','pa181_c','pa181_p','palmACP_c','pan4p_c','pant__R_c','pap_c','paps_c','pdx5p_c','pe120_c','pe120_p','pe140_c','pe140_p','pe141_c','pe141_p','pe160_c','pe160_p','pe161_c','pe161_p','pe180_c','pe180_p','pe181_c','pe181_p','pep_c','pg120_c','pg120_p','pg140_c','pg140_p','pg141_c','pg141_p','pg160_c','pg160_p','pg161_c','pg161_p','pg180_c','pg180_p','pg181_c','pg181_p','pgp120_c','pgp120_p','pgp140_c','pgp140_p','pgp141_c','pgp141_p','pgp160_c','pgp160_p','pgp161_c','pgp161_p','pgp180_c','pgp180_p','pgp181_c','pgp181_p','phe__L_c','phe__L_e','phe__L_p','pheme_c','pheme_e','pheme_p','phhlipa_c','phom_c','phphhlipa_c','phpyr_c','phthr_c','pi_c','pi_e','pi_p','pimACP_c','pmeACP_c','pmtcoa_c','pnto__R_c','poaac_c','ppa_c','ppap_c','ppbng_c','ppcoa_c','ppgpp_c','pphn_c','ppi_c','ppp9_c','pppg9_c','pppi_c','pram_c','pran_c','prbamp_c','prbatp_c','preq0_c','preq1_c','prfp_c','prlp_c','pro__L_c','pro__L_e','pro__L_p','prpncoa_c','prpp_c','ps120_c','ps140_c','ps141_c','ps160_c','ps161_c','ps180_c','ps181_c','psd5p_c','pser__L_c','ptrc_c','ptrc_e','ptrc_p','puacgam_c','puacgam_p','pyam5p_c','pydam_c','pydx5p_c','pydx_c','pydxn_c','pyr_c','pyr_e','pyr_p','q8_c','q8h2_c','quln_c','r15bp_c','r1p_c','r2hglut_c','r5p_c','rbflvrd_c','rbl__D_c','rhcys_c','rhmn_c','rib__D_c','ribflv_c','ribflv_p','rml1p_c','ru5p__D_c','ru5p__L_c','s17bp_c','s7p_c','sbt6p_c','sbzcoa_c','scl_c','sel_c','sel_e','sel_p','seln_c','selnp_c','ser__D_c','ser__L_c','ser__L_e','ser__L_p','seramp_c','sheme_c','skm5p_c','skm_c','sl26da_c','sl2a6o_c','slnt_c','slnt_e','slnt_p','so3_c','so4_c','so4_e','so4_p','spmd_c','spmd_e','spmd_p','stcoa_c','sucarg_c','sucbz_c','succ_c','succ_e','succ_p','succoa_c','sucglu_c','sucgsa_c','suchms_c','sucorn_c','sucsal_c','sufbcd_2fe2s2_c','sufbcd_2fe2s_c','sufbcd_4fe4s_c','sufbcd_c','sufse_c','sufsesh_c','t3c11vaceACP_c','t3c5ddeceACP_c','t3c7mrseACP_c','t3c9palmeACP_c','tagdp__D_c','td2coa_c','tdcoa_c','tddec2eACP_c','tdeACP_c','tdec2eACP_c','tdecoa_c','thdp_c','thex2eACP_c','thf_c','thm_c','thmmp_c','thmnp_c','thmpp_c','thr__L_c','thr__L_e','thr__L_p','thym_c','thym_e','thym_p','thymd_c','thymd_e','thymd_p','tmrs2eACP_c','toct2eACP_c','toctd2eACP_c','tpalm2eACP_c','trdox_c','trdrd_c','tre6p_c','tre_c','trnaglu_c','trp__L_c','trp__L_e','trp__L_p','ttdca_c','ttdca_p','ttdcap_c','ttdcea_c','ttdcea_p','ttdceap_c','tungs_c','tungs_e','tungs_p','tyr__L_c','tyr__L_e','tyr__L_p','u23ga_c','u3aga_c','u3hga_c','uLa4fn_c','uLa4n_c','uLa4n_p','uaagmda_c','uaccg_c','uacgam_c','uacmam_c','uacmamu_c','uagmda_c','uama_c','uamag_c','uamr_c','udcpdp_c','udcpdp_p','udcpgl_c','udcpp_c','udcpp_p','udpLa4fn_c','udpLa4n_c','udpLa4o_c','udp_c','udpg_c','udpgal_c','udpgalfur_c','udpglcur_c','ugmd_c','ugmda_c','um4p_c','ump_c','unaga_c','unagamu_c','unagamuf_c','unagamuf_p','uppg3_c','ura_c','ura_e','ura_p','uracp_c','urate_c','urdgci_c','urdglyc_c','urea_c','urea_e','urea_p','uri_c','uri_e','uri_p','utp_c','val__L_c','val__L_e','val__L_p','xan_c','xan_e','xan_p','xdp_c','xmp_c','xtp_c','xtsn_c','xtsn_e','xtsn_p','xu5p__D_c','zn2_c','zn2_e','zn2_p']).


:- begin_tests(reaction_deletion).

% With same set of reaction deleted, phenotypic simulations would be the same.

% two alternatives share one subset and b3739 is the difference
%   knocking b3739 should not block the reaction

test(no_ko1) :-
    knocked_out_reactions([b3739],_,KnockedReactions),
    assertion(KnockedReactions==[]).


% two alternatives share one proper subset and b0684 is the difference
%   knocking b0684 should not block the reaction

test(no_ko2) :-
    knocked_out_reactions([b0684],_,KnockedReactions),
    assertion(KnockedReactions==[]).

% no alternative enz for 'ASNt2rpp'

test(single_ko1) :-
    knocked_out_reactions([b1453],_,KnockedReactions),
    assertion(KnockedReactions==['ASNt2rpp']).


% b0928 is responsible for two sets of reactions
%   but there is no alternative gene for 'CYSTA'

test(single_ko2) :-
    knocked_out_reactions([b0928],_,KnockedReactions),
    assertion(KnockedReactions==['CYSTA']).


% b3708 is responsible for two sets of reactions
%   but there is no alternative gene for  'TRPAS2'

test(single_ko3) :-
    knocked_out_reactions([b3708],_,KnockedReactions),
    assertion(KnockedReactions==['TRPAS2']).


% b0002 and b3940 are disjointly responsible for 'HSDy' and 'ASPK'
%   there is no alternative for 'HSDy'

test(multi_ko1) :-
    knocked_out_reactions([b0002,b3940],_,KnockedReactions),
    assertion(KnockedReactions==['HSDy']).


% b0002 and b3940 are jointly responsible for a set of reactions
%   there are no alternatives for these

test(multi_ko2) :-
    knocked_out_reactions([b0789,b1249],_,KnockedReactions),
    assertion(KnockedReactions==['CLPNS120pp','CLPNS140pp','CLPNS141pp','CLPNS160pp','CLPNS161pp','CLPNS180pp','CLPNS181pp']).


% b3551 and b3781 are jointly responsible for many reactions that have alternative genes
%   but b3551 is sole responsible for 'BSORx' and 'BSORy'

test(multi_ko3) :-
    knocked_out_reactions([b3551,b3781],_,KnockedReactions1),
    knocked_out_reactions([b3551],_,KnockedReactions2),
    assertion(KnockedReactions1==['BSORx','BSORy']),
    assertion(KnockedReactions1==KnockedReactions2).

% knockout all genes should affect non-transfer metabolic reactions

test(multi_ko4) :-
    findall(ORF,gene(ORF),ORFs),
    knocked_out_reactions(ORFs,_,KnockedReactions),
    length(KnockedReactions,L),
    % removed all but transfer reactions
    assertion(L==2221),
    findall(Rname,enzyme(_,[import],[Rname],_,_,_,_),ImportRnames),
    assertion(intersection(KnockedReactions,ImportRnames,[])).

:- end_tests(reaction_deletion).

:- begin_tests(knockout_single).

test(single_sim1) :-
    mutant_product(1,L),
    phenotypic_effect('',b3708,[ac_e],ProductBS),!,
    lm_btos(ProductBS,Products),
    assertion(is_set(Products,L)),
    assertion(reach_endbs(ProductBS)).

test(single_sim2) :-
    mutant_product(2,L),
    phenotypic_effect('',b1249,[acgam_e],ProductBS),!,
    lm_btos(ProductBS,Products),
    assertion(is_set(Products,L)),
    assertion(reach_endbs(ProductBS)).

:- end_tests(knockout_single).


:- begin_tests(knockout_batch).

% check the output correctness of single simulation
%   represented as a set input

test(multi_sim_one_cond) :-
    phenotypic_effects(
        '',
        [
            [b3708,[ac_e]]
        ],
        Itr,Labels
    ),
    mname(mstate,Itr,MFinal),
    call(MFinal,0,ProductBS1),
    lm_btos(ProductBS1,Products1),
    mutant_product(1,L1),
    assertion(is_set(Products1,L1)),
    assertion(Labels==[0]).


% check the output correctness of multiple simulations
%   represented as a set input

test(multi_sim_multi_conds1) :-
    phenotypic_effects(
        '',
        [
            [b3708,[ac_e]],
            [b1249,[acgam_e]]
        ],
        Itr,Labels
    ),
    mname(mstate,Itr,MFinal),
    call(MFinal,0,ProductBS1),
    call(MFinal,1,ProductBS2),
    lm_btos(ProductBS1,Products1),
    lm_btos(ProductBS2,Products2),
    mutant_product(1,L1),
    mutant_product(2,L2),
    assertion(is_set(Products1,L1)),
    assertion(is_set(Products2,L2)),
    assertion(Labels==[0,0]).


% check the output consistency of multiple simulations
%   represented as a set input

test(multi_sim_multi_conds2) :-
    phenotypic_effects(
        '',
        [
            [[b3708],[ac_e]],
            [[b1249],[acgam_e]],
            [[b0002],[pyr_e]],
            [[b0009],[acgam_e]],
            [[b0033],[mnl_e]],
            [[b0038],[succ_e]],
            [[b0047],[sbt__D_e]],
            [[b0054],[glc__D_e]],
            [[b0091],[ala__L_e]],
            [[b0142],[pyr_e]]
        ],
        _,Labels
    ),
    phenotypic_effects_bitset(
        '',
        [
            [[b3708],[ac_e]],
            [[b1249],[acgam_e]],
            [[b0002],[pyr_e]],
            [[b0009],[acgam_e]],
            [[b0033],[mnl_e]],
            [[b0038],[succ_e]],
            [[b0047],[sbt__D_e]],
            [[b0054],[glc__D_e]],
            [[b0091],[ala__L_e]],
            [[b0142],[pyr_e]]
        ],Bs
    ),
    assertion(Labels==[0,0,0,0,0,0,0,1,1,1]),
    reverse(Labels,Labels1),
    lm_ltob(Labels1,Bs1),
    assertion(Bs==Bs1).


% test if phenotypic_effects/2 gives the same result
%   when input ORFs are presented either terms or lists

test(multi_sim_multi_conds3) :-
    consult('library/single_knockout/16_carbon/iML1515_trials.pl'),
    getrand(R),
    setrand(R),
    findall([G,N],ex(_,phenotypic_effect(G,N)),Conds1),
    length(L1,100),
    random_permutation(Conds1,Conds2),
    append(L1,_,Conds2),!,
    setrand(R),
    findall([[G],N],ex(_,phenotypic_effect(G,N)),Conds3),
    length(L2,100),
    random_permutation(Conds3,Conds4),
    append(L2,_,Conds4),!,
    phenotypic_effects('',L1,BS1),
    phenotypic_effects('',L2,BS2),
    assertion(BS1==BS2),
    unload_file('library/single_knockout/16_carbon/iML1515_trials.pl').

% overlapping function between b3856 and b4244
%   single ko any one should not have an effect

test(multi_sim_multi_conds4) :-
    phenotypic_effects(
        '',
        [
            [b3856,[]],
            [b3856,[ac_e]],
            [b3856,[acgam_e]],
            [b3856,[akg_e]],
            [b3856,[ala__L_e]],
            [b3856,[gal_e]],
            [b3856,[glc__D_e]],
            [b3856,[glcn_e]],
            [b3856,[glyc_e]],
            [b3856,[lac__L_e]],
            [b3856,[malt_e]],
            [b3856,[mnl_e]],
            [b3856,[pyr_e]],
            [b3856,[rib__D_e]],
            [b3856,[sbt__D_e]],
            [b3856,[succ_e]],
            [b3856,[xyl__D_e]],
            [b4244,[]],
            [b4244,[ac_e]],
            [b4244,[acgam_e]],
            [b4244,[akg_e]],
            [b4244,[ala__L_e]],
            [b4244,[gal_e]],
            [b4244,[glc__D_e]],
            [b4244,[glcn_e]],
            [b4244,[glyc_e]],
            [b4244,[lac__L_e]],
            [b4244,[malt_e]],
            [b4244,[mnl_e]],
            [b4244,[pyr_e]],
            [b4244,[rib__D_e]],
            [b4244,[sbt__D_e]],
            [b4244,[succ_e]],
            [b4244,[xyl__D_e]]
        ],
        _,Labels
    ),
    assertion(Labels==
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]).

:- end_tests(knockout_batch).

:- begin_tests(double_knockout).

test(double_knockout_against_fba1) :-
    phenotypic_effects(
        '',
        [
            [[b1190,b4053],[]],
            [[b0273,b4254],[]],
            [[b0388,b3390],[]],
            [[b0928,b4054],[]],
            [[b0126,b0339],[]],
            [[b2414,b2421],[]],
            [[b0092,b0381],[]],
            [[b0048,b1606],[]],
            [[b0078,b3671],[]],
            [[b0077,b3671],[]],
            [[b0078,b3670],[]],
            [[b0077,b3670],[]],
            [[b2708,b3197],[]],
            [[b3829,b4019],[]],
            [[b0002,b3940],[]],
            [[b1096,b4039],[]],
            [[b0844,b3812],[]]
        ],Labels
    ),
    assertion(Labels==[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]).

test(double_knockout_against_fba2) :-
        phenotypic_effects(
        '',
        [
            [[b3551,b3781],[]],
            [[b2582,b3551],[]],
            [[b0789,b1249],[]],
            [[b3781,b4219],[]],
            [[b2582,b4219],[]],
            [[b1778,b3781],[]],
            [[b1778,b2582],[]],
            [[b1832,b3781],[]],
            [[b1832,b2582],[]],
            [[b2039,b3789],[]],
            [[b2041,b3788],[]],
            [[b2582,b3781],[]]
        ],Labels
    ),
    assertion(Labels==[0,0,1,0,0,0,0,0,0,1,1,1]).

:- end_tests(double_knockout).