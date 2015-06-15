# This file sets the environment variables for the packaging project.
# It MUST be source'd at the start of each of the scripts

# where to send email notifications to?
export RS_NOTIFY_EMAIL=release-team@lists.adiscon.com

# which key to use for signing the package?
# TODO: we need to find a better way to do this
# the keys must be used by
# - all members of the packaing project
# - the rs_infra user for the daily cron jobs
# - it must be automatically obtained during a cron run, this is
#   currently (badly?) solved by an empty passphrase
export PACKAGE_SIGNING_KEY_ID=C2751450

# do NOT make any changes past this point
export PKG_CONFIG_PATH=$INFRAHOME/local/lib/pkgconfig
