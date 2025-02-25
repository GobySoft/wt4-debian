#!/bin/bash

echo -e "$GPG_KEY" | gpg --import

cd ${SOURCE_WORKING_DIRECTORY} &&
    mk-build-deps -a ${TARGET_ARCH} --host-arch ${TARGET_ARCH} --build-arch ${BUILD_ARCH} -t "apt-get -y --no-install-recommends -o Debug::pkgProblemResolver=yes" -i "debian/control" &&
    rm -f ${SOURCE_WORKING_DIRECTORY}/*-build-deps*.*

cd ${SOURCE_WORKING_DIRECTORY} &&
    export DPKG_BUILDPACKAGE_BUILD_TYPE="-B"
# default is to do source and binary build
[[ "${DO_SOURCE_BUILD}" == "true" ]] && DPKG_BUILDPACKAGE_BUILD_TYPE=""        
CONFIG_SITE=/etc/dpkg-cross/cross-config.${TARGET_ARCH} && dpkg-buildpackage -k19478082E2F8D3FE -a${TARGET_ARCH} ${DPKG_BUILDPACKAGE_BUILD_TYPE}
