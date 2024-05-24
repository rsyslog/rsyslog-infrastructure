#! /bin/bash
# Copyright (C) 2015 by Rainer Gerhards. Released under ASL 2.0
source $RSI_SCRIPTS/config.sh

# Support custom branch
GITBRANCH=${1:-"master"}
echo Get DAILY TARBALL for RSYSLOG branch $GITBRANCH

cd $INFRAHOME/repo/librelp
git reset --hard
git pull --all

echo pre checkout
make distclean
git checkout -f $GITBRANCH
if [ $? -ne 0 ]; then
    git checkout master |& mutt -s "librelp tarball: git checkout failed!" $RS_NOTIY_EMAIL
    exit 1
fi
echo pre pull
git pull
if [ $? -ne 0 ]; then
    git pull |& mutt -s "librelp tarball: git pull failed!" $RS_NOTIFY_EMAIL
    exit 1
fi

# we need to rename the version
rm *.tar.gz
sed s/\\.master\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`\]/ < configure.ac > configure.ac.new
mv configure.ac.new configure.ac

autoreconf -fvi && ./configure --prefix=$INFRAHOME/local && make || exit $?

echo trying make dist
rm -rf *.tar.gz
make dist
if [ $? -ne 0 ]; then
    make dist |& mutt -s "librelp tarball: make dist failed" $RS_NOTIFY_EMAIL
    exit 1
fi

# work-around fix permissions
# TODO: how to handle script abort? Any way to avoid this work-around here?
chmod -R g+w .
chgrp -R infrastructure .

# install in our local build environment
make install

# now update tarball on rsyslog
TARFILE=`ls *.tar.gz`
echo tarfile for upload: $TARFILE
# TODO: we need to copy this file inside the local file system once we
# know where this will be
#scp -p $TARFILE download.rsyslog.com:/home/adisconweb/www/wordpress-mu/wp-content/blogs.dir/11/files/download/rsyslog/librelp-daily.tar.gz

# reset version number changes
git checkout -f $GITBRANCH
