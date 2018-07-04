#!/bin/bash

# specify path used for setting EASYBUILD_PREFIX
#PREFIX=$HOME/easybuild

#specify path used for setting EASYBUILD_INSTALLPATH
#INSTALL_PATH=$HOME/easybuild

#specify full path to Easybuild Source files (i.e $EASYBUILD_SOURCEPATH)
#SOURCE_PATH=$HOME/easybuild/sources

# To get the year using date. You may set this manually if this makes more sense
YEAR=$(date +"%Y")

# Path to easyconfig repo
#easybuild_easyconfig=<path>
#easybuild_easyconfig=/lustre/workspace/home/siddis14/easybuild-easyconfigs/easybuild/easyconfigs

source ${PWD}/eb-generic.sh
echo $@,
if [[ "$1" == "commons" ]]; then
    destination="$YEAR/commons"
else
    destination="$YEAR/$ARCHITECTURE/$OPERATING_SYSTEM/$OPERATING_SYSTEM_RELEASE"
fi

easybuild_prefix=$PREFIX/${destination}
easybuild_sourcepath=$SOURCE_PATH
easybuild_installpath=$INSTALL_PATH/${destination}
easybuild_tmpdir=$easybuild_prefix/tmp

if [ ! -d $easybuild_prefix ]; then
    echo "Did not find \$EASYBUILD_PREFIX directory $easybuild_prefix will automatically create it"
    mkdir -pv $easybuild_prefix
else
    echo "Directory: $easybuild_prefix found!"
fi


if [ ! -d $easybuild_sourcepath ]; then
    echo "Did not find \$EASYBUILD_SOURCEPATH directory $easybuild_sourcepath will automatically create it"
    mkdir -pv $easybuild_sourcepath
else
    echo "Directory: $easybuild_sourcepath found!"
fi

if [ ! -d $easybuild_tmpdir ]; then
    echo "Did not find \$EASYBUILD_TMPDIR directory $easybuild_tmpdir will automatically create it"
    mkdir -pv $easybuild_tmpdir
else
    echo "Directory: $easybuild_tmpdir found!"
fi

if [ ! -d $easybuild_installpath ]; then 
    echo "Did not find \$EASYBUILD_INSTALLPATH directory $easybuild_installpath will automatically create it"
    mkdir -pv $easybuild_installpath
else
    echo "Directory: $easybuild_installpath found!"
fi

if [ ! -d $easybuild_easyconfig ]; then
    echo "Did not find easybuild-easyconfig repo for $USER at $easybuild_easyconfig, please clone this repo before building apps"
else
    echo "Directory: $easybuild_easyconfig repo for $USER found!"
fi


module load EasyBuild

export EASYBUILD_PREFIX=$easybuild_prefix
export EASYBUILD_SOURCEPATH=$easybuild_sourcepath
export EASYBUILD_INSTALLPATH=$easybuild_installpath
export EASYBUILD_ROBOT_PATHS=$easybuild_easyconfigs
export EASYBUILD_TMPDIR=$easybuild_tmpdir

export EASYBUILD_MODULE_SYNTAX="Lua"
export EASYBUILD_MODULE_NAMING_SCHEME="EasyBuildMNS"
