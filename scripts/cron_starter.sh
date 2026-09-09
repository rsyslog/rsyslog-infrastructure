#!/bin/bash

export INFRAHOME="/home/rs_infra"
export RSI_SCRIPTS="$INFRAHOME/repo/rsyslog-infrastructure/scripts"
export PPAREPO="daily-stable"
export PPABRANCH="v8-stable"
GITBRANCH="stable"
RSYSLOG_GITBRANCH="main"

# $RSI_SCRIPTS/daily_builds.sh [projects] [ppa] [debian-branch] [git-branch]
# Only build rsyslog daily
$RSI_SCRIPTS/daily_builds.sh libfastjson $PPAREPO $PPABRANCH $GITBRANCH
$RSI_SCRIPTS/daily_builds.sh libestr $PPAREPO $PPABRANCH $GITBRANCH
$RSI_SCRIPTS/daily_builds.sh liblogging $PPAREPO $PPABRANCH $GITBRANCH
$RSI_SCRIPTS/daily_builds.sh liblognorm $PPAREPO $PPABRANCH $GITBRANCH
$RSI_SCRIPTS/daily_builds.sh librelp $PPAREPO $PPABRANCH $GITBRANCH
$RSI_SCRIPTS/daily_builds.sh rsyslog $PPAREPO $PPABRANCH $RSYSLOG_GITBRANCH
