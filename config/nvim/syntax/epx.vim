" ==============================================================================
" EPX syntax file
" Language:        EPX
" Original Author: Thomas Douillet-Grellier <thomas.douillet-grellier@edf.fr>
" Maintainer:      tdg <https://github.com/thomasdouilletgrellier>
" Website:         N/A 
" Last Change:     Jun 8, 2024 
"
" ==============================================================================
"
" Clear previous syntax definitions
if exists("b:current_syntax")
  finish
endif

" Sync options - improves performance for large files
syntax sync minlines=50 maxlines=200

" Europlexus comments - prioritize common patterns
syn match epxComment "!.*$" 
syn match epxComment "\*.*$" 
syn match epxComment "\$.*$"

" Europlexus string - simplified pattern
syn region epxString start=/"/ end=/"/ skip=/\\"/
syn region epxString start=/'/ end=/'/ skip=/\\'/

" Europlexus titles
syn match epxTitle "\c\<\(TITLE\|TITRE\).*$"

" Europlexus BEGIN/END DESCRIPTION 
syn region epxDescBlock start="\c\<BEGIN DESCRIPTION\>" end="\<END DESCRIPTION\>"

" Europlexus equal and variables
syn match epxVariable '%[0-9a-zA-Z_]\+'
syn match epxEqual '=' 

" Regular integers and floating point numbers
syn match epxNumber '\<\d\+\>'
syn match epxNumber '[-+]\<\d\+\>'
syn match epxNumber '\<\d\+\.\d*\>'
syn match epxNumber '[-+]\d\+\.\d*\>'
syn match epxNumber '\<\d\+[eE][-+]\=\d\+\>'
syn match epxNumber '\<\d\+\.\d*[eE][-+]\=\d\+\>'

" Create a consolidated list of EPX keywords
syn match epxKeywords0 '\c\<\(ABAQ\|ADAP\|CALC\|CFIN\|CHAR\|CHCK\|COLL\|COMP\|COUP\|loi\|LOI\|DIAM\|DISQ\|ECHO\|ECRI\|EDEF\|EDIT\|ENDP\|EPAI\|RACC\|FESE\|FIN\|FONC\|FSS\|GEOM\|GEOP\|GLIS\|GRIL\|HORL\|IMPR\|INCL\|INIT\|INJE\|INTE\|LIAI\|LINK\|LOAD\|MASS\|MATE\|MEAS\|MORT\|MPEF\|NOEC\|OPTI\|PLAY\|PROF\|QUAL\|REGI\|REMA\|RETU\|ROBO\|RSOU\|SECT\|SORT\|SPHY\|STRU\|SUIT\|TYPL\|VALI\|VISU\|CLVF\|TEAU\|WAVE\|XFEM\|DESS\)[a-zA-Z]*\>'

