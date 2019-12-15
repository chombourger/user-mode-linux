#!/bin/sh -euf
set -x

if [ ! -e /usr/bin/git ]; then
    dnf -y install git-core
fi

if [ ! -e /usr/bin/wget ]; then
    dnf -y install wget
fi

git fetch --unshallow || :

COMMIT=$(git rev-parse HEAD)
COMMIT_SHORT=$(git rev-parse --short=8 HEAD)
COMMIT_NUM=$(git rev-list HEAD --count)
COMMIT_DATE=$(date +%s)


sed "s,#COMMIT#,${COMMIT},;
     s,#SHORTCOMMIT#,${COMMIT_SHORT},;
     s,#COMMITNUM#,${COMMIT_NUM},;
     s,#COMMITDATE#,${COMMIT_DATE}," \
         contrib/spec/seine-uml.spec.in > contrib/spec/seine-uml.spec

mkdir -p build/
git archive --prefix "seine-uml-${COMMIT_SHORT}/" --format "tar.gz" HEAD -o "build/seine-uml-${COMMIT_SHORT}.tar.gz"
cd build
wget -c https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.18.tar.xz
