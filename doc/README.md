Getting Started
===============
The getting started guide assumes a default file system layout.

* set INFRAHOME and RSI_SCRIPTS environment variables in 
  users .bashrc for those that need it (at least rs_infra user)
* install git
* create rs_infra user & related groups
* cd into it's home directory and change permissions
  chgrp infrastructure .; chmod g+w .;chmod g+s .
* clone this repository:
  mkdir repo;cd repo;git clone https://github.com/rsyslog/rsyslog-infrastructure.git;cd rsyslog-infrastructure
* you are now inside rsyslog-infrastructure, run initial setup:
  scripts/initial_setup.sh
  follow the script's instructions

Remember to setup git correctly for each user that needs to commit.
Among others, set the identity:

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

basic machine setup
===================

File System Layout
------------------
/home
  /user_n        each team member
  /rs_infra      shared dir for all projects
    /repo        git clone of all project repos
       /rsyslog 
       ...
    /local       local build environment (for configure --prefix)

Special accounts
----------------
rs_infra        infrastructure owner, used for cron jobs


Groups
------
infrastructure  has access to rs_infra

Environment Variables
---------------------
The following variables MUST be set for each user in .bashrc because
they set "anchor points" for the rest of the system. If not set,
scripts will FAIL!

INFRAHOME       home directory for the infrastructure
RSI_SCRIPTS     directory with the infrastructure scripts
                usually $INFRAHOME/repo/rsyslog-infrastructure/scripts

Config Parameters
-----------------
Set them by modifying $INFRAHOME/repo/rsyslog-infrastructure/scripts
That file contains instructions on what the parameters mean.

Important notes on repo base directories
---------------------------------------
* at any time, only a single tarball must exists inside the repository
* the tarball inside the repo MUST match the installed version in 
  ./local

Current Scripts
---------------
The current scripts base on Adiscon's internal scripts. As such, they
are generalized and need to be enhanced for the team effort. Everything
is currently done on Ubuntu 22.04LTS, so package names apply to
that platform, only.

They require the following prequisites:

sudo apt-get install mutt devscripts debhelper dh-autoreconf cdbs

Daily Builds and/or custom launchpad reposities package builds
--------------------------------------------------------------
Run *./scripts/daily_builds.sh* to build all libraries and rsyslog from current
master branches and publish to launchpad.
the default build settings.

Run *./scripts/daily_builds_project.sh rsyslog* to build only one project
from *master* branch and publish to default launchpad repository.

Run *./scripts/daily_builds_project.sh rsyslog experimental* to build only one project
from *master* branch and publish to *experimental* launchpad repository.

Run *./scripts/daily_builds_project.sh rsyslog experimental v8-stable* to build only one project
from *master* branch, use the *v8-stable* debian files and
publish to *experimental* launchpad repository.

Run *./scripts/daily_builds_project.sh rsyslog experimental/experimental v8-stable*
to build only one project from *experimental* branch, use the *v8-stable* debian files and
publish to *experimental* launchpad repository.

Run *./scripts/daily_builds_project.sh rsyslog experimental/experimental v8-stable 20240516150808*
to build only one project from *experimental* branch, use the *v8-stable* debian files and
publish to *experimental* launchpad repository and overwritting the Debian version number from
changelog with *20240516150808*. This is only needed for package developing.

Build all libraries and rsyslog for a custom laucnhpad repository:
./scripts/daily_builds_project.sh libestr experimental v8-stable
./scripts/daily_builds_project.sh liblogging experimental v8-stable
./scripts/daily_builds_project.sh liblognorm experimental v8-stable
./scripts/daily_builds_project.sh libfastjson experimental v8-stable
./scripts/daily_builds_project.sh librelp experimental v8-stable
./scripts/daily_builds_project.sh rsyslog experimental/experimental v8-stable
