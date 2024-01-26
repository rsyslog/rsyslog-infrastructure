#! /bin/bash
source $RSI_SCRIPTS/config.sh

PROJECT=$1	# Samples:	libestr liblogging libfastjson liblognorm librelp rsyslog
PPAREPO=$2	# Samples:	daily-stable 
		#		experimental 
		#		experimental/experimental
PPABRANCH=$3	# Samples:	v8-stable 
		#		master
CUSTOMBUILD=$4	# Append needed for rebuilds to make unique upload files

# Check if PROJECT is set
if [ -z "$PROJECT" ]; then
    echo "Error: PROJECT is not set."
    exit 1
fi

# Check if PPAREPO is set
if [ -z "$PPAREPO" ]; then
    echo "Error: PPAREPO is not set."
    exit 1
fi

# Check if PPABRANCH is set
if [ -z "$PPABRANCH" ]; then
    echo "Error: PPABRANCH is not set."
    exit 1
fi

# Split PPAREPO into PPAREPO and GITBRANCH if it contains a slash
if [[ "$PPAREPO" == */* ]]; then
    IFS='/' read -r PPAREPO GITBRANCH <<< "$PPAREPO"
else
    GITBRANCH=""
fi

# Print the values for verification
echo "DAILY BUILD PROJECT FOR: $PROJECT"
echo "PPAREPO: $PPAREPO"
echo "GITBRANCH: $GITBRANCH"
echo "CUSTOMBUILD: $CUSTOMBUILD"

# Build Package
$RSI_SCRIPTS/daily_tarball_$PROJECT.sh $GITBRANCH $CUSTOMBUILD

#  Get tar.gz from 
cd $INFRAHOME/repo/$PROJECT
TARFILE=`ls *.tar.gz`
echo Generated TARFILE: $TARFILE

# Initiate package build
$INFRAHOME/repo/rsyslog-pkg-ubuntu/scripts/auto_daily.sh $PROJECT $PPAREPO $PPABRANCH $CUSTOMBUILD
