echo This script sets up the rsyslog infrastructure...
if [ ! -f scripts/config.sh ]; then
    echo "error: config.sh not found in scripts directory!"
    echo "check if the directory layout is correct and you are in"
    echo "the right working directory"
    exit 1
fi

source scripts/config.sh
cd $INFRAHOME/repo

echo cloning repositories
echo third-party dependencies
git clone https://github.com/rsyslog/libgt.git 
git clone https://github.com/rsyslog/libksi.git
# add others (e.g. 0mq) here

echo rsyslog util repos
git clone https://github.com/rsyslog/rsyslog-doc.git 
git clone https://github.com/rsyslog/rsyslog-pkg-ubuntu.git 

echo create file system tree
mkdir $INFRAHOME/local

echo rsyslog project dependecies
git clone https://github.com/rsyslog/libestr.git 
git clone https://github.com/rsyslog/liblognorm.git 
git clone https://github.com/rsyslog/liblogging.git 
git clone https://github.com/rsyslog/librelp.git 
git clone https://github.com/rsyslog/libfastjson.git
git clone https://github.com/rsyslog/rsyslog.git 

echo "Basic project setup is complete. Now make sure the required software is
installed on your system. See
$INFRAHOME/repo/rsyslog/README.md
for details."
