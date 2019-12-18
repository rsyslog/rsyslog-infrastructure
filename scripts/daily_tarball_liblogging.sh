#! /bin/bash
# Copyright (C) 2015 by Rainer Gerhards. Released under ASL 2.0
source $RSI_SCRIPTS/config.sh

cd $INFRAHOME/repo/liblogging
git checkout -f master
git checkout master
if [ $? -ne 0 ]; then
    git checkout -f master |& mutt -s "liblogging tarball: git checkout failed!" $RS_NOTIFY_EMAIL
    exit 1
fi
git pull
if [ $? -ne 0 ]; then
    git pull |& mutt -s "liblogging tarball: git pull failed!" $RS_NOTIFY_EMAIL
    exit 1
fi

# we need to rename the version
rm *.tar.gz
sed s/\\.master\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`\]/ < configure.ac > configure.ac.new
mv configure.ac.new configure.ac

autoreconf -fvi && ./configure --prefix=$INFRAHOME/local --disable-man-pages --disable-journal && make || exit $?

echo trying make dist
rm -rf *.tar.gz
make dist
if [ $? -ne 0 ]; then
    make dist |& mutt -s "liblogging tarball: make dist failed" $RS_NOTIFY_EMAIL
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
#scp -p $TARFILE download.rsyslog.com:/home/adisconweb/www/wordpress-mu/wp-content/blogs.dir/11/files/download/rsyslog/liblogging-daily.tar.gz


# also install on local machine for testbench runs
#sudo make install

# reset version number changes
git checkout -f master
