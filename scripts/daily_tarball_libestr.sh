#! /bin/bash
# Copyright (C) 2015 by Rainer Gerhards. Released under ASL 2.0
source $RSI_SCRIPTS/config.sh

# Support custom branch
GITBRANCH=${1:-"master"}
echo Get DAILY TARBALL for RSYSLOG branch $GITBRANCH

cd $INFRAHOME/repo/libestr
git reset --hard
git pull --all

echo pre checkout
git checkout -f $GITBRANCH
if [ $? -ne 0 ]; then
    git checkout master |& mutt -s "libestr tarball: git checkout failed!" $RS_NOTIFY_EMAIL
    exit 1
fi
echo pre pull
git pull
if [ $? -ne 0 ]; then
    git pull |& mutt -s "libestr tarball: git pull failed!" $RS_NOTIFY_EMAIL
    exit 1
fi

# we need to rename the version
rm *.tar.gz

# we need to rename the version
sed s/\\.master\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`\]/ < configure.ac > configure.ac.new
sed s/\\.master\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`'~'`date +%Y%m%d%H%M%S`\]/ < configure.ac > configure.ac.new
mv configure.ac.new configure.ac

autoreconf -fvi && ./configure --prefix=$INFRAHOME/local && make || exit $?

echo trying make dist
rm -rf *.tar.gz

# Separate clean and dist and use Verbose output
make clean
make dist V=1
#make distclean

make dist
if [ $? -ne 0 ]; then
    make dist |& mutt -s "libestr tarball: make dist failed" $RS_NOTIFY_EMAIL
    exit 1
fi

# work-around fix permissions
# TODO: how to handle script abort? Any way to avoid this work-around here?
chmod -R g+w .
chgrp -R infrastructure .

# install in our local build enviroment
make install

# now update downloadable tarball
TARFILE=`ls *.tar.gz`
echo tarfile for upload: $TARFILE
# TODO: we need to copy this file inside the local file system once we
# know where this will be
#scp -p $TARFILE download.rsyslog.com:/home/adisconweb/www/wordpress-mu/wp-content/blogs.dir/11/files/download/rsyslog/libestr-daily.tar.gz

# reset version number changes
git checkout -f $GITBRANCH
