#!/bin/bash


function get_os_distro()
{
    # OPERATING_SYSTEM release and Service pack discovery
    local lsb_dist=$(lsb_release -si 2>&1 | tr '[:upper:]' '[:lower:]' | tr -d '[[:space:]]')
    local dist_version=$(lsb_release -sr 2>&1 | tr '[:upper:]' '[:lower:]' | tr -d '[[:space:]]')
    # Special case redhatenterpriseserver
    if [[ "${lsb_dist}" == "redhatenterpriseserver" ]]; then
        lsb_dist='redhat'
    fi
    if [[ "${lsb_dist}" == "suselinux" || "${lsb_dist}" == "opensuseproject" ]]; then
        lsb_dist='suse'
    fi
    if [[ -z "${lsb_dist}" ]]; then
        lsb_dist=$(uname -s)
    else
        export OPERATING_SYSTEM_RELEASE=${dist_version}
    fi
    export OPERATING_SYSTEM=$lsb_dist
}

function architecture_identification()
{
    local cpudec=$(lscpu | grep "Model:" | gawk '{print $2}')
    local cpuhex=$(printf '%x' $cpudec)
    cpuhex=${cpuhex^^}
    local architecture=$(grep $cpuhex $(pwd)/cpu-id-map.conf | gawk '{print $2}')
    if [ -z $architecture ]; then
        echo "Your CPU model with code ${cpuhex} is not recognised."
        echo "Consider to include this CPU code in the following file: $(pwd)/cpu-id-map.conf"

    else
        export ARCHITECTURE=$architecture
    fi

} 

get_os_distro
architecture_identification

YEAR=$(date +"%Y")

# set INSTALL_PATH same as defined in eb-source.sh
#INSTALL_PATH=

module use $INSTALL_PATH/$YEAR/$ARCHITECTURE/$OPERATING_SYSTEM/$OPERATING_SYSTEM_RELEASE/modules/all
module use $INSTALL_PATH/$YEAR/commons/modules/all
