" ==============================================================================
" EPX syntax file
" Language:        EPX
" Original Author: Thomas Douillet-Grellier <thomas.douillet-grellier@edf.fr>
" Maintainer:      tdg <https://github.com/thomasdouilletgrellier>
" Website:         N/A 
" Last Change:     Jun 8, 2024 
"
" ==============================================================================

" Regular int like number with - + or nothing in front
syn match epxNumber '\d\+' 
syn match epxNumber '[-+]\d\+' 

" Floating point number with decimal no E or e (+,-)
syn match epxNumber '\d\+\.\d*' 
syn match epxNumber '[-+]\d\+\.\d*' 

" Floating point like number with E and no decimal point (+,-)
syn match epxNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+' 
syn match epxNumber '\d[[:digit:]]*[eE][\-+]\=\d\+' 

" Floating point like number with E and decimal point (+,-)
syn match epxNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' 
syn match epxNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' 

" All words
syn match epxWord '[A-Z_][0-9A-Z_]\+' 
syn match epxWord '[a-z_][0-9a-z_]\+' 

" Europlexus keywords
syn match epxKeywords0 '\<\(ABAQ\|ADAP\|CALC\|CFIN\|CHAR\|CHCK\|COLL\|COMP\|COUP\|loi\|LOI\|DIAM\|DISQ\|ECHO\|ECRI\|EDEF\|EDIT\|ENDP\|EPAI\|RACC\|FESE\|FIN\|FONC\|FSS\|GEOM\|GEOP\|GLIS\|GRIL\|HORL\|IMPR\|INCL\|INIT\|INJE\|INTE\|LIAI\|LINK\|LOAD\|MASS\|MATE\|MEAS\|MORT\|MPEF\|NOEC\|OPTI\|PLAY\|PROF\|QUAL\|REGI\|REMA\|RETU\|ROBO\|RSOU\|SECT\|SORT\|SPHY\|STRU\|SUIT\|TYPL\|VALI\|VISU\|CLVF\|TEAU\|WAVE\|XFEM\)[a-zA-Z]*\>'
syn match epxKeywords '\<\(ABSE\|ABSI\|ABSO\|ABST\|ABSZ\|ACBE\|MOD\|KSI\|TAU\|RAP\|ACCE\|ALE\|VITI\|FCT\|ACIE\|ACMN\|ACMX\|ACOS\|ADAD\|ADC8\|ADCJ\|ADCR\|ADDC\|ADDF\|ADFM\|ADFT\|ADHE\|ADNP\|ADOU\|ADQ4\|ADTI\|ADUN\|AFLX\|AFLY\|AHGF\|AINI\|AIRB\|AIRE\|AJOU\|ALES\|ALF0\|ALF1\|ALF2\|ALFA\|ALFN\|ALIC\|ALIT\|ALLF\|ALP1\|ALP2\|ALPH\|ALPHA\|AMAX\|AMBI\|AMMB\|AMOR\|AMOY\|VOLU\|UNIL\|AMPD\|AMPF\|AMPL\|AMPV\|ANCI\|ANG1\|ANG2\|ANGL\|ANTI\|APEX\|APPL\|APPU\|APRS\|ARLQ\|ARMA\|ARRE\|ARTI\|ASHB\|ASIN\|ASIS\|ASPE\|ASSE\|ATRA\|ATRS\|ATUB\|AUTO\|AUTR\|AVER\|AXE1\|AXE2\|AXES\|AXIA\|AXIS\|AXOL\|AXTE\|BACO\|BAKE\|BAND\|BARR\|BARY\|BASE\|BBOX\|BDFO\|BENS\|BET0\|BETA\|BETC\|BETO\|BETON\|BFIX\|BFLU\|BGLA\|BGRN\|BHAN\|BIFU\|BILA\|BILL\|BIMA\|BINA\|BIVF\|BL3S\|BLAC\|BLAN\|BLAP\|BLAR\|BLEU\|BLKO\|BLMT\|BLOQ\|BLR2\|BLUE\|BMPI\|BODY\|BOIS\|BOTH\|BPEL\|BPOV\|BR3D\|BRAS\|BREC\|BRON\|BSHR\|BSHT\|BUBB\|BULK\|BUTE\|BWDT\|C\|C272\|C273\|C81L\|C82L\|CABL\|CAM1\|CAM2\|CAMC\|CAME\|CAPA\|CAR1\|CAR4\|CARB\|CART\|CASE\|CAST\|CAVF\|CAVI\|CBIL\|CBOX\|CDEM\|CDEP\|CDES\|CDNO\|CEAU\|CECH\|CELD\|CELP\|CEND\|CENE\|CENT\|CERO\|CERR\|CESC\|CEXP\|CFLA\|CFON\|CFVN\|CGAZ\|CGLA\|CHA1\|CHA2\|CHAI\|CHAM\|CHAN\|CHEC\|CHOC\|CHOL\|CHRO\|CHSP\|CI12\|CI23\|CI31\|CIBD\|CIBL\|CINI\|CIRC\|CKAP\|CL1D\|CL22\|CL23\|CL2D\|CL32\|CL33\|CL3D\|CL3I\|CL3Q\|CL3T\|CL92\|CL93\|CLAM\|CLAS\|CLAY\|CLB1\|CLB2\|CLB3\|CLB4\|CLD3\|CLD6\|CLEN\|CLIM\|CLMT\|CLTU\|CLX1\|CLX2\|CLXS\|CLY1\|CLY2\|CLZ1\|CLZ2\|CMAI\|CMC3\|CMDF\|CMID\|CMIN\|CMPX\|CMPY\|CMPZ\|CNOD\|CNOR\|COA1\|COA2\|COA3\|COA4\|COCY\|CODG\|COEA\|COEB\|COEF\|COEN\|COE_1\|COE_2\|COE_3\|COH2\|COHE\|COLO\|COLS\|COMM\|COMP1\|CON2\|COND\|CONE\|CONF\|CONS\|CONT\|CONV\|COO2\|COOH\|COOR\|COPP\|COPT\|COPY\|COQ3\|COQ4\|COQC\|COQI\|COQM\|COQU\|CORR\|CORT\|COSC\|COTE\|COUC\|COUR\|COXA\|COXB\|COYA\|COYB\|COZA\|COZB\|CPLA\|CPOI\|CPUT\|CQD3\|CQD4\|CQD6\|CQD9\|CQDF\|CQDX\|CQST\|CQUA\|CR2D\|CRAK\|CREA\|CRGR\|CRIT\|CROI\|CROS\|CRTM\|CSHE\|CSN1\|CSN2\|CSNA\|CSON\|CSPB\|CSPH\|CSTA\|CSTE\|CSTR\|CTIM\|CUB6\|CUB8\|CUBB\|CUBE\|CULL\|CURR\|CURV\|CUVF\|CUVL\|CVEL\|CVL1\|CVME\|CVT1\|CVT2\|CYAN\|CYAP\|CYAR\|CYLI\|DACT\|DADC\|DAMA\|DASH\|DASN\|DBLE\|DBTE\|DC12\|DC13\|DC23\|DCEN\|DCMA\|DCMS\|DCOU\|DCRI\|DEBI\|DEBR\|DEBU\|DEBX\|DEBY\|DEBZ\|DECE\|DECO\|DECX\|DECY\|DEFA\|DEFI\|DEFO\|DEGP\|DELE\|DELF\|DELT\|DEMS\|DENS\|DEPL\|DEPO\|DERF\|DESC\|DETA\|DEXT\|DGRI\|DHAN\|DHAR\|DHAS\|DHRO\|DHTE\|DIAG\|DIAP\|DIFF\|DIME\|DIMN\|DIMX\|DIRE\|DIRF\|DIRX\|DIRY\|DIRZ\|DISP\|DIST\|DIVC\|DIVG\|DKT3\|DLEN\|DMAS\|DMAX\|DMIN\|DMME\|DMMN\|DMOY\|DOMA\|DOMD\|DONE\|DPAR\|DPAS\|DPAX\|DPCA\|DPDC\|DPEL\|DPEM\|DPGR\|DPHY\|DPIN\|DPLA\|DPLE\|DPLG\|DPLM\|DPLS\|DPMA\|DPMI\|DPRE\|DPROP\|DPRU\|DPRV\|DPSD\|DPSF\|DRAG\|DRIT\|DROI\|DRPR\|DRST\|DRUC\|DRXC\|DRXN\|DRYC\|DRYN\|DRZC\|DRZN\|DSAT\|DSOR\|DST3\|DTBE\|DTCR\|DTDR\|DTEL\|DTFI\|DTFO\|DTFX\|DTMA\|DTMI\|DTML\|DTMX\|DTNO\|DTPB\|DTST\|DTUB\|DTUN\|DTVA\|DTXC\|DTXN\|DTYC\|DTYN\|DTZC\|DTZN\|DUMP\|DYMS\|DYNA\|EACT\|EAFT\|EAU\|ECIN\|ECLI\|ECOQ\|ECOU\|ECRC\|ECRG\|ECRM\|ECRN\|ECRO\|ED01\|ED1D\|ED41\|EDCV\|EDSS\|ED_1\|ED_2\|ED_3\|EEXT\|EGAL\|EIBU\|EINJ\|EINT\|ELAS\|ELAT\|ELCE\|ELCR\|ELDI\|ELEC\|ELEM\|ELGR\|ELIM\|ELMX\|ELOU\|ELSN\|ELST\|EMAS\|EMAX\|EMER\|EMIN\|ENDA\|ENDD\|ENDO\|ENEL\|ENER\|ENGR\|ENMA\|ENTH\|ENUM\|EOBT\|EP12\|EP13\|EP23\|EP31\|EPCD\|EPCS\|EPDV\|EPS1\|EPS2\|EPS3\|EPS4\|EPSB\|EPSD\|EPSI\|EPSL\|EPSM\|EPST\|EPSY\|EPT1\|EPT2\|EPT3\|EPTR\|EQUI\|EQVD\|EQVF\|EQVL\|EROD\|EROS\|ERRI\|ERRO\|ERUP\|ESCL\|ESET\|ESLA\|ESUB\|ETLE\|EULE\|EVAL\|EXCE\|EXCL\|EXPA\|EXPC\|EXPF\|EXTE\|EXTZ\|EXVL\|FAC4\|FACE\|FACI\|FACT\|FACX\|FACY\|FACZ\|FADE\|FAIL\|FANF\|FANT\|FARF\|FAST\|FCON\|FCTE\|FCUT\|FDEC\|FDYN\|FELE\|FENE\|FERR\|FEXT\|FFMT\|FFRD\|FICH\|FIEL\|FILE\|FILI\|FILL\|FILT\|FIMP\|FINI\|FINT\|FIRS\|FIXE\|FL23\|FL24\|FL34\|FL35\|FL36\|FL38\|FLFA\|FLIA\|FLIR\|FLMP\|FLSR\|FLSS\|FLST\|FLSW\|FLSX\|FLU1\|FLU3\|FLUI\|FLUT\|FLUX\|FLVA\|FNOD\|FNOR\|FNUM\|FOAM\|FOCO\|FOLD\|FOLL\|FOND\|FORC\|FORM\|FOUR\|FPLT\|FRAC\|FRAM\|FRCO\|FRED\|FREE\|FREQ\|FRIC\|FRLI\|FROM\|FRON\|FROT\|FRQR\|FS2D\|FS3D\|FS3T\|FSCP\|FSCR\|FSIN\|FSMT\|FSRD\|FSSA\|FSSF\|FSSL\|FSTG\|FSUI\|FTAN\|FTOT\|FTRA\|FUN2\|FUN3\|FUNE\|FVAL\|FVIT\|GAH2\|GAM0\|GAM1\|GAMA\|GAMG\|GAMM\|GAMZ\|GAN2\|GAO2\|GAOH\|GARD\|GAUS\|GAUZ\|GAZD\|GAZP\|GBIL\|GEAU\|GENE\|GENM\|GGAS\|GGLA\|GHOS\|GIBI\|GINF\|GIUL\|GLAS\|GLIN\|GLOB\|GLRC\|GLUE\|GMIC\|GOL2\|GOLD\|GOTR\|GPCG\|GPDI\|GPIN\|GPLA\|GPNS\|GR05\|GR10\|GR15\|GR20\|GR25\|GR30\|GR35\|GR40\|GR45\|GR50\|GR55\|GR60\|GR65\|GR70\|GR75\|GR80\|GR85\|GR90\|GR95\|GRAD\|GRAP\|GRAV\|GRAY\|GREE\|GREP\|GRER\|GRFS\|GRID\|GROU\|GRPS\|GUID\|GVDW\|GZPV\|HANG\|HARD\|HARM\|HBIS\|HELI\|HEMI\|HEOU\|HEXA\|HFAC\|HFRO\|HGQ4\|HGRI\|HIDE\|HIGH\|HILL\|HINF\|HIST\|HOLE\|HOMO\|HOUR\|HPIN\|HYDR\|HYPE\|ICLI\|ICOL\|IDAM\|IDEA\|IDEN\|IDOF\|IEXT\|IFAC\|IFIS\|IFSA\|IGRA\|IGT1\|IGT2\|ILEN\|ILNO\|IMAT\|IMAX\|IMES\|IMIN\|IMPA\|IMPE\|IMPO\|IMPU\|IMPV\|IMT1\|IMT2\|INCLUDE\|INCR\|INDE\|INDI\|INER\|INFI\|INFO\|INIS\|INJI\|INJM\|INJQ\|INJV\|INOU\|INSI\|INST\|INT4\|INT6\|INT8\|INTR\|INTS\|INVE\|INWI\|IPA1\|IPA2\|IRD1\|IRD2\|IRES\|ISCA\|ISOD\|ISOE\|ISOL\|ISOT\|ISPR\|ITEP\|ITER\|ITOT\|JADE\|JAUM\|JAUN\|JCLM\|JEU1\|JEU2\|JEUX\|JOCO\|JOIN\|JONC\|JPRP\|JWLS\|K200\|K2CH\|K2FB\|K2GP\|K2MS\|KBAR\|KENE\|KFIL\|KFON\|KFR1\|KFR2\|KFRE\|KINT\|KMAS\|KOIL\|KPER\|KQDM\|KRAY\|KRXC\|KRXN\|KRYC\|KRYN\|KRZC\|KRZN\|KSI0\|KTUB\|KTXC\|KTXN\|KTYC\|KTYN\|KTZC\|KTZN\|LAGC\|LAGR\|LALP\|LAMB\|LAPI\|LAST\|LATE\|LAYE\|LBIC\|LBMD\|LBMS\|LBNS\|LBPW\|LBST\|LCAB\|LCAM\|LCHP\|LCOF\|LCOU\|LDIF\|LECD\|LECT\|LECT\|LEES\|LEM1\|LENE\|LENG\|LENM\|LENP\|LEVE\|LFEL\|LFEV\|LFNO\|LFNV\|LFUN\|LIAJ\|LIBR\|LIGN\|LIGR\|LIGX\|LIGY\|LIGZ\|LIMA\|LIMI\|LINE\|LIQU\|LIST\|LLAG\|LMAM\|LMAS\|LMAX\|LMC2\|LMIN\|LMST\|LNKS\|LNOD\|LOCA\|LOD1\|LOG10\|LONG\|LONP\|LOOP\|LOOS\|LORD\|LPRE\|LQDM\|LSGL\|LSHI\|LSLE\|LSPC\|LSPE\|LSQU\|LUNG\|LVEL\|MACR\|MAGE\|MAIL\|MAIT\|MANU\|MAP2\|MAP3\|MAP4\|MAP5\|MAP6\|MAP7\|MAPB\|MAPP\|MAS2\|MASE\|MASL\|MASN\|MAST\|MAT1\|MAT2\|MAVI\|MAXC\|MAXL\|MAZA\|MBAC\|MBET\|MC23\|MC24\|MC34\|MC35\|MC36\|MC38\|MCCS\|MCEF\|MCFF\|MCFL\|MCGP\|MCMA\|MCMF\|MCMU\|MCOM\|MCOU\|MCP1\|MCP2\|MCPR\|MCRO\|MCTE\|MCUX\|MCUY\|MCUZ\|MCVA\|MCVC\|MCVE\|MCVI\|MCVM\|MCVS\|MCXX\|ME1D\|MEAN\|MEAU\|MEC1\|MEC2\|MEC3\|MEC4\|MEC5\|MECA\|MEDE\|MEDI\|MEDL\|MEMB\|MEMO\|MEMP\|MENS\|MESH\|META\|MFAC\|MFRA\|MFRO\|MFSR\|MGT1\|MGT2\|MHOM\|MIDP\|MIEG\|MINM\|MINT\|MLEV\|MLVL\|MMOL\|MMT1\|MMT2\|MNTI\|MOCC\|MODA\|MODE\|MODI\|MODU\|MOH2\|MOME\|MOMT\|MON2\|MOO2\|MOOH\|MOON\|MOPR\|MOVE\|MOY4\|MOY5\|MOYG\|MQUA\|MRAY\|MRD1\|MRD2\|MS24\|MS38\|MTOT\|MTRC\|MTTI\|MTUB\|MUDY\|MULC\|MULT\|MUST\|MVRE\|MXIT\|MXLI\|MXSU\|MXTF\|MXTP\|NACT\|NAH2\|NALE\|NASN\|NAVI\|NAVS\|NBCO\|NBJE\|NBLE\|NBTU\|NBUL\|NCFS\|NCOL\|NCOM\|NCOT\|NCOU\|NCT1\|NCT2\|NDDL\|NEAR\|NEIG\|NELE\|NEND\|NEPE\|NEQV\|NERO\|NESP\|NF34\|NFAI\|NFAL\|NFAR\|NFAS\|NFAT\|NFD1\|NFD2\|NFIX\|NFKL\|NFKR\|NFKS\|NFKT\|NFKX\|NFKY\|NFKZ\|NFRA\|NFRO\|NFSC\|NFSL\|NFTO\|NGAS\|NGAU\|NGPZ\|NGRO\|NIMA\|NIND\|NISC\|NITE\|NLHS\|NLIN\|NLIQ\|NLIT\|NMAX\|NNUM\|NOBE\|NOCL\|NOCO\|NOCR\|NOCU\|NODE\|NODF\|NODP\|NODS\|NODU\|NOE1\|NOE2\|NOEL\|NOER\|NOEU\|NOEX\|NOFO\|NOGR\|NOHO\|NOHP\|NOIR\|NOIS\|NOLI\|NOMU\|NONA\|NONE\|NONP\|NONU\|NOOB\|NOPA\|NOPO\|NOPP\|NOPR\|NORB\|NORE\|NORM\|NOSY\|NOTE\|NOUN\|NOUT\|NOUV\|NOXL\|NOYL\|NPAS\|NPEF\|NPFR\|NPIN\|NPOI\|NPSF\|NPTM\|NPTO\|NPTS\|NRAR\|NSET\|NSPE\|NSPL\|NSPT\|NSTE\|NSTO\|NTHR\|NTIL\|NTLE\|NTRA\|NTUB\|NU\|NU12\|NU13\|NU23\|NUFA\|NUFB\|NUFL\|NUFO\|NULT\|NUME\|NUPA\|NUSE\|NUSN\|NUSP\|NUST\|NVFI\|NVMX\|NVSC\|NWAL\|NWAT\|NWK2\|NWSA\|NWST\|NWTP\|NWXP\|OBJE\|OBJN\|OBSI\|OBSO\|ODMS\|OEIL\|OF34\|OFFS\|OGDE\|OLDS\|OMEG\|OMEM\|ONAM\|OPNF\|OPOS\|ORDB\|ORDP\|ORDR\|ORIE\|ORIG\|ORSR\|ORTE\|ORTH\|ORTS\|OTPS\|OUTL\|OUTS\|OUV1\|OUV2\|OUV3\|P2X2\|PACK\|PAIR\|PAPE\|PARA\|PARD\|PARE\|PARF\|PARG\|PARO\|PART\|PAS\|PAS0\|PAS1\|PASF\|PASM\|PASN\|PATH\|PAXI\|PBAS\|PBRO\|PCAL\|PCAS\|PCHA\|PCLD\|PCOM\|PCON\|PCOP\|PCOU\|PDIS\|PDOT\|PEAR\|PELE\|PELM\|PEMA\|PENA\|PENE\|PENT\|PEPR\|PEPS\|PERF\|PERK\|PERP\|PERR\|PESC\|PEWT\|PEXT\|PFCT\|PFEM\|PFIN\|PFMA\|PFMI\|PFSI\|PGAP\|PGAZ\|PGOL\|PGRI\|PHAN\|PHIC\|PHID\|PHII\|PHIR\|PHIS\|PIGL\|PIGM\|PIMP\|PINB\|PINC\|PINI\|PINS\|PITE\|PIVO\|PKAP\|PLAM\|PLAN\|PLAT\|PLAW\|PLEV\|PLIE\|PLIN\|PLIQ\|PLOA\|PLOG\|PMAT\|PMAX\|PMED\|PMES\|PMET\|PMIN\|PMOL\|PMS1\|PMS2\|PMTV\|PNOL\|POCH\|POI1\|POI2\|POIN\|POLA\|POMP\|PONC\|POPE\|PORE\|PORO\|POSI\|POST\|POUT\|POVR\|PPLT\|PPMA\|PRAD\|PRAY\|PREF\|PRES\|PRGL\|PRGR\|PRIN\|PRIS\|PROB\|PROD\|PROG\|PROJ\|PROT\|PRUP\|PRVF\|PRVL\|PSAR\|PSAT\|PSCR\|PSIL\|PSYS\|PT1D\|PTOT\|PTRI\|PTSL\|PUFF\|PVTK\|PWD0\|PYRA\|PYRO\|PYVF\|PZER\|Q41L\|Q41N\|Q42G\|Q42L\|Q42N\|Q4G4\|Q4GR\|Q4GS\|Q4MC\|Q4VF\|Q92A\|QGEN\|QMAX\|QMOM\|QMUR\|QPPS\|QPRI\|QTAB\|QUAD\|QUAS\|QUEL\|RADB\|RADI\|RAND\|RANG\|RAYC\|RAYO\|RBIL\|RCEL\|RCON\|RCOU\|RDK2\|RDMC\|READ\|REB1\|REB2\|RECO\|RECT\|REDP\|REDR\|REDU\|REEN\|REFE\|RELA\|RENA\|REND\|RENU\|REPR\|RESE\|RESG\|RESI\|RESL\|RESS\|REST\|RESU\|RETI\|RETO\|RETURN\|REUS\|REWR\|REZO\|RGAS\|RHO\|RIEM\|RIGH\|RIGI\|RIIL\|RIIS\|RISK\|RL3D\|RLIM\|RMAC\|RMAS\|RMAX\|RMIN\|RNUM\|RO\|ROAR\|ROBU\|ROBZ\|ROEX\|ROGA\|ROIL\|ROIN\|ROLI\|RONA\|ROSA\|ROSE\|ROTA\|ROTU\|ROUG\|ROUT\|RO_0\|RO_F\|RPAR\|RPOV\|RREF\|RRIS\|RSEA\|RST1\|RST2\|RST3\|RTMANGL\|RTMRCT\|RTMVF\|RUBY\|RUDI\|RUGO\|RUPT\|RVAL\|RVIT\|RXDR\|RZIP\|SAFE\|SAND\|SAUV\|SAVE\|SAXE\|SBAC\|SBEA\|SBOU\|SCAL\|SCAS\|SCAV\|SCCO\|SCEN\|SCLM\|SCOU\|SCRN\|SDFA\|SEGM\|SEGN\|SELE\|SELF\|SELG\|SELM\|SELO\|SELP\|SELV\|SFAC\|SFRE\|SG2P\|SGBC\|SGEO\|SGMP\|SH3D\|SH3V\|SHAR\|SHB8\|SHEA\|SHEL\|SHFT\|SHIF\|SHIFT\|SHIN\|SHIX\|SHIY\|SHIZ\|SHOW\|SHRI\|SHTU\|SIGD\|SIGE\|SIGL\|SIGN\|SIGP\|SIGS\|SILV\|SIMP\|SINT\|SIOU\|SISM\|SISO\|SIVE\|SIZE\|SKEW\|SKIP\|SLAV\|SLER\|SLEV\|SLIN\|SLIP\|SLPC\|SLPN\|SLZA\|SMAL\|SMAX\|SMAZ\|SMEL\|SMIN\|SMLI\|SMOO\|SMOU\|SNOD\|SNOR\|SO12\|SO13\|SO23\|SOL2\|SOLI\|SOLU\|SOLV\|SOMM\|SORD\|SOUR\|SPCO\|SPEC\|SPEF\|SPER\|SPHC\|SPHE\|SPHP\|SPLA\|SPLI\|SPLIB\|SPLINE\|SPLT\|SPRE\|SPTA\|SQRT\|SRRF\|SSHA\|SSHE\|SSOL\|STAB\|STAC\|STAD\|STAK\|STAT\|STEC\|STEL\|STEP\|STFL\|STGN\|STIF\|STOP\|STRA\|STRP\|STTR\|STUB\|STWA\|SUBC\|SUIV\|SULI\|SUPP\|SURF\|SVAL\|SVIT\|SWVA\|SYMB\|SYME\|SYMO\|SYMX\|SYMY\|SYNC\|SYSC\|SYXY\|SYXZ\|SYYZ\|SY_1\|SY_2\|SY_3\|T12M\|T23M\|T31M\|T3GS\|T3MC\|T3VF\|TABL\|TABO\|TABP\|TABT\|TACH\|TACT\|TAIT\|TAPE\|TARR\|TAU1\|TAU2\|TAU3\|TAU4\|TAU5\|TAU6\|TAUC\|TAUL\|TAUT\|TAUX\|TBLO\|TCLO\|TCOR\|TCPU\|TDEA\|TDEL\|TDET\|TEKT\|TEMP\|TEND\|TERM\|TERM\|TEST\|TETA\|TETR\|TEVF\|TEXT\|TFAI\|TFER\|TFIN\|TFRE\|TGGR\|TGRA\|TH2O\|THEL\|THETA\|THIC\|THRS\|TIME\|TIMP\|TINI\|TINT\|TION\|TIT1\|TIT2\|TIT3\|TITL\|TITR\|TMAX\|TMEN\|TMIN\|TMUR\|TNOD\|TNSN\|TO12\|TO13\|TO23\|TOIL\|TOLC\|TOLE\|TOLS\|TOPE\|TORE\|TOTA\|TOUS\|TOUT\|TPAR\|TPLO\|TPOI\|TR1M\|TR2M\|TR3M\|TRAA\|TRAC\|TRAJ\|TRAN\|TRCO\|TREF\|TRIA\|TRID\|TRIG\|TRUP\|TR_1\|TR_2\|TR_3\|TSEU\|TSTA\|TTHI\|TUBE\|TUBM\|TULE\|TULT\|TURB\|TURQ\|TUVF\|TUYA\|TUYM\|TVAL\|TVL1\|TVMC\|TXTR\|TYPE\|TYVF\|UCDS\|UNIM\|UNIV\|UPDR\|UPDT\|UPTO\|UPWM\|UPWS\|USER\|USLG\|USLM\|USLP\|USPL\|UTIL\|UZIP\|V1LC\|V2LC\|VANL\|VANN\|VARI\|VAXE\|VCON\|VCOR\|VCVI\|VECT\|VEL1\|VEL2\|VEL3\|VELO\|VEMN\|VEMX\|VERI\|VERR\|VERT\|VFAC\|VFCC\|VFLU\|VHAR\|VIAR\|VIBU\|VIDA\|VIDE\|VIEW\|VILI\|VINA\|VINF\|VIS1\|VIS2\|VIS3\|VIS4\|VIS5\|VIS6\|VISC\|VISL\|VISO\|VISV\|VITC\|VITE\|VITG\|VITP\|VITX\|VITY\|VITZ\|VLIN\|VM1D\|VM23\|VMAX\|VMIS\|VMJC\|VMLP\|VMLU\|VMOY\|VMPR\|VMSF\|VMZA\|VNOR\|VOFI\|VOIS\|VPJC\|VPLA\|VRIG\|VRUP\|VSCA\|VSWP\|VTG1\|VTG2\|VTIM\|VTRA\|VXFF\|VYFF\|VZFF\|WALI\|WARD\|WARP\|WATP\|WAUX\|WCIN\|WECH\|WEXT\|WFIL\|WHAN\|WHIP\|WHIR\|WHIT\|WIMP\|WINJ\|WINT\|WIRE\|WK20\|WSAU\|WSTB\|WSUM\|WSYS\|WTOT\|WTPL\|WXDR\|WXPL\|XAXE\|XCAR\|XCOR\|XCUB\|XDET\|XGRD\|XINF\|XLOG\|XLVL\|XMAX\|XMGR\|XMIN\|XPLO\|XZER\|YDET\|YELL\|YELP\|YELR\|YETP\|YGRD\|YLOG\|YMAS\|YMAX\|YMIN\|YOUN\|YSTA\|YZER\|ZAC0\|ZAC1\|ZAC2\|ZAC3\|ZAC4\|ZALM\|ZDET\|ZERO\|ZETA\|ZMAX\|ZMIN\|ZONE\|ZOOM\)[a-zA-Z]*\>'
syn match epxKeywords '\<\(ERROR\|ATTENTION\|HAS FAILED\|WARNING\|ALERT\|UNKNOWN\|NOT FOUND\|MISSING\|UNAVAILABLE\|NO CONVERGENCE\|IMPOSSIBLE\|NOT POSSIBLE\|NAN\)\>'
syn match epxKeywords '\<\(OK\|SUCCESSFUL\|SUCCESS\|FINISHED\|END OF INITIALIZATIONS\|NORMAL END\|THE FINAL TIME IS REACHED\)\>'
syn match epxKeywords0 '\<\(abaq\|adap\|calc\|cfin\|char\|chck\|coll\|comp\|coup\|loi\|loi\|diam\|disq\|echo\|ecri\|edef\|edit\|endp\|epai\|racc\|fese\|fin\|fonc\|fss\|geom\|geop\|glis\|gril\|horl\|impr\|incl\|init\|inje\|inte\|liai\|link\|load\|mass\|mate\|meas\|mort\|mpef\|noec\|opti\|play\|prof\|qual\|regi\|rema\|retu\|robo\|rsou\|sect\|sort\|sphy\|stru\|suit\|typl\|vali\|visu\|clvf\|teau\|wave\|xfem\)[a-zA-Z]*\>'
syn match epxKeywords '\<\(abse\|absi\|abso\|abst\|absz\|acbe\|mod\|ksi\|tau\|rap\|acce\|ale\|viti\|fct\|acie\|acmn\|acmx\|acos\|adad\|adc8\|adcj\|adcr\|addc\|addf\|adfm\|adft\|adhe\|adnp\|adou\|adq4\|adti\|adun\|aflx\|afly\|ahgf\|aini\|airb\|aire\|ajou\|ales\|alf0\|alf1\|alf2\|alfa\|alfn\|alic\|alit\|allf\|alp1\|alp2\|alph\|alpha\|amax\|ambi\|ammb\|amor\|amoy\|volu\|unil\|ampd\|ampf\|ampl\|ampv\|anci\|ang1\|ang2\|angl\|anti\|apex\|appl\|appu\|aprs\|arlq\|arma\|arre\|arti\|ashb\|asin\|asis\|aspe\|asse\|atra\|atrs\|atub\|auto\|autr\|aver\|axe1\|axe2\|axes\|axia\|axis\|axol\|axte\|baco\|bake\|band\|barr\|bary\|base\|bbox\|bdfo\|bens\|bet0\|beta\|betc\|beto\|beton\|bfix\|bflu\|bgla\|bgrn\|bhan\|bifu\|bila\|bill\|bima\|bina\|bivf\|bl3s\|blac\|blan\|blap\|blar\|bleu\|blko\|blmt\|bloq\|blr2\|blue\|bmpi\|body\|bois\|both\|bpel\|bpov\|br3d\|bras\|brec\|bron\|bshr\|bsht\|bubb\|bulk\|bute\|bwdt\|c\|c272\|c273\|c81l\|c82l\|cabl\|cam1\|cam2\|camc\|came\|capa\|car1\|car4\|carb\|cart\|case\|cast\|cavf\|cavi\|cbil\|cbox\|cdem\|cdep\|cdes\|cdno\|ceau\|cech\|celd\|celp\|cend\|cene\|cent\|cero\|cerr\|cesc\|cexp\|cfla\|cfon\|cfvn\|cgaz\|cgla\|cha1\|cha2\|chai\|cham\|chan\|chec\|choc\|chol\|chro\|chsp\|ci12\|ci23\|ci31\|cibd\|cibl\|cini\|circ\|ckap\|cl1d\|cl22\|cl23\|cl2d\|cl32\|cl33\|cl3d\|cl3i\|cl3q\|cl3t\|cl92\|cl93\|clam\|clas\|clay\|clb1\|clb2\|clb3\|clb4\|cld3\|cld6\|clen\|clim\|clmt\|cltu\|clx1\|clx2\|clxs\|cly1\|cly2\|clz1\|clz2\|cmai\|cmc3\|cmdf\|cmid\|cmin\|cmpx\|cmpy\|cmpz\|cnod\|cnor\|coa1\|coa2\|coa3\|coa4\|cocy\|codg\|coea\|coeb\|coef\|coen\|coe_1\|coe_2\|coe_3\|coh2\|cohe\|colo\|cols\|comm\|comp1\|con2\|cond\|cone\|conf\|cons\|cont\|conv\|coo2\|cooh\|coor\|copp\|copt\|copy\|coq3\|coq4\|coqc\|coqi\|coqm\|coqu\|corr\|cort\|cosc\|cote\|couc\|cour\|coxa\|coxb\|coya\|coyb\|coza\|cozb\|cpla\|cpoi\|cput\|cqd3\|cqd4\|cqd6\|cqd9\|cqdf\|cqdx\|cqst\|cqua\|cr2d\|crak\|crea\|crgr\|crit\|croi\|cros\|crtm\|cshe\|csn1\|csn2\|csna\|cson\|cspb\|csph\|csta\|cste\|cstr\|ctim\|cub6\|cub8\|cubb\|cube\|cull\|curr\|curv\|cuvf\|cuvl\|cvel\|cvl1\|cvme\|cvt1\|cvt2\|cyan\|cyap\|cyar\|cyli\|dact\|dadc\|dama\|dash\|dasn\|dble\|dbte\|dc12\|dc13\|dc23\|dcen\|dcma\|dcms\|dcou\|dcri\|debi\|debr\|debu\|debx\|deby\|debz\|dece\|deco\|decx\|decy\|defa\|defi\|defo\|degp\|dele\|delf\|delt\|dems\|dens\|depl\|depo\|derf\|desc\|deta\|dext\|dgri\|dhan\|dhar\|dhas\|dhro\|dhte\|diag\|diap\|diff\|dime\|dimn\|dimx\|dire\|dirf\|dirx\|diry\|dirz\|disp\|dist\|divc\|divg\|dkt3\|dlen\|dmas\|dmax\|dmin\|dmme\|dmmn\|dmoy\|doma\|domd\|done\|dpar\|dpas\|dpax\|dpca\|dpdc\|dpel\|dpem\|dpgr\|dphy\|dpin\|dpla\|dple\|dplg\|dplm\|dpls\|dpma\|dpmi\|dpre\|dprop\|dpru\|dprv\|dpsd\|dpsf\|drag\|drit\|droi\|drpr\|drst\|druc\|drxc\|drxn\|dryc\|dryn\|drzc\|drzn\|dsat\|dsor\|dst3\|dtbe\|dtcr\|dtdr\|dtel\|dtfi\|dtfo\|dtfx\|dtma\|dtmi\|dtml\|dtmx\|dtno\|dtpb\|dtst\|dtub\|dtun\|dtva\|dtxc\|dtxn\|dtyc\|dtyn\|dtzc\|dtzn\|dump\|dyms\|dyna\|eact\|eaft\|eau\|ecin\|ecli\|ecoq\|ecou\|ecrc\|ecrg\|ecrm\|ecrn\|ecro\|ed01\|ed1d\|ed41\|edcv\|edss\|ed_1\|ed_2\|ed_3\|eext\|egal\|eibu\|einj\|eint\|elas\|elat\|elce\|elcr\|eldi\|elec\|elem\|elgr\|elim\|elmx\|elou\|elsn\|elst\|emas\|emax\|emer\|emin\|enda\|endd\|endo\|enel\|ener\|engr\|enma\|enth\|enum\|eobt\|ep12\|ep13\|ep23\|ep31\|epcd\|epcs\|epdv\|eps1\|eps2\|eps3\|eps4\|epsb\|epsd\|epsi\|epsl\|epsm\|epst\|epsy\|ept1\|ept2\|ept3\|eptr\|equi\|eqvd\|eqvf\|eqvl\|erod\|eros\|erri\|erro\|erup\|escl\|eset\|esla\|esub\|etle\|eule\|eval\|exce\|excl\|expa\|expc\|expf\|exte\|extz\|exvl\|fac4\|face\|faci\|fact\|facx\|facy\|facz\|fade\|fail\|fanf\|fant\|farf\|fast\|fcon\|fcte\|fcut\|fdec\|fdyn\|fele\|fene\|ferr\|fext\|ffmt\|ffrd\|fich\|fiel\|file\|fili\|fill\|filt\|fimp\|fini\|fint\|firs\|fixe\|fl23\|fl24\|fl34\|fl35\|fl36\|fl38\|flfa\|flia\|flir\|flmp\|flsr\|flss\|flst\|flsw\|flsx\|flu1\|flu3\|flui\|flut\|flux\|flva\|fnod\|fnor\|fnum\|foam\|foco\|fold\|foll\|fond\|forc\|form\|four\|fplt\|frac\|fram\|frco\|fred\|free\|freq\|fric\|frli\|from\|fron\|frot\|frqr\|fs2d\|fs3d\|fs3t\|fscp\|fscr\|fsin\|fsmt\|fsrd\|fssa\|fssf\|fssl\|fstg\|fsui\|ftan\|ftot\|ftra\|fun2\|fun3\|fune\|fval\|fvit\|gah2\|gam0\|gam1\|gama\|gamg\|gamm\|gamz\|gan2\|gao2\|gaoh\|gard\|gaus\|gauz\|gazd\|gazp\|gbil\|geau\|gene\|genm\|ggas\|ggla\|ghos\|gibi\|ginf\|giul\|glas\|glin\|glob\|glrc\|glue\|gmic\|gol2\|gold\|gotr\|gpcg\|gpdi\|gpin\|gpla\|gpns\|gr05\|gr10\|gr15\|gr20\|gr25\|gr30\|gr35\|gr40\|gr45\|gr50\|gr55\|gr60\|gr65\|gr70\|gr75\|gr80\|gr85\|gr90\|gr95\|grad\|grap\|grav\|gray\|gree\|grep\|grer\|grfs\|grid\|grou\|grps\|guid\|gvdw\|gzpv\|hang\|hard\|harm\|hbis\|heli\|hemi\|heou\|hexa\|hfac\|hfro\|hgq4\|hgri\|hide\|high\|hill\|hinf\|hist\|hole\|homo\|hour\|hpin\|hydr\|hype\|icli\|icol\|idam\|idea\|iden\|idof\|iext\|ifac\|ifis\|ifsa\|igra\|igt1\|igt2\|ilen\|ilno\|imat\|imax\|imes\|imin\|impa\|impe\|impo\|impu\|impv\|imt1\|imt2\|include\|incr\|inde\|indi\|iner\|infi\|info\|inis\|inji\|injm\|injq\|injv\|inou\|insi\|inst\|int4\|int6\|int8\|intr\|ints\|inve\|inwi\|ipa1\|ipa2\|ird1\|ird2\|ires\|isca\|isod\|isoe\|isol\|isot\|ispr\|itep\|iter\|itot\|jade\|jaum\|jaun\|jclm\|jeu1\|jeu2\|jeux\|joco\|join\|jonc\|jprp\|jwls\|k200\|k2ch\|k2fb\|k2gp\|k2ms\|kbar\|kene\|kfil\|kfon\|kfr1\|kfr2\|kfre\|kint\|kmas\|koil\|kper\|kqdm\|kray\|krxc\|krxn\|kryc\|kryn\|krzc\|krzn\|ksi0\|ktub\|ktxc\|ktxn\|ktyc\|ktyn\|ktzc\|ktzn\|lagc\|lagr\|lalp\|lamb\|lapi\|last\|late\|laye\|lbic\|lbmd\|lbms\|lbns\|lbpw\|lbst\|lcab\|lcam\|lchp\|lcof\|lcou\|ldif\|lecd\|lect\|lect\|lees\|lem1\|lene\|leng\|lenm\|lenp\|leve\|lfel\|lfev\|lfno\|lfnv\|lfun\|liaj\|libr\|lign\|ligr\|ligx\|ligy\|ligz\|lima\|limi\|line\|liqu\|list\|llag\|lmam\|lmas\|lmax\|lmc2\|lmin\|lmst\|lnks\|lnod\|loca\|lod1\|log10\|long\|lonp\|loop\|loos\|lord\|lpre\|lqdm\|lsgl\|lshi\|lsle\|lspc\|lspe\|lsqu\|lung\|lvel\|macr\|mage\|mail\|mait\|manu\|map2\|map3\|map4\|map5\|map6\|map7\|mapb\|mapp\|mas2\|mase\|masl\|masn\|mast\|mat1\|mat2\|mavi\|maxc\|maxl\|maza\|mbac\|mbet\|mc23\|mc24\|mc34\|mc35\|mc36\|mc38\|mccs\|mcef\|mcff\|mcfl\|mcgp\|mcma\|mcmf\|mcmu\|mcom\|mcou\|mcp1\|mcp2\|mcpr\|mcro\|mcte\|mcux\|mcuy\|mcuz\|mcva\|mcvc\|mcve\|mcvi\|mcvm\|mcvs\|mcxx\|me1d\|mean\|meau\|mec1\|mec2\|mec3\|mec4\|mec5\|meca\|mede\|medi\|medl\|memb\|memo\|memp\|mens\|mesh\|meta\|mfac\|mfra\|mfro\|mfsr\|mgt1\|mgt2\|mhom\|midp\|mieg\|minm\|mint\|mlev\|mlvl\|mmol\|mmt1\|mmt2\|mnti\|mocc\|moda\|mode\|modi\|modu\|moh2\|mome\|momt\|mon2\|moo2\|mooh\|moon\|mopr\|move\|moy4\|moy5\|moyg\|mqua\|mray\|mrd1\|mrd2\|ms24\|ms38\|mtot\|mtrc\|mtti\|mtub\|mudy\|mulc\|mult\|must\|mvre\|mxit\|mxli\|mxsu\|mxtf\|mxtp\|nact\|nah2\|nale\|nasn\|navi\|navs\|nbco\|nbje\|nble\|nbtu\|nbul\|ncfs\|ncol\|ncom\|ncot\|ncou\|nct1\|nct2\|nddl\|near\|neig\|nele\|nend\|nepe\|neqv\|nero\|nesp\|nf34\|nfai\|nfal\|nfar\|nfas\|nfat\|nfd1\|nfd2\|nfix\|nfkl\|nfkr\|nfks\|nfkt\|nfkx\|nfky\|nfkz\|nfra\|nfro\|nfsc\|nfsl\|nfto\|ngas\|ngau\|ngpz\|ngro\|nima\|nind\|nisc\|nite\|nlhs\|nlin\|nliq\|nlit\|nmax\|nnum\|nobe\|nocl\|noco\|nocr\|nocu\|node\|nodf\|nodp\|nods\|nodu\|noe1\|noe2\|noel\|noer\|noeu\|noex\|nofo\|nogr\|noho\|nohp\|noir\|nois\|noli\|nomu\|nona\|none\|nonp\|nonu\|noob\|nopa\|nopo\|nopp\|nopr\|norb\|nore\|norm\|nosy\|note\|noun\|nout\|nouv\|noxl\|noyl\|npas\|npef\|npfr\|npin\|npoi\|npsf\|nptm\|npto\|npts\|nrar\|nset\|nspe\|nspl\|nspt\|nste\|nsto\|nthr\|ntil\|ntle\|ntra\|ntub\|nu\|nu12\|nu13\|nu23\|nufa\|nufb\|nufl\|nufo\|nult\|nume\|nupa\|nuse\|nusn\|nusp\|nust\|nvfi\|nvmx\|nvsc\|nwal\|nwat\|nwk2\|nwsa\|nwst\|nwtp\|nwxp\|obje\|objn\|obsi\|obso\|odms\|oeil\|of34\|offs\|ogde\|olds\|omeg\|omem\|onam\|opnf\|opos\|ordb\|ordp\|ordr\|orie\|orig\|orsr\|orte\|orth\|orts\|otps\|outl\|outs\|ouv1\|ouv2\|ouv3\|p2x2\|pack\|pair\|pape\|para\|pard\|pare\|parf\|parg\|paro\|part\|pas\|pas0\|pas1\|pasf\|pasm\|pasn\|path\|paxi\|pbas\|pbro\|pcal\|pcas\|pcha\|pcld\|pcom\|pcon\|pcop\|pcou\|pdis\|pdot\|pear\|pele\|pelm\|pema\|pena\|pene\|pent\|pepr\|peps\|perf\|perk\|perp\|perr\|pesc\|pewt\|pext\|pfct\|pfem\|pfin\|pfma\|pfmi\|pfsi\|pgap\|pgaz\|pgol\|pgri\|phan\|phic\|phid\|phii\|phir\|phis\|pigl\|pigm\|pimp\|pinb\|pinc\|pini\|pins\|pite\|pivo\|pkap\|plam\|plan\|plat\|plaw\|plev\|plie\|plin\|pliq\|ploa\|plog\|pmat\|pmax\|pmed\|pmes\|pmet\|pmin\|pmol\|pms1\|pms2\|pmtv\|pnol\|poch\|poi1\|poi2\|poin\|pola\|pomp\|ponc\|pope\|pore\|poro\|posi\|post\|pout\|povr\|pplt\|ppma\|prad\|pray\|pref\|pres\|prgl\|prgr\|prin\|pris\|prob\|prod\|prog\|proj\|prot\|prup\|prvf\|prvl\|psar\|psat\|pscr\|psil\|psys\|pt1d\|ptot\|ptri\|ptsl\|puff\|pvtk\|pwd0\|pyra\|pyro\|pyvf\|pzer\|q41l\|q41n\|q42g\|q42l\|q42n\|q4g4\|q4gr\|q4gs\|q4mc\|q4vf\|q92a\|qgen\|qmax\|qmom\|qmur\|qpps\|qpri\|qtab\|quad\|quas\|quel\|radb\|radi\|rand\|rang\|rayc\|rayo\|rbil\|rcel\|rcon\|rcou\|rdk2\|rdmc\|read\|reb1\|reb2\|reco\|rect\|redp\|redr\|redu\|reen\|refe\|rela\|rena\|rend\|renu\|repr\|rese\|resg\|resi\|resl\|ress\|rest\|resu\|reti\|reto\|return\|reus\|rewr\|rezo\|rgas\|rho\|riem\|righ\|rigi\|riil\|riis\|risk\|rl3d\|rlim\|rmac\|rmas\|rmax\|rmin\|rnum\|ro\|roar\|robu\|robz\|roex\|roga\|roil\|roin\|roli\|rona\|rosa\|rose\|rota\|rotu\|roug\|rout\|ro_0\|ro_f\|rpar\|rpov\|rref\|rris\|rsea\|rst1\|rst2\|rst3\|rtmangl\|rtmrct\|rtmvf\|ruby\|rudi\|rugo\|rupt\|rval\|rvit\|rxdr\|rzip\|safe\|sand\|sauv\|save\|saxe\|sbac\|sbea\|sbou\|scal\|scas\|scav\|scco\|scen\|sclm\|scou\|scrn\|sdfa\|segm\|segn\|sele\|self\|selg\|selm\|selo\|selp\|selv\|sfac\|sfre\|sg2p\|sgbc\|sgeo\|sgmp\|sh3d\|sh3v\|shar\|shb8\|shea\|shel\|shft\|shif\|shift\|shin\|shix\|shiy\|shiz\|show\|shri\|shtu\|sigd\|sige\|sigl\|sign\|sigp\|sigs\|silv\|simp\|sint\|siou\|sism\|siso\|sive\|size\|skew\|skip\|slav\|sler\|slev\|slin\|slip\|slpc\|slpn\|slza\|smal\|smax\|smaz\|smel\|smin\|smli\|smoo\|smou\|snod\|snor\|so12\|so13\|so23\|sol2\|soli\|solu\|solv\|somm\|sord\|sour\|spco\|spec\|spef\|sper\|sphc\|sphe\|sphp\|spla\|spli\|splib\|spline\|splt\|spre\|spta\|sqrt\|srrf\|ssha\|sshe\|ssol\|stab\|stac\|stad\|stak\|stat\|stec\|stel\|step\|stfl\|stgn\|stif\|stop\|stra\|strp\|sttr\|stub\|stwa\|subc\|suiv\|suli\|supp\|surf\|sval\|svit\|swva\|symb\|syme\|symo\|symx\|symy\|sync\|sysc\|syxy\|syxz\|syyz\|sy_1\|sy_2\|sy_3\|t12m\|t23m\|t31m\|t3gs\|t3mc\|t3vf\|tabl\|tabo\|tabp\|tabt\|tach\|tact\|tait\|tape\|tarr\|tau1\|tau2\|tau3\|tau4\|tau5\|tau6\|tauc\|taul\|taut\|taux\|tblo\|tclo\|tcor\|tcpu\|tdea\|tdel\|tdet\|tekt\|temp\|tend\|term\|term\|test\|teta\|tetr\|tevf\|text\|tfai\|tfer\|tfin\|tfre\|tggr\|tgra\|th2o\|thel\|theta\|thic\|thrs\|time\|timp\|tini\|tint\|tion\|tit1\|tit2\|tit3\|titl\|titr\|tmax\|tmen\|tmin\|tmur\|tnod\|tnsn\|to12\|to13\|to23\|toil\|tolc\|tole\|tols\|tope\|tore\|tota\|tous\|tout\|tpar\|tplo\|tpoi\|tr1m\|tr2m\|tr3m\|traa\|trac\|traj\|tran\|trco\|tref\|tria\|trid\|trig\|trup\|tr_1\|tr_2\|tr_3\|tseu\|tsta\|tthi\|tube\|tubm\|tule\|tult\|turb\|turq\|tuvf\|tuya\|tuym\|tval\|tvl1\|tvmc\|txtr\|type\|tyvf\|ucds\|unim\|univ\|updr\|updt\|upto\|upwm\|upws\|user\|uslg\|uslm\|uslp\|uspl\|util\|uzip\|v1lc\|v2lc\|vanl\|vann\|vari\|vaxe\|vcon\|vcor\|vcvi\|vect\|vel1\|vel2\|vel3\|velo\|vemn\|vemx\|veri\|verr\|vert\|vfac\|vfcc\|vflu\|vhar\|viar\|vibu\|vida\|vide\|view\|vili\|vina\|vinf\|vis1\|vis2\|vis3\|vis4\|vis5\|vis6\|visc\|visl\|viso\|visv\|vitc\|vite\|vitg\|vitp\|vitx\|vity\|vitz\|vlin\|vm1d\|vm23\|vmax\|vmis\|vmjc\|vmlp\|vmlu\|vmoy\|vmpr\|vmsf\|vmza\|vnor\|vofi\|vois\|vpjc\|vpla\|vrig\|vrup\|vsca\|vswp\|vtg1\|vtg2\|vtim\|vtra\|vxff\|vyff\|vzff\|wali\|ward\|warp\|watp\|waux\|wcin\|wech\|wext\|wfil\|whan\|whip\|whir\|whit\|wimp\|winj\|wint\|wire\|wk20\|wsau\|wstb\|wsum\|wsys\|wtot\|wtpl\|wxdr\|wxpl\|xaxe\|xcar\|xcor\|xcub\|xdet\|xgrd\|xinf\|xlog\|xlvl\|xmax\|xmgr\|xmin\|xplo\|xzer\|ydet\|yell\|yelp\|yelr\|yetp\|ygrd\|ylog\|ymas\|ymax\|ymin\|youn\|ysta\|yzer\|zac0\|zac1\|zac2\|zac3\|zac4\|zalm\|zdet\|zero\|zeta\|zmax\|zmin\|zone\|zoom\)[a-zA-Z]*\>'
syn match epxKeywords '\<\(error\|attention\|has failed\|warning\|alert\|unknown\|not found\|missing\|unavailable\|no convergence\|impossible\|not possible\|nan\)\>'
syn match epxKeywords '\<\(ok\|successful\|success\|finished\|end of initializations\|normal end\|the final time is reached\)\>'

