#! /bin/bash
echo check buildenv
source $RSI_SCRIPTS/config.sh

# Support custom branch
GITBRANCH=${1:-"main"}
echo Get DAILY TARBALL for RSYSLOG branch $GITBRANCH

CUSTOMBUILD=${2:-""}

# Prepend an underscore if CUSTOMBUILD is not empty
if [ -n "$CUSTOMBUILD" ]; then
    CUSTOMBUILD="_$CUSTOMBUILD"
fi
echo CUSTOMBUILD if any: $CUSTOMBUILD

cd $INFRAHOME/repo/rsyslog
git reset --hard
git pull --all

echo pre checkout branch $GITBRANCH
git checkout -f $GITBRANCH
if [ $? -ne 0 ]; then
    git pull |& mutt -s "rsyslog tarball: git checkout failed!" $RS_NOTIFY_EMAIL
    exit 1
fi
echo pre pull
git pull
if [ $? -ne 0 ]; then
    git pull |& mutt -s "rsyslog tarball: git pull failed!" $RS_NOTIFY_EMAIL
    exit 1
fi

# rm existing archives
rm *.tar.gz

#autoreconf -vfi
#./configure

# we need to rename the version
sed -i s/\\.daily\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`$CUSTOMBUILD\]/g configure.ac

# We need to add tar-ustar to AM_INIT_AUTOMAKE! Fixed error with "tar: file name is too long (max 99)"
sed -i 's/AM_INIT_AUTOMAKE(\[subdir-objects\])/AM_INIT_AUTOMAKE([subdir-objects 1.9 tar-ustar])/g' configure.ac

echo pre configure
$RSI_SCRIPTS/rsyslog_configure.sh

# work-around fix permissions
# TODO: how to handle script abort? Any way to avoid this work-around here?
chmod -R g+w .
chgrp -R infrastructure .
# end work-around

echo trying make dist
rm -rf *.tar.gz

# Separate clean and dist and use Verbose output
make clean
make dist V=1
#make distclean
make dist
if [ $? -ne 0 ]; then
    make dist |& mutt -s "rsyslog tarball: make dist failed" $RS_NOTIFY_EMAIL
    exit 1
fi
#
# now update tarball on rsyslog.com
TARFILE=`ls *.tar.gz`
echo tarfile for upload: $TARFILE
# TODO: we need to copy this file inside the local file system once we
# know where this will be
#scp -p $TARFILE download.rsyslog.com:/home/adisconweb/www/wordpress-mu/wp-content/blogs.dir/11/files/download/rsyslog/rsyslog-daily.tar.gz

# reset version number changes
git checkout -f $GITBRANCH
