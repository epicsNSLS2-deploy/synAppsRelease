#!/bin/bash

# ###############################################
# Based on Peter Jemian script from  tech-talk
# https://epics.anl.gov/tech-talk/2018/msg00259.php
# ###############################################

#wget https://raw.githubusercontent.com/EPICS-synApps/support/master/assemble_synApps.sh
# edit for local choices
#bash assemble_synApps.sh

# ##########################
# On Windows x64 specify location
# EPICS_BASE in support/configure/EPICS_BASE.windows-x64
# SUPPORT in support/configure/SUPPORT.windows-x64
# ##########################

# ################################
# assemble_synApps.sh modified to AreaDetector 3.2 onley
# ================================
bash assemble_synAppsAD.sh full
cd synApps/support
#sed -i "s/^EPICS_BASE=.*/EPICS_BASE=\/epics\/base-3.15.5/" configure/RELEASE
sed -i "s/^EPICS_BASE=.*/EPICS_BASE=\/epics\/base-7.0.1/" configure/RELEASE
make release

#git clone https://github.com/areaDetector/areaDetector
#cd areaDetector
#git clone https://github.com/areaDetector/ADCore
#git clone https://github.com/areaDetector/ADSupport
#git clone https://github.com/areaDetector/ADSimDetector
#git clone https://github.com/areaDetector/ADProsilica
#git clone https://github.com/areaDetector/ADAndor3
#git clone https://github.com/areaDetector/ADDexela


# Sort out releases ('git checkout master' for most recent)
#git checkout R3-2; 
#cd ADCore; git checkout R3-2; cd ..
#cd ADSupport; git checkout R1-4; cd ..
#cd ADSimDetector; git checkout R2-7; cd ..
#cd ADProsilica; git checkout R2-4; cd ..
#cd ADAndor3; git checkout R2-2; cd ..
#cd ADDexela; git checkout R2-1; cd ..
#cd ADDexela; git checkout master; cd ..

# Edit AreaDetector/configure/RELEASE... file system

# ##################################
# Compilation order (areaDetector 3-2)
# Date: 2018-2-7
# ====================================
#seq, ipac, autosave, | caPutLog
#asyn, devIocStats, sscan
#busy, ipUnidac, calc, std
#mca
#areaDetector
#quadEM

# ##################################
# Updating the areaDetector
# =================================
# from directory  /epics/areadetector/
# git pull --recurse-submodules

# #########################3
# Git releases
# =======================
# git tag
# git tag -l R4-3* # Match pattern defined by -l
# git show-ref --tags -d
# git diff --name-status Release-2-6   ; difference since R-2-6
# git log origin/master..HEAD          ; unpushed changes; similar to 'hg outgoing'
# git diff origin/master..HEAD         ; Actual changes
# git log --stat origin/master..HEAD
# git log --branches --not --remotes   ; Commits not yet pushed on all branches
# git log --branches --not --remotes --simplify-by-decoration --decorate --oneline   ; most recent commit on each branch and branch name
# git checkout -b R7-7
# ***********************
# git config --global alias.ahead "log origin/master..HEAD --oneline"    ; git ahead

# ###############################
# AreaDetector recursively cloned
# ===============================
#git clone --recursive https://github.com/areaDetector/areaDetector.git
#git clone https://github.com/epics-modules/quadEM
#cd areaDetector/ADCore; git checkout R3-1; cd ../..
# ... many more modules here

# ##################################
# Updating the areaDetector
# =================================
# from directory  /epics/areadetector/
# git pull --recurse-submodules

# ##################################
# Additional synApps components
# ==================================
##darcs get http://www-csr.bessy.de/control/SoftDist/caPutLog/repo/caPutLog
#wget http://www-csr.bessy.de/control/SoftDist/caPutLog/_downloads/caPutLog-3.6.tar.gz; tar -xvzf caPutLog-3.6.tar.gz
#git clone https://github.com/epics-modules/alive

# ######################################################################
# PCIe EVR on powerBrick v.3.0.1, Biffiger Roger (Roger.Biffiger@psi.ch)
# Requires PCI VME support library devlib2
# =========================================
# git clone https://github.com/pauscherrerinstitute/mrfioc2
# git clone https://github.com/kgofron/devlib2

# ################################################
# medm is now (2017-7-15) on github.com/epics-extensions/medm
# ================================================
#git clone https://github.com/epics-extensions/medm; cd /epics/extensions/src/medm; git checkout MEDM3_1_14; 
#https://github.com/epics-extensions/medm/archive/MEDM3_1_14.tar.gz
# Need msi from https://epics.anl.gov/extensions/msi/

# ######################################
# EPICS 7 base is cheeky, since submodules need to be pulled into 
# epics-base/modules/[ca,database,libcom,normativeTypes,pvData,pvDatabase,pva2pva,pvaClient]
# https://epics.anl.gov/base/R7-0/index.php
# ================================
#git clone -b core/master https://git.launchpad.net/epics-base base-7.0
#cd base-7.0
#git submodule update --init --reference ./