" Europlexus equal and words
syn match epxVariable '%[A-Z_][0-9A-Z_]\+' 
syn match epxVariable '%[a-z_][0-9a-z_]\+'
syn match epxVariable '%[a-z_]\+'
syn match epxVariable '%[A-Z_]\+'
syn match epxEqual '=' 

" Europlexus string
syn region epxString start='"' end='"'
syn region epxString start='\'' end='\''

" Europlexus comments
syn match epxComment "!.*$" 
syn match epxComment "\*.*$" 
syn match epxComment "\$.*$"

" Europlexus titles
syn match epxTitle "title.*$"
syn match epxTitle "titre.*$"
syn match epxTitle "TITLE.*$"
syn match epxTitle "TITRE.*$"

" Europlexus BEGIN/END DESCRIPTION
syn region epxDescBlock start="begin description" end="end description" 
syn region epxDescBlock start="BEGIN DESCRIPTION" end="END DESCRIPTION" 

" Actual highlighting
hi def link epxNumber      Error
hi def link epxWord        Constant
hi def link epxKeywords    Function
hi def link epxKeywords0   String
hi def link epxVariable    Operator
hi def link epxEqual       PreProc
hi def link epxString      Debug
hi def link epxComment     VertSplit	
hi def link epxTitle       Statement
hi def link epxDescBlock   Comment

let b:current_syntax = "epx"








