Getting Started
===============

* install git
* create rs_infra user & related groups
* cd into it's home directory and change permissions
  chgrp infrastructure .; chmod g+w .;chmod g+s .
* clone this repository:
  mkdir repo;cd repo;git clone https://github.com/rsyslog/rsyslog-infrastructure.git;cd rsyslog-infrastructure
* you are now inside rsyslog-infrastructure, run initial setup:
  ./initial_setup.sh

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
