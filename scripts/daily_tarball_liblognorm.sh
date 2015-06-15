#! /bin/bash
source $RSI_SCRIPTS/config.sh 

cd $INFRAHOME/repo/liblognorm
make distclean
git pull
git checkout -f master
if [ $? -ne 0 ]; then
    git checkout master |& mutt -s "liblognorm tarball: git checkout failed!" $RS_NOTIFY_EMAIL
    exit 1
fi
git pull
if [ $? -ne 0 ]; then
    git pull |& mutt -s "liblognorm tarball: git pull failed!" $RS_NOTIFY_EMAIL 
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
    make dist |& mutt -s "liblognorm tarball: make dist failed" $RS_NOTIFY_EMAIL 
    exit 1
fi

# install in our local build environment
make install

# now update tarball on rsyslog
TARFILE=`ls *.tar.gz`
echo tarfile for upload: $TARFILE
# TODO: we need to copy this file inside the local file system once we
# know where this will be
#scp -p $TARFILE download.rsyslog.com:/home/adisconweb/www/wordpress-mu/wp-content/blogs.dir/11/files/download/rsyslog/liblognorm-daily.tar.gz

# reset version number changes
git checkout -f master
