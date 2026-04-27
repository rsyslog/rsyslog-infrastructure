#! /bin/bash
source $RSI_SCRIPTS/config.sh

# Set commandline args for auto_daily
PROJECTS=${1:-"libestr liblogging libfastjson liblognorm librelp rsyslog"}
PPAREPO=${2:-"daily-stable"}
PPABRANCH=${3:-"v8-stable"}

# Return 0 if word $1 is in the space-separated list PROJECTS
project_in_list() {
	local needle=$1
	case " $PROJECTS " in
	*" $needle "*) return 0 ;;
	*) return 1 ;;
	esac
}

# we need to call different files for the subprojects. These are
# mostly identical, but have important small differences. At a later
# stage, we may want to unify this.
# $RSI_SCRIPTS/daily_tarball_libgt.sh
# $RSI_SCRIPTS/daily_tarball_libksi.sh
if project_in_list libestr; then
	$RSI_SCRIPTS/daily_tarball_libestr.sh
fi
if project_in_list liblogging; then
	$RSI_SCRIPTS/daily_tarball_liblogging.sh
fi
if project_in_list liblognorm; then
	$RSI_SCRIPTS/daily_tarball_liblognorm.sh
fi
if project_in_list libfastjson; then
	$RSI_SCRIPTS/daily_tarball_libfastjson.sh
fi
if project_in_list librelp; then
	$RSI_SCRIPTS/daily_tarball_librelp.sh
fi
if project_in_list rsyslog; then
	$RSI_SCRIPTS/daily_tarball_rsyslog.sh
fi

# initiate package build
$INFRAHOME/repo/rsyslog-pkg-ubuntu/scripts/auto_daily.sh $PROJECTS $PPAREPO $PPABRANCH