syn match epxKeywords01 '\c\<\(ABSE\|ABSI\|ABSO\|ABST\|ABSZ\|ACBE\|MOD\|KSI\|TAU\|RAP\|ACCE\|ALE\|VITI\|FCT\|ACIE\|ACMN\|ACMX\|ACOS\|ADAD\|ADC8\|ADCJ\|ADCR\|ADDC\|ADDF\|ADFM\|ADFT\|ADHE\|ADNP\|ADOU\|ADQ4\|ADTI\|ADUN\)[a-zA-Z]*\>'
syn match epxKeywords02 '\c\<\(AFLX\|AFLY\|AHGF\|AINI\|AIRB\|AIRE\|AJOU\|ALES\|ALF0\|ALF1\|ALF2\|ALFA\|ALFN\|ALIC\|ALIT\|ALLF\|ALP1\|ALP2\|ALPH\|ALPHA\|AMAX\|AMBI\|AMMB\|AMOR\|AMOY\|VOLU\|UNIL\|AMPD\|AMPF\|AMPL\|AMPV\)[a-zA-Z]*\>'
syn match epxKeywords03 '\c\<\(ANCI\|ANG1\|ANG2\|ANGL\|ANTI\|APEX\|APPL\|APPU\|APRS\|ARLQ\|ARMA\|ARRE\|ARTI\|ASHB\|ASIN\|ASIS\|ASPE\|ASSE\|ATRA\|ATRS\|ATUB\|AUTO\|AUTR\|AVER\|AXE1\|AXE2\|AXES\|AXIA\|AXIS\|AXOL\|AXTE\)[a-zA-Z]*\>'
syn match epxKeywords04 '\c\<\(BACO\|BAKE\|BAND\|BARR\|BARY\|BASE\|BBOX\|BDFO\|BENS\|BET0\|BETA\|BETC\|BETO\|BETON\|BFIX\|BFLU\|BGLA\|BGRN\|BHAN\|BIFU\|BILA\|BILL\|BIMA\|BINA\|BIVF\|BL3S\|BLAC\|BLAN\|BLAP\|BLAR\|BLEU\)[a-zA-Z]*\>'
syn match epxKeywords05 '\c\<\(BLKO\|BLMT\|BLOQ\|BLR2\|BLUE\|BMPI\|BODY\|BOIS\|BOTH\|BPEL\|BPOV\|BR3D\|BRAS\|BREC\|BRON\|BSHR\|BSHT\|BUBB\|BULK\|BUTE\|BWDT\|C\|C272\|C273\|C81L\|C82L\|CABL\|CAM1\|CAM2\|CAMC\|CAME\|CAPA\)[a-zA-Z]*\>'
syn match epxKeywords06 '\c\<\(CAR1\|CAR4\|CARB\|CART\|CASE\|CAST\|CAVF\|CAVI\|CBIL\|CBOX\|CDEM\|CDEP\|CDES\|CDNO\|CEAU\|CECH\|CELD\|CELP\|CEND\|CENE\|CENT\|CERO\|CERR\|CESC\|CEXP\|CFLA\|CFON\|CFVN\|CGAZ\|CGLA\|CHA1\)[a-zA-Z]*\>'
syn match epxKeywords07 '\c\<\(CHA2\|CHAI\|CHAM\|CHAN\|CHEC\|CHOC\|CHOL\|CHRO\|CHSP\|CI12\|CI23\|CI31\|CIBD\|CIBL\|CINI\|CIRC\|CKAP\|CL1D\|CL22\|CL23\|CL2D\|CL32\|CL33\|CL3D\|CL3I\|CL3Q\|CL3T\|CL92\|CL93\|CLAM\|CLAS\)[a-zA-Z]*\>'
syn match epxKeywords08 '\c\<\(CLAY\|CLB1\|CLB2\|CLB3\|CLB4\|CLD3\|CLD6\|CLEN\|CLIM\|CLMT\|CLTU\|CLX1\|CLX2\|CLXS\|CLY1\|CLY2\|CLZ1\|CLZ2\|CMAI\|CMC3\|CMDF\|CMID\|CMIN\|CMPX\|CMPY\|CMPZ\|CNOD\|CNOR\|COA1\|COA2\|COA3\)[a-zA-Z]*\>'
syn match epxKeywords09 '\c\<\(COA4\|COCY\|CODG\|COEA\|COEB\|COEF\|COEN\|COE_1\|COE_2\|COE_3\|COH2\|COHE\|COLO\|COLS\|COMM\|COMP1\|CON2\|COND\|CONE\|CONF\|CONS\|CONT\|CONV\|COO2\|COOH\|COOR\|COPP\|COPT\|COPY\|COQ3\)[a-zA-Z]*\>'
syn match epxKeywords10 '\c\<\(COQ4\|COQC\|COQI\|COQM\|COQU\|CORR\|CORT\|COSC\|COTE\|COUC\|COUR\|COXA\|COXB\|COYA\|COYB\|COZA\|COZB\|CPLA\|CPOI\|CPUT\|CQD3\|CQD4\|CQD6\|CQD9\|CQDF\|CQDX\|CQST\|CQUA\|CR2D\|CRAK\|CREA\)[a-zA-Z]*\>'
syn match epxKeywords11 '\c\<\(CRGR\|CRIT\|CROI\|CROS\|CRTM\|CSHE\|CSN1\|CSN2\|CSNA\|CSON\|CSPB\|CSPH\|CSTA\|CSTE\|CSTR\|CTIM\|CUB6\|CUB8\|CUBB\|CUBE\|CULL\|CURR\|CURV\|CUVF\|CUVL\|CVEL\|CVL1\|CVME\|CVT1\|CVT2\|CYAN\)[a-zA-Z]*\>'
syn match epxKeywords12 '\c\<\(CYAP\|CYAR\|CYLI\|DACT\|DADC\|DAMA\|DASH\|DASN\|DBLE\|DBTE\|DC12\|DC13\|DC23\|DCEN\|DCMA\|DCMS\|DCOU\|DCRI\|DEBI\|DEBR\|DEBU\|DEBX\|DEBY\|DEBZ\|DECE\|DECO\|DECX\|DECY\|DEFA\|DEFI\|DEFO\)[a-zA-Z]*\>'
syn match epxKeywords13 '\c\<\(DEGP\|DELE\|DELF\|DELT\|DEMS\|DENS\|DEPL\|DEPO\|DERF\|DESC\|DETA\|DEXT\|DGRI\|DHAN\|DHAR\|DHAS\|DHRO\|DHTE\|DIAG\|DIAP\|DIFF\|DIME\|DIMN\|DIMX\|DIRE\|DIRF\|DIRX\|DIRY\|DIRZ\|DISP\|DIST\)[a-zA-Z]*\>'
syn match epxKeywords14 '\c\<\(DIVC\|DIVG\|DKT3\|DLEN\|DMAS\|DMAX\|DMIN\|DMME\|DMMN\|DMOY\|DOMA\|DOMD\|DONE\|DPAR\|DPAS\|DPAX\|DPCA\|DPDC\|DPEL\|DPEM\|DPGR\|DPHY\|DPIN\|DPLA\|DPLE\|DPLG\|DPLM\|DPLS\|DPMA\|DPMI\|DPRE\)[a-zA-Z]*\>'
syn match epxKeywords15 '\c\<\(DPROP\|DPRU\|DPRV\|DPSD\|DPSF\|DRAG\|DRIT\|DROI\|DRPR\|DRST\|DRUC\|DRXC\|DRXN\|DRYC\|DRYN\|DRZC\|DRZN\|DSAT\|DSOR\|DST3\|DTBE\|DTCR\|DTDR\|DTEL\|DTFI\|DTFO\|DTFX\|DTMA\|DTMI\|DTML\|DTMX\)[a-zA-Z]*\>'
syn match epxKeywords16 '\c\<\(DTNO\|DTPB\|DTST\|DTUB\|DTUN\|DTVA\|DTXC\|DTXN\|DTYC\|DTYN\|DTZC\|DTZN\|DUMP\|DYMS\|DYNA\|EACT\|EAFT\|EAU\|ECIN\|ECLI\|ECOQ\|ECOU\|ECRC\|ECRG\|ECRM\|ECRN\|ECRO\|ED01\|ED1D\|ED41\|EDCV\)[a-zA-Z]*\>'
syn match epxKeywords17 '\c\<\(EDSS\|ED_1\|ED_2\|ED_3\|EEXT\|EGAL\|EIBU\|EINJ\|EINT\|ELAS\|ELAT\|ELCE\|ELCR\|ELDI\|ELEC\|ELEM\|ELGR\|ELIM\|ELMX\|ELOU\|ELSN\|ELST\|EMAS\|EMAX\|EMER\|EMIN\|ENDA\|ENDD\|ENDO\|ENEL\|ENER\)[a-zA-Z]*\>'
syn match epxKeywords18 '\c\<\(ENGR\|ENMA\|ENTH\|ENUM\|EOBT\|EP12\|EP13\|EP23\|EP31\|EPCD\|EPCS\|EPDV\|EPS1\|EPS2\|EPS3\|EPS4\|EPSB\|EPSD\|EPSI\|EPSL\|EPSM\|EPST\|EPSY\|EPT1\|EPT2\|EPT3\|EPTR\|EQUI\|EQVD\|EQVF\|EQVL\)[a-zA-Z]*\>'
syn match epxKeywords19 '\c\<\(EROD\|EROS\|ERRI\|ERRO\|ERUP\|ESCL\|ESET\|ESLA\|ESUB\|ETLE\|EULE\|EVAL\|EXCE\|EXCL\|EXPA\|EXPC\|EXPF\|EXTE\|EXTZ\|EXVL\|FAC4\|FACE\|FACI\|FACT\|FACX\|FACY\|FACZ\|FADE\|FAIL\|FANF\|FANT\)[a-zA-Z]*\>'
syn match epxKeywords20 '\c\<\(FARF\|FAST\|FCON\|FCTE\|FCUT\|FDEC\|FDYN\|FELE\|FENE\|FERR\|FEXT\|FFMT\|FFRD\|FICH\|FIEL\|FILE\|FILI\|FILL\|FILT\|FIMP\|FINI\|FINT\|FIRS\|FIXE\|FL23\|FL24\|FL34\|FL35\|FL36\|FL38\|FLFA\)[a-zA-Z]*\>'
syn match epxKeywords21 '\c\<\(FLIA\|FLIR\|FLMP\|FLSR\|FLSS\|FLST\|FLSW\|FLSX\|FLU1\|FLU3\|FLUI\|FLUT\|FLUX\|FLVA\|FNOD\|FNOR\|FNUM\|FOAM\|FOCO\|FOLD\|FOLL\|FOND\|FORC\|FORM\|FOUR\|FPLT\|FRAC\|FRAM\|FRCO\|FRED\|FREE\)[a-zA-Z]*\>'
syn match epxKeywords22 '\c\<\(FREQ\|FRIC\|FRLI\|FROM\|FRON\|FROT\|FRQR\|FS2D\|FS3D\|FS3T\|FSCP\|FSCR\|FSIN\|FSMT\|FSRD\|FSSA\|FSSF\|FSSL\|FSTG\|FSUI\|FTAN\|FTOT\|FTRA\|FUN2\|FUN3\|FUNE\|FVAL\|FVIT\|GAH2\|GAM0\|GAM1\)[a-zA-Z]*\>'
syn match epxKeywords23 '\c\<\(GAMA\|GAMG\|GAMM\|GAMZ\|GAN2\|GAO2\|GAOH\|GARD\|GAUS\|GAUZ\|GAZD\|GAZP\|GBIL\|GEAU\|GENE\|GENM\|GGAS\|GGLA\|GHOS\|GIBI\|GINF\|GIUL\|GLAS\|GLIN\|GLOB\|GLRC\|GLUE\|GMIC\|GOL2\|GOLD\|GOTR\)[a-zA-Z]*\>'
syn match epxKeywords24 '\c\<\(GPCG\|GPDI\|GPIN\|GPLA\|GPNS\|GR05\|GR10\|GR15\|GR20\|GR25\|GR30\|GR35\|GR40\|GR45\|GR50\|GR55\|GR60\|GR65\|GR70\|GR75\|GR80\|GR85\|GR90\|GR95\|GRAD\|GRAP\|GRAV\|GRAY\|GREE\|GREP\|GRER\)[a-zA-Z]*\>'
syn match epxKeywords25 '\c\<\(GRFS\|GRID\|GROU\|GRPS\|GUID\|GVDW\|GZPV\|HANG\|HARD\|HARM\|HBIS\|HELI\|HEMI\|HEOU\|HEXA\|HFAC\|HFRO\|HGQ4\|HGRI\|HIDE\|HIGH\|HILL\|HINF\|HIST\|HOLE\|HOMO\|HOUR\|HPIN\|HYDR\|HYPE\|ICLI\)[a-zA-Z]*\>'
syn match epxKeywords26 '\c\<\(ICOL\|IDAM\|IDEA\|IDEN\|IDOF\|IEXT\|IFAC\|IFIS\|IFSA\|IGRA\|IGT1\|IGT2\|ILEN\|ILNO\|IMAT\|IMAX\|IMES\|IMIN\|IMPA\|IMPE\|IMPO\|IMPU\|IMPV\|IMT1\|IMT2\|INCLUDE\|INCR\|INDE\|INDI\|INER\|INFI\)[a-zA-Z]*\>'
syn match epxKeywords27 '\c\<\(INFO\|INIS\|INJI\|INJM\|INJQ\|INJV\|INOU\|INSI\|INST\|INT4\|INT6\|INT8\|INTR\|INTS\|INVE\|INWI\|IPA1\|IPA2\|IRD1\|IRD2\|IRES\|ISCA\|ISOD\|ISOE\|ISOL\|ISOT\|ISPR\|ITEP\|ITER\|ITOT\|JADE\)[a-zA-Z]*\>'
syn match epxKeywords28 '\c\<\(JAUM\|JAUN\|JCLM\|JEU1\|JEU2\|JEUX\|JOCO\|JOIN\|JONC\|JPRP\|JWLS\|K200\|K2CH\|K2FB\|K2GP\|K2MS\|KBAR\|KENE\|KFIL\|KFON\|KFR1\|KFR2\|KFRE\|KINT\|KMAS\|KOIL\|KPER\|KQDM\|KRAY\|KRXC\|KRXN\)[a-zA-Z]*\>'
syn match epxKeywords29 '\c\<\(KRYC\|KRYN\|KRZC\|KRZN\|KSI0\|KTUB\|KTXC\|KTXN\|KTYC\|KTYN\|KTZC\|KTZN\|LAGC\|LAGR\|LALP\|LAMB\|LAPI\|LAST\|LATE\|LAYE\|LBIC\|LBMD\|LBMS\|LBNS\|LBPW\|LBST\|LCAB\|LCAM\|LCHP\|LCOF\|LCOU\)[a-zA-Z]*\>'
syn match epxKeywords30 '\c\<\(LDIF\|LECD\|LECT\|LECT\|LEES\|LEM1\|LENE\|LENG\|LENM\|LENP\|LEVE\|LFEL\|LFEV\|LFNO\|LFNV\|LFUN\|LIAJ\|LIBR\|LIGN\|LIGR\|LIGX\|LIGY\|LIGZ\|LIMA\|LIMI\|LINE\|LIQU\|LIST\|LLAG\|LMAM\|LMAS\)[a-zA-Z]*\>'
syn match epxKeywords31 '\c\<\(LMAX\|LMC2\|LMIN\|LMST\|LNKS\|LNOD\|LOCA\|LOD1\|LOG10\|LONG\|LONP\|LOOP\|LOOS\|LORD\|LPRE\|LQDM\|LSGL\|LSHI\|LSLE\|LSPC\|LSPE\|LSQU\|LUNG\|LVEL\|MACR\|MAGE\|MAIL\|MAIT\|MANU\|MAP2\|MAP3\)[a-zA-Z]*\>'
syn match epxKeywords32 '\c\<\(MAP4\|MAP5\|MAP6\|MAP7\|MAPB\|MAPP\|MAS2\|MASE\|MASL\|MASN\|MAST\|MAT1\|MAT2\|MAVI\|MAXC\|MAXL\|MAZA\|MBAC\|MBET\|MC23\|MC24\|MC34\|MC35\|MC36\|MC38\|MCCS\|MCEF\|MCFF\|MCFL\|MCGP\|MCMA\)[a-zA-Z]*\>'
syn match epxKeywords33 '\c\<\(MCMF\|MCMU\|MCOM\|MCOU\|MCP1\|MCP2\|MCPR\|MCRO\|MCTE\|MCUX\|MCUY\|MCUZ\|MCVA\|MCVC\|MCVE\|MCVI\|MCVM\|MCVS\|MCXX\|ME1D\|MEAN\|MEAU\|MEC1\|MEC2\|MEC3\|MEC4\|MEC5\|MECA\|MEDE\|MEDI\|MEDL\)[a-zA-Z]*\>'
syn match epxKeywords34 '\c\<\(MEMB\|MEMO\|MEMP\|MENS\|MESH\|META\|MFAC\|MFRA\|MFRO\|MFSR\|MGT1\|MGT2\|MHOM\|MIDP\|MIEG\|MINM\|MINT\|MLEV\|MLVL\|MMOL\|MMT1\|MMT2\|MNTI\|MOCC\|MODA\|MODE\|MODI\|MODU\|MOH2\|MOME\|MOMT\)[a-zA-Z]*\>'
syn match epxKeywords35 '\c\<\(MON2\|MOO2\|MOOH\|MOON\|MOPR\|MOVE\|MOY4\|MOY5\|MOYG\|MQUA\|MRAY\|MRD1\|MRD2\|MS24\|MS38\|MTOT\|MTRC\|MTTI\|MTUB\|MUDY\|MULC\|MULT\|MUST\|MVRE\|MXIT\|MXLI\|MXSU\|MXTF\|MXTP\|NACT\|NAH2\)[a-zA-Z]*\>'
syn match epxKeywords36 '\c\<\(NALE\|NASN\|NAVI\|NAVS\|NBCO\|NBJE\|NBLE\|NBTU\|NBUL\|NCFS\|NCOL\|NCOM\|NCOT\|NCOU\|NCT1\|NCT2\|NDDL\|NEAR\|NEIG\|NELE\|NEND\|NEPE\|NEQV\|NERO\|NESP\|NF34\|NFAI\|NFAL\|NFAR\|NFAS\|NFAT\)[a-zA-Z]*\>'
syn match epxKeywords37 '\c\<\(NFD1\|NFD2\|NFIX\|NFKL\|NFKR\|NFKS\|NFKT\|NFKX\|NFKY\|NFKZ\|NFRA\|NFRO\|NFSC\|NFSL\|NFTO\|NGAS\|NGAU\|NGPZ\|NGRO\|NIMA\|NIND\|NISC\|NITE\|NLHS\|NLIN\|NLIQ\|NLIT\|NMAX\|NNUM\|NOBE\|NOCL\)[a-zA-Z]*\>'
syn match epxKeywords38 '\c\<\(NOCO\|NOCR\|NOCU\|NODE\|NODF\|NODP\|NODS\|NODU\|NOE1\|NOE2\|NOEL\|NOER\|NOEU\|NOEX\|NOFO\|NOGR\|NOHO\|NOHP\|NOIR\|NOIS\|NOLI\|NOMU\|NONA\|NONE\|NONP\|NONU\|NOOB\|NOPA\|NOPO\|NOPP\|NOPR\)[a-zA-Z]*\>'
syn match epxKeywords39 '\c\<\(NORB\|NORE\|NORM\|NOSY\|NOTE\|NOUN\|NOUT\|NOUV\|NOXL\|NOYL\|NPAS\|NPEF\|NPFR\|NPIN\|NPOI\|NPSF\|NPTM\|NPTO\|NPTS\|NRAR\|NSET\|NSPE\|NSPL\|NSPT\|NSTE\|NSTO\|NTHR\|NTIL\|NTLE\|NTRA\|NTUB\)[a-zA-Z]*\>'
syn match epxKeywords40 '\c\<\(NU\|NU12\|NU13\|NU23\|NUFA\|NUFB\|NUFL\|NUFO\|NULT\|NUME\|NUPA\|NUSE\|NUSN\|NUSP\|NUST\|NVFI\|NVMX\|NVSC\|NWAL\|NWAT\|NWK2\|NWSA\|NWST\|NWTP\|NWXP\|OBJE\|OBJN\|OBSI\|OBSO\|ODMS\|OEIL\)[a-zA-Z]*\>'
syn match epxKeywords41 '\c\<\(OF34\|OFFS\|OGDE\|OLDS\|OMEG\|OMEM\|ONAM\|OPNF\|OPOS\|ORDB\|ORDP\|ORDR\|ORIE\|ORIG\|ORSR\|ORTE\|ORTH\|ORTS\|OTPS\|OUTL\|OUTS\|OUV1\|OUV2\|OUV3\|P2X2\|PACK\|PAIR\|PAPE\|PARA\|PARD\|PARE\)[a-zA-Z]*\>'
syn match epxKeywords42 '\c\<\(PARF\|PARG\|PARO\|PART\|PAS\|PAS0\|PAS1\|PASF\|PASM\|PASN\|PATH\|PAXI\|PBAS\|PBRO\|PCAL\|PCAS\|PCHA\|PCLD\|PCOM\|PCON\|PCOP\|PCOU\|PDIS\|PDOT\|PEAR\|PELE\|PELM\|PEMA\|PENA\|PENE\|PENT\)[a-zA-Z]*\>'
syn match epxKeywords43 '\c\<\(PEPR\|PEPS\|PERF\|PERK\|PERP\|PERR\|PESC\|PEWT\|PEXT\|PFCT\|PFEM\|PFIN\|PFMA\|PFMI\|PFSI\|PGAP\|PGAZ\|PGOL\|PGRI\|PHAN\|PHIC\|PHID\|PHII\|PHIR\|PHIS\|PIGL\|PIGM\|PIMP\|PINB\|PINC\|PINI\)[a-zA-Z]*\>'
syn match epxKeywords44 '\c\<\(PINS\|PITE\|PIVO\|PKAP\|PLAM\|PLAN\|PLAT\|PLAW\|PLEV\|PLIE\|PLIN\|PLIQ\|PLOA\|PLOG\|PMAT\|PMAX\|PMED\|PMES\|PMET\|PMIN\|PMOL\|PMS1\|PMS2\|PMTV\|PNOL\|POCH\|POI1\|POI2\|POIN\|POLA\|POMP\)[a-zA-Z]*\>'
syn match epxKeywords45 '\c\<\(PONC\|POPE\|PORE\|PORO\|POSI\|POST\|POUT\|POVR\|PPLT\|PPMA\|PRAD\|PRAY\|PREF\|PRES\|PRGL\|PRGR\|PRIN\|PRIS\|PROB\|PROD\|PROG\|PROJ\|PROT\|PRUP\|PRVF\|PRVL\|PSAR\|PSAT\|PSCR\|PSIL\|PSYS\)[a-zA-Z]*\>'
syn match epxKeywords46 '\c\<\(PT1D\|PTOT\|PTRI\|PTSL\|PUFF\|PVTK\|PWD0\|PYRA\|PYRO\|PYVF\|PZER\|Q41L\|Q41N\|Q42G\|Q42L\|Q42N\|Q4G4\|Q4GR\|Q4GS\|Q4MC\|Q4VF\|Q92A\|QGEN\|QMAX\|QMOM\|QMUR\|QPPS\|QPRI\|QTAB\|QUAD\|QUAS\)[a-zA-Z]*\>'
syn match epxKeywords47 '\c\<\(QUEL\|RADB\|RADI\|RAND\|RANG\|RAYC\|RAYO\|RBIL\|RCEL\|RCON\|RCOU\|RDK2\|RDMC\|READ\|REB1\|REB2\|RECO\|RECT\|REDP\|REDR\|REDU\|REEN\|REFE\|RELA\|RENA\|REND\|RENU\|REPR\|RESE\|RESG\|RESI\)[a-zA-Z]*\>'
syn match epxKeywords48 '\c\<\(RESL\|RESS\|REST\|RESU\|RETI\|RETO\|RETURN\|REUS\|REWR\|REZO\|RGAS\|RHO\|RIEM\|RIGH\|RIGI\|RIIL\|RIIS\|RISK\|RL3D\|RLIM\|RMAC\|RMAS\|RMAX\|RMIN\|RNUM\|RO\|ROAR\|ROBU\|ROBZ\|ROEX\|ROGA\)[a-zA-Z]*\>'
syn match epxKeywords49 '\c\<\(ROIL\|ROIN\|ROLI\|RONA\|ROSA\|ROSE\|ROTA\|ROTU\|ROUG\|ROUT\|RO_0\|RO_F\|RPAR\|RPOV\|RREF\|RRIS\|RSEA\|RST1\|RST2\|RST3\|RTMANGL\|RTMRCT\|RTMVF\|RUBY\|RUDI\|RUGO\|RUPT\|RVAL\|RVIT\|RXDR\)[a-zA-Z]*\>'
syn match epxKeywords50 '\c\<\(RZIP\|SAFE\|SAND\|SAUV\|SAVE\|SAXE\|SBAC\|SBEA\|SBOU\|SCAL\|SCAS\|SCAV\|SCCO\|SCEN\|SCLM\|SCOU\|SCRN\|SDFA\|SEGM\|SEGN\|SELE\|SELF\|SELG\|SELM\|SELO\|SELP\|SELV\|SFAC\|SFRE\|SG2P\|SGBC\)[a-zA-Z]*\>'
syn match epxKeywords51 '\c\<\(SGEO\|SGMP\|SH3D\|SH3V\|SHAR\|SHB8\|SHEA\|SHEL\|SHFT\|SHIF\|SHIFT\|SHIN\|SHIX\|SHIY\|SHIZ\|SHOW\|SHRI\|SHTU\|SIGD\|SIGE\|SIGL\|SIGN\|SIGP\|SIGS\|SILV\|SIMP\|SINT\|SIOU\|SISM\|SISO\|SIVE\)[a-zA-Z]*\>'
syn match epxKeywords52 '\c\<\(SIZE\|SKEW\|SKIP\|SLAV\|SLER\|SLEV\|SLIN\|SLIP\|SLPC\|SLPN\|SLZA\|SMAL\|SMAX\|SMAZ\|SMEL\|SMIN\|SMLI\|SMOO\|SMOU\|SNOD\|SNOR\|SO12\|SO13\|SO23\|SOL2\|SOLI\|SOLU\|SOLV\|SOMM\|SORD\|SOUR\)[a-zA-Z]*\>'
syn match epxKeywords53 '\c\<\(SPCO\|SPEC\|SPEF\|SPER\|SPHC\|SPHE\|SPHP\|SPLA\|SPLI\|SPLIB\|SPLINE\|SPLT\|SPRE\|SPTA\|SQRT\|SRRF\|SSHA\|SSHE\|SSOL\|STAB\|STAC\|STAD\|STAK\|STAT\|STEC\|STEL\|STEP\|STFL\|STGN\|STIF\)[a-zA-Z]*\>'
syn match epxKeywords54 '\c\<\(STOP\|STRA\|STRP\|STTR\|STUB\|STWA\|SUBC\|SUIV\|SULI\|SUPP\|SURF\|SVAL\|SVIT\|SWVA\|SYMB\|SYME\|SYMO\|SYMX\|SYMY\|SYNC\|SYSC\|SYXY\|SYXZ\|SYYZ\|SY_1\|SY_2\|SY_3\|T12M\|T23M\|T31M\|T3GS\)[a-zA-Z]*\>'
syn match epxKeywords55 '\c\<\(T3MC\|T3VF\|TABL\|TABO\|TABP\|TABT\|TACH\|TACT\|TAIT\|TAPE\|TARR\|TAU1\|TAU2\|TAU3\|TAU4\|TAU5\|TAU6\|TAUC\|TAUL\|TAUT\|TAUX\|TBLO\|TCLO\|TCOR\|TCPU\|TDEA\|TDEL\|TDET\|TEKT\|TEMP\|TEND\)[a-zA-Z]*\>'
syn match epxKeywords56 '\c\<\(TERM\|TERM\|TEST\|TETA\|TETR\|TEVF\|TEXT\|TFAI\|TFER\|TFIN\|TFRE\|TGGR\|TGRA\|TH2O\|THEL\|THETA\|THIC\|THRS\|TIME\|TIMP\|TINI\|TINT\|TION\|TIT1\|TIT2\|TIT3\|TITL\|TITR\|TMAX\|TMEN\|TMIN\)[a-zA-Z]*\>'
syn match epxKeywords57 '\c\<\(TMUR\|TNOD\|TNSN\|TO12\|TO13\|TO23\|TOIL\|TOLC\|TOLE\|TOLS\|TOPE\|TORE\|TOTA\|TOUS\|TOUT\|TPAR\|TPLO\|TPOI\|TR1M\|TR2M\|TR3M\|TRAA\|TRAC\|TRAJ\|TRAN\|TRCO\|TREF\|TRIA\|TRID\|TRIG\|TRUP\)[a-zA-Z]*\>'
syn match epxKeywords58 '\c\<\(TR_1\|TR_2\|TR_3\|TSEU\|TSTA\|TTHI\|TUBE\|TUBM\|TULE\|TULT\|TURB\|TURQ\|TUVF\|TUYA\|TUYM\|TVAL\|TVL1\|TVMC\|TXTR\|TYPE\|TYVF\|UCDS\|UNIM\|UNIV\|UPDR\|UPDT\|UPTO\|UPWM\|UPWS\|USER\|USLG\)[a-zA-Z]*\>'
syn match epxKeywords59 '\c\<\(USLM\|USLP\|USPL\|UTIL\|UZIP\|V1LC\|V2LC\|VANL\|VANN\|VARI\|VAXE\|VCON\|VCOR\|VCVI\|VECT\|VEL1\|VEL2\|VEL3\|VELO\|VEMN\|VEMX\|VERI\|VERR\|VERT\|VFAC\|VFCC\|VFLU\|VHAR\|VIAR\|VIBU\|VIDA\)[a-zA-Z]*\>'
syn match epxKeywords60 '\c\<\(VIDE\|VIEW\|VILI\|VINA\|VINF\|VIS1\|VIS2\|VIS3\|VIS4\|VIS5\|VIS6\|VISC\|VISL\|VISO\|VISV\|VITC\|VITE\|VITG\|VITP\|VITX\|VITY\|VITZ\|VLIN\|VM1D\|VM23\|VMAX\|VMIS\|VMJC\|VMLP\|VMLU\|VMOY\)[a-zA-Z]*\>'
syn match epxKeywords61 '\c\<\(VMPR\|VMSF\|VMZA\|VNOR\|VOFI\|VOIS\|VPJC\|VPLA\|VRIG\|VRUP\|VSCA\|VSWP\|VTG1\|VTG2\|VTIM\|VTRA\|VXFF\|VYFF\|VZFF\|WALI\|WARD\|WARP\|WATP\|WAUX\|WCIN\|WECH\|WEXT\|WFIL\|WHAN\|WHIP\|WHIR\)[a-zA-Z]*\>'
syn match epxKeywords62 '\c\<\(WHIT\|WIMP\|WINJ\|WINT\|WIRE\|WK20\|WSAU\|WSTB\|WSUM\|WSYS\|WTOT\|WTPL\|WXDR\|WXPL\|XAXE\|XCAR\|XCOR\|XCUB\|XDET\|XGRD\|XINF\|XLOG\|XLVL\|XMAX\|XMGR\|XMIN\|XPLO\|XZER\|YDET\|YELL\|YELP\)[a-zA-Z]*\>'
syn match epxKeywords63 '\c\<\(YELR\|YETP\|YGRD\|YLOG\|YMAS\|YMAX\|YMIN\|YOUN\|YSTA\|YZER\|ZAC0\|ZAC1\|ZAC2\|ZAC3\|ZAC4\|ZALM\|ZDET\|ZERO\|ZETA\|ZMAX\|ZMIN\|ZONE\|ZOOM\|KAPA0\)[a-zA-Z]*\>'

