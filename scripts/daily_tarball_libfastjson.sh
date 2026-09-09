#! /bin/bash
# Copyright (C) 2015 by Rainer Gerhards. Released under ASL 2.0
source $RSI_SCRIPTS/config.sh

set -e

# Support custom branch
GITBRANCH=${1:-"main"}
echo "Get DAILY TARBALL for libfastjson branch $GITBRANCH"

cd $INFRAHOME/repo/libfastjson
git reset --hard
git pull --all

git checkout -f $GITBRANCH || {
    git checkout main 2>&1 | mutt -s "libfastjson tarball: git checkout failed!" $RS_NOTIFY_EMAIL
    exit 1
}
git pull || {
    git pull 2>&1 | mutt -s "libfastjson tarball: git pull failed!" $RS_NOTIFY_EMAIL
    exit 1
}

# Remove any old tarballs (use -f to avoid error when none exist)
rm -f *.tar.gz

# Stamp version with git short hash
COMMIT_HASH=$(git log --pretty=format:'%H' -n 1 | cut -c 1-12)
sed "s/\\.master\]/\\.${COMMIT_HASH}\]/" configure.ac > configure.ac.new
mv configure.ac.new configure.ac

# Build (library must remain built for make dist - tests/distdir needs libfastjson.la)
autoreconf -fvi
./configure --prefix=$INFRAHOME/local
make

# Create tarball - do NOT run make clean first; distdir in tests/ needs libfastjson.la
echo "Running make dist..."
make dist V=1 2>&1 | tee /tmp/libfastjson_dist.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    mutt -s "libfastjson tarball: make dist failed" $RS_NOTIFY_EMAIL < /tmp/libfastjson_dist.log
    exit 1
fi

# Fix permissions for shared workspace
chmod -R g+w .
chgrp -R infrastructure .

# Install in our local build environment
make install

TARFILE=$(ls *.tar.gz 2>/dev/null | head -1)
echo "Tarball for upload: $TARFILE"

# Reset configure.ac to clean state
git checkout -f $GITBRANCH
