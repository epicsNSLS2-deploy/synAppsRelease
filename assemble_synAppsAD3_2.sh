#!/bin/bash
shopt -s expand_aliases

EPICS_BASE=/epics/base-3.15.5

SUPPORT=R6-1
CONFIGURE=R6-1
UTILS=R6-1
DOCUMENTATION=R6-1


#BASE=R7.0.1.1
#ALLENBRADLEY=2.3
#ALIVE=R1-1-0
AREA_DETECTOR=R3-4
ASYN=R4-34
AUTOSAVE=R5-9
BUSY=R1-7
CALC=R3-7-1
#CAMAC=R2-7-1
#CAPUTRECORDER=R1-7-1
#DAC128V=R2-9
#DELAYGEN=R1-2-0
#DXP=R4-0
DEVIOCSTATS=3.1.15
#GALIL=V3-6
#IP=R2-19-1
IPAC=2.15
#IP330=R2-9
IPUNIDIG=R2-11
#LOVE=R3-2-6
#LUA=R1-2
MCA=R7-7
#MEASCOMP=R2-1
#MODBUS=R2-10-1
#MOTOR=R6-10-1
#OPTICS=R2-13-1
#QUADEM=R9-1
SNCSEQ=2.2.6
#SOFTGLUE=R2-8-1
#SOFTGLUEZYNQ=master
SSCAN=R2-11-1
STD=R3-5
STREAM=R2-7-7b
#VAC=R1-7
#VME=R2-9
#YOKOGAWA_DAS=master
#XXX=master


