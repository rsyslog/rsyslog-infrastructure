#! /bin/bash
source $RSI_SCRIPTS/config.sh

# Set commandline args for auto_daily
PROJECTS=${1:-"libestr liblogging libfastjson liblognorm librelp rsyslog"}
PPAREPO=${2:-"daily-stable"}
PPABRANCH=${3:-"v8-stable"}

# we need to call different files for the subprojects. These are
# mostly identical, but have important small differences. At a later
# stage, we may want to unify this.
# $RSI_SCRIPTS/daily_tarball_libgt.sh
# $RSI_SCRIPTS/daily_tarball_libksi.sh
$RSI_SCRIPTS/daily_tarball_libestr.sh
$RSI_SCRIPTS/daily_tarball_liblogging.sh
$RSI_SCRIPTS/daily_tarball_liblognorm.sh
$RSI_SCRIPTS/daily_tarball_libfastjson.sh
$RSI_SCRIPTS/daily_tarball_librelp.sh
$RSI_SCRIPTS/daily_tarball_rsyslog.sh

# initiate package build
$INFRAHOME/repo/rsyslog-pkg-ubuntu/scripts/auto_daily.sh $PROJECTS $PPAREPO $PPABRANCH

