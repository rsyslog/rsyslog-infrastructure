#! /bin/bash
source $RSI_SCRIPTS/config.sh

# we need to call different files for the subprojects. These are
# mostly identical, but have important small differences. At a later
# stage, we may want to unify this.
#$RSI_SCRIPTS/daily_tarball_libestr.sh
$RSI_SCRIPTS/daily_tarball_liblogging.sh
exit 1
liblognorm_daily_tarball.sh
librelp_daily_tarball.sh
rsyslog_daily_tarball.sh
#$INFRAHOME/scripts/auto_daily.sh
