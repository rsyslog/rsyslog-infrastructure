#! /bin/bash
echo check buildenv
source $RSI_SCRIPTS/config.sh

cd $INFRAHOME/repo/rsyslog
make distclean
echo pre checkout
git checkout -f master
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

# we need to rename the version
rm *.tar.gz
sed s/\\.master\]/\\.`git log --pretty=format:'%H' -n 1|cut -c 1-12`\]/ < configure.ac > configure.ac.new
mv configure.ac.new configure.ac
echo pre configure
rsyslog_configure.sh
echo trying make dist
rm -rf *.tar.gz
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
git checkout -f master