" Match any word not covered by other syntax rules
syn match epxWord '[0-9a-zA-Z_]\+' contained

" Apply highlighting
hi def link epxNumber      Error
hi def link epxWord        Constant
hi def link epxKeywords01  Function
hi def link epxKeywords02  Function
hi def link epxKeywords03  Function
hi def link epxKeywords04  Function
hi def link epxKeywords05  Function
hi def link epxKeywords06  Function
hi def link epxKeywords07  Function
hi def link epxKeywords08  Function
hi def link epxKeywords09  Function
hi def link epxKeywords10  Function
hi def link epxKeywords11  Function
hi def link epxKeywords12  Function
hi def link epxKeywords13  Function
hi def link epxKeywords14  Function
hi def link epxKeywords15  Function
hi def link epxKeywords16  Function
hi def link epxKeywords17  Function
hi def link epxKeywords18  Function
hi def link epxKeywords19  Function
hi def link epxKeywords20  Function
hi def link epxKeywords21  Function
hi def link epxKeywords22  Function
hi def link epxKeywords23  Function
hi def link epxKeywords24  Function
hi def link epxKeywords25  Function
hi def link epxKeywords26  Function
hi def link epxKeywords27  Function
hi def link epxKeywords28  Function
hi def link epxKeywords29  Function
hi def link epxKeywords30  Function
hi def link epxKeywords31  Function
hi def link epxKeywords32  Function
hi def link epxKeywords33  Function
hi def link epxKeywords34  Function
hi def link epxKeywords35  Function
hi def link epxKeywords36  Function
hi def link epxKeywords37  Function
hi def link epxKeywords38  Function
hi def link epxKeywords39  Function
hi def link epxKeywords40  Function
hi def link epxKeywords41  Function
hi def link epxKeywords42  Function
hi def link epxKeywords43  Function
hi def link epxKeywords44  Function
hi def link epxKeywords45  Function
hi def link epxKeywords46  Function
hi def link epxKeywords47  Function
hi def link epxKeywords48  Function
hi def link epxKeywords49  Function
hi def link epxKeywords50  Function
hi def link epxKeywords51  Function
hi def link epxKeywords52  Function
hi def link epxKeywords53  Function
hi def link epxKeywords54  Function
hi def link epxKeywords55  Function
hi def link epxKeywords56  Function
hi def link epxKeywords57  Function
hi def link epxKeywords58  Function
hi def link epxKeywords59  Function
hi def link epxKeywords60  Function
hi def link epxKeywords61  Function
hi def link epxKeywords62  Function
hi def link epxKeywords63  Function
hi def link epxKeywords0   String
hi def link epxVariable    Operator
hi def link epxEqual       PreProc
hi def link epxString      Debug
hi def link epxComment     Comment
hi def link epxTitle       Statement
hi def link epxDescBlock   Comment

let b:current_syntax = "epx"