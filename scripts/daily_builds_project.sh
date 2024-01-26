#! /bin/bash
source $RSI_SCRIPTS/config.sh

PROJECT=$1	# libestr liblogging libfastjson liblognorm librelp rsyslog 
CUSTOMBUILD=$2	# Append needed for rebuilds to make unique upload files
# Build Package
$RSI_SCRIPTS/daily_tarball_$PROJECT.sh

#  Get tar.gz from 
cd $INFRAHOME/repo/$PROJECT
TARFILE=`ls *.tar.gz`
echo Generated TARFILE: $TARFILE

# Initiate package build
$INFRAHOME/repo/rsyslog-pkg-ubuntu/scripts/auto_daily.sh $PROJECT $CUSTOMBUILD