shallow_repo()
{
	PROJECT=$1
	MODULE_NAME=$2
	RELEASE_NAME=$3
	TAG=$4
	
        # Remove R from TAG, and replace . with -
        if [[ $TAG =~ [R] ]]; then
            TAG_T=${TAG//R/}
        else
            TAG_T=$TAG
        fi
	FOLDER_NAME=$MODULE_NAME-${TAG_T//./-}
	
	echo
	echo "Grabbing $MODULE_NAME at tag: $TAG"
	echo
	
	git clone -q --branch $TAG --depth 1 https://github.com/$PROJECT/$MODULE_NAME.git $FOLDER_NAME
	
	echo "$RELEASE_NAME=\$(SUPPORT)/$FOLDER_NAME" >> ./configure/RELEASE
	
	echo
}

full_repo()
{
	PROJECT=$1
	MODULE_NAME=$2
	RELEASE_NAME=$3
	TAG=$4

        # Remove R from TAG, and replace . with -
        if [[ $TAG =~ [R] ]]; then
            TAG_T=${TAG//R/}
        else
            TAG_T=$TAG
        fi
        FOLDER_NAME=$MODULE_NAME-${TAG_T//./-}
	
	echo
	echo "Grabbing $MODULE_NAME at tag: $TAG"
	echo
	
	git clone -q https://github.com/$PROJECT/$MODULE_NAME.git $FOLDER_NAME
	
	#CURR=$(pwd)
	#printf -v CURR "%q" "$(pwd)"
	CURR=$(pwd)
	echo $CURR
	
	cd $FOLDER_NAME
	git checkout -q $TAG
	cd "$CURR"
	echo "$RELEASE_NAME=\$(SUPPORT)/$FOLDER_NAME" >> ./configure/RELEASE
	
	echo
}

full_repo_notag()
{
	PROJECT=$1
	MODULE_NAME=$2
	RELEASE_NAME=$3
	TAG=$4

        # Remove R from TAG, and replace . with -
        if [[ $TAG =~ [R] ]]; then
            TAG_T=${TAG//R/}
        else
            TAG_T=$TAG
        fi
#        FOLDER_NAME=$MODULE_NAME-${TAG_T//./-}
        FOLDER_NAME=$MODULE_NAME
	
	echo
	echo "Grabbing $MODULE_NAME at tag: $TAG"
	echo
	
	git clone -q https://github.com/$PROJECT/$MODULE_NAME.git $FOLDER_NAME
	
	#CURR=$(pwd)
	#printf -v CURR "%q" "$(pwd)"
	CURR=$(pwd)
	echo $CURR
	
	cd $FOLDER_NAME
#	git checkout -q $TAG
	git checkout master
	cd "$CURR"
	echo "$RELEASE_NAME=\$(SUPPORT)/$FOLDER_NAME" >> ./configure/RELEASE
	
	echo
}


full_repo_submodule()
{
	PROJECT=$1
	MODULE_NAME=$2
	RELEASE_NAME=$3
	TAG=$4

        # Remove R from TAG, and replace . with -
        if [[ $TAG =~ [R] ]]; then
            TAG_T=${TAG//R/}
        else
            TAG_T=$TAG
        fi
        FOLDER_NAME=$MODULE_NAME-${TAG_T//./-}
	
	echo
	echo "Grabbing $MODULE_NAME at tag: $TAG"
	echo
	
	git clone -q --recursive https://github.com/$PROJECT/$MODULE_NAME.git $FOLDER_NAME
	
	#CURR=$(pwd)
	#printf -v CURR "%q" "$(pwd)"
	CURR=$(pwd)
	echo $CURR
	
	cd $FOLDER_NAME
	git checkout -q $TAG
	cd "$CURR"
	echo "$RELEASE_NAME=\$(SUPPORT)/$FOLDER_NAME" >> ./configure/RELEASE
	
	echo
}


shallow_support()
{
	git clone -q --branch $2 --depth 1 https://github.com/EPICS-synApps/$1.git
}


full_support()
{
	git clone -q https://github.com/EPICS-synApps/$1.git
	cd $1
	git checkout -q $2
	cd ..
}

alias get_support='shallow_support'
alias get_repo='shallow_repo'

if [ "$1" == "full" ]; then
	alias get_support='full_support'
#	alias get_repo='full_repo'
	alias get_repo='full_repo_notag'
fi


# Assume user has nothing but this file, just in case that's true.
mkdir synApps
cd synApps

get_support support $SUPPORT
cd support

get_support configure      $CONFIGURE
get_support utils          $UTILS
get_support documentation  $DOCUMENTATION


echo "SUPPORT=$(pwd)" > configure/RELEASE
echo '-include $(TOP)/configure/SUPPORT.$(EPICS_HOST_ARCH)' >> configure/RELEASE
echo "EPICS_BASE=$EPICS_BASE" >> configure/RELEASE
echo '-include $(TOP)/configure/EPICS_BASE' >> configure/RELEASE
echo '-include $(TOP)/configure/EPICS_BASE.$(EPICS_HOST_ARCH)' >> configure/RELEASE
echo "" >> configure/RELEASE
echo "" >> configure/RELEASE

# modules ##################################################################

#                               get_repo Git Project    Git Repo       RELEASE Name   Tag
if [[ $ALIVE ]];         then   get_repo epics-modules  alive          ALIVE          $ALIVE         ; fi
if [[ $ASYN ]];          then   get_repo epics-modules  asyn           ASYN           $ASYN          ; fi
if [[ $AUTOSAVE ]];      then   get_repo epics-modules  autosave       AUTOSAVE       $AUTOSAVE      ; fi
if [[ $BUSY ]];          then   get_repo epics-modules  busy           BUSY           $BUSY          ; fi
if [[ $CALC ]];          then   get_repo epics-modules  calc           CALC           $CALC          ; fi
if [[ $CAMAC ]];         then   get_repo epics-modules  camac          CAMAC          $CAMAC         ; fi
if [[ $CAPUTRECORDER ]]; then   get_repo epics-modules  caputRecorder  CAPUTRECORDER  $CAPUTRECORDER ; fi
if [[ $DAC128V ]];       then   get_repo epics-modules  dac128V        DAC128V        $DAC128V       ; fi
if [[ $DELAYGEN ]];      then   get_repo epics-modules  delaygen       DELAYGEN       $DELAYGEN      ; fi
if [[ $DXP ]];           then   get_repo epics-modules  dxp            DXP            $DXP           ; fi
if [[ $DEVIOCSTATS ]];   then   get_repo epics-modules  iocStats       DEVIOCSTATS    $DEVIOCSTATS   ; fi
if [[ $GALIL ]];         then   get_repo motorapp       Galil-3-0      GALIL          $GALIL         ; fi
if [[ $IP ]];            then   get_repo epics-modules  ip             IP             $IP            ; fi
if [[ $IPAC ]];          then   get_repo epics-modules  ipac           IPAC           $IPAC          ; fi
if [[ $IP330 ]];         then   get_repo epics-modules  ip330          IP330          $IP330         ; fi
if [[ $IPUNIDIG ]];      then   get_repo epics-modules  ipUnidig       IPUNIDIG       $IPUNIDIG      ; fi
if [[ $LOVE ]];          then   get_repo epics-modules  love           LOVE           $LOVE          ; fi
if [[ $LUA ]];           then   get_repo epics-modules  lua            LUA            $LUA           ; fi
if [[ $MCA ]];           then   get_repo epics-modules  mca            MCA            $MCA           ; fi
if [[ $MEASCOMP ]];      then   get_repo epics-modules  measComp       MEASCOMP       $MEASCOMP      ; fi
if [[ $MODBUS ]];        then   get_repo epics-modules  modbus         MODBUS         $MODBUS        ; fi
if [[ $MOTOR ]];         then   get_repo epics-modules  motor          MOTOR          $MOTOR         ; fi
if [[ $OPTICS ]];        then   get_repo epics-modules  optics         OPTICS         $OPTICS        ; fi
if [[ $QUADEM ]];        then   get_repo epics-modules  quadEM         QUADEM         $QUADEM        ; fi
if [[ $SOFTGLUE ]];      then   get_repo epics-modules  softGlue       SOFTGLUE       $SOFTGLUE      ; fi
if [[ $SOFTGLUEZYNQ ]];  then   get_repo epics-modules  softGlueZynq   SOFTGLUEZYNQ   $SOFTGLUEZYNQ  ; fi
if [[ $SSCAN ]];         then   get_repo epics-modules  sscan          SSCAN          $SSCAN         ; fi
if [[ $STD ]];           then   get_repo epics-modules  std            STD            $STD           ; fi
if [[ $VAC ]];           then   get_repo epics-modules  vac            VAC            $VAC           ; fi
if [[ $VME ]];           then   get_repo epics-modules  vme            VME            $VME           ; fi
if [[ $YOKOGAWA_DAS ]];  then   get_repo epics-modules  Yokogawa_DAS   YOKOGAWA_DAS   $YOKOGAWA_DAS  ; fi
if [[ $XXX ]];           then   get_repo epics-modules  xxx            XXX            $XXX           ; fi

#Blow away iocStats existing RELEASE file until SUPPORT is ever defined
if [[ $DEVIOCSTATS ]];   then
#cd iocStats-${DEVIOCSTATS//./-}
cd iocStats
cd configure
rm -f RELEASE
echo "EPICS_BASE=." >> RELEASE
echo "SUPPORT=." >> RELEASE
echo "SNCSEQ=." >> RELEASE
echo '-include $(SUPPORT)/configure/EPICS_BASE.$(EPICS_HOST_ARCH)' >> RELEASE
cd ../..
fi


if [[ $STREAM ]]
then

get_repo  epics-modules  stream  STREAM  $STREAM

#cd stream-${STREAM//R/}
cd stream
git checkout master
git submodule init
git submodule update
cd ..

fi


if [[ $AREA_DETECTOR ]]
then 

full_repo_submodule areaDetector areaDetector AREA_DETECTOR  $AREA_DETECTOR
echo "areaDetector $AREA_DETECTOR"
cd areaDetector-${AREA_DETECTOR//R/}
#git checkout master
git submodule foreach --recursive git checkout master
# git submodule update --init --recursive	# It doesn't checkout master, just all the submodules!
cd ..

#cd areaDetector-$AREA_DETECTOR
#git submodule init
#git submodule update ADCore
#git submodule update ADSupport
#git submodule update ADSimDetector
#cd ..

echo 'ADCORE=$(AREA_DETECTOR)/ADCore' >> ./configure/RELEASE
echo 'ADSUPPORT=$(AREA_DETECTOR)/ADSupport' >> ./configure/RELEASE
echo 'ADSIMDETECTOR=$(AREA_DETECTOR)/ADSimDetector' >> ./configure/RELEASE

fi


if [[ $SNCSEQ ]]
then

# seq
wget http://www-csr.bessy.de/control/SoftDist/sequencer/releases/seq-$SNCSEQ.tar.gz
tar zxf seq-$SNCSEQ.tar.gz
# The synApps build can't handle '.'
mv seq-$SNCSEQ seq-${SNCSEQ//./-}
rm -f seq-$SNCSEQ.tar.gz
echo "SNCSEQ=\$(SUPPORT)/seq-${SNCSEQ//./-}" >> ./configure/RELEASE

fi

if [[ $ALLENBRADLEY ]]
then

# get allenBradley-2-3
wget http://www.aps.anl.gov/epics/download/modules/allenBradley-$ALLENBRADLEY.tar.gz
tar xf allenBradley-$ALLENBRADLEY.tar.gz
mv allenBradley-$ALLENBRADLEY allenBradley-${ALLENBRADLEY//./-}
rm -f allenBradley-$ALLENBRADLEY.tar.gz
echo "ALLENBRADLEY=\$(SUPPORT)/allenBradley-${ALLENBRADLEY//./-}" >> ./configure/RELEASE

fi


if [[ $ETHERIP ]]
then

# etherIP
wget https://github.com/EPICSTools/ether_ip/archive/ether_ip-2-26.tar.gz
tar zxf ether_ip-2-26.tar.gz
mv ether_ip-ether_ip-2-26 ether_ip-2-26
rm -f ether_ip-2-26.tar.gz
echo 'ETHERIP=$(SUPPORT)/ether_ip-2-26' >> ./configure/RELEASE


fi

if [[ $GALIL ]]
then

mv Galil-3-0-$GALIL/3-6 galil-3-6
rm -Rf Galil-3-0-$GALIL
cp galil-3-6/config/GALILRELEASE galil-3-6/configure/RELEASE
echo 'GALIL=$(SUPPORT)/galil-3-6' >> ./configure/RELEASE
sed -i 's/MODULE_LIST[ ]*=[ ]*MEASCOMP/MODULE_LIST = MEASCOMP GALIL/g' Makefile
sed -i '/\$(MEASCOMP)_DEPEND_DIRS/a \$(GALIL)_DEPEND_DIRS = \$(AUTOSAVE) \$(SNCSEQ) \$(SSCAN) \$(CALC) \$(ASYN) \$(BUSY) \$(MOTOR) \$(IPAC)' Makefile

fi

make release

# Pull the base from repo into synApp, and same level as support
cd ..
if [[ $BASE ]]
then 

    full_repo_submodule epics-base epics-base BASE  $BASE
    echo "epics-base $BASE"
    # Remove R from BASE, and replace . with -
    BASE_T=$BASE
    if [[ $BASE =~ [R] ]]; then
        BASE_T=${BASE//R/}
    else
        BASE_T=$BASE
    fi
    cd "epics-base-${BASE_T//./-}"
    echo $PWD
    #git checkout master
    git submodule update --init --reference ./
    #git submodule foreach --recursive git checkout master
    # git submodule update --init --recursive	# It doesn't checkout master, just all the submodules!
    cd ..

fi
