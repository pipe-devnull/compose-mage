#! /bin/bash
# set -ex

# This script will perform a self install


# WORKSPACE = the directory of the magento module?
#$TEST_BASEDIR
#${BUILDENV}

if [ -z "$TEST_BASEDIR" ]; then echo "No $TEST_BASEDIR found"; exit 1; fi

function cleanup {
  if [ -z "$SKIP_CLEANUP" ]; then
    echo "Removing build directory ${BUILDENV}"
    rm -rf "${BUILDENV}"
  fi
}

function check_vars {
    if [ -z "$MAGEDB_DBHOST" ]; then
     echo "ENV vars missing"
     exit
  fi   
}

trap cleanup EXIT

# check if this is a travis environment
if [ ! -z "$TRAVIS_BUILD_DIR" ] ; then WORKSPACE=$TRAVIS_BUILD_DIR; fi

if [ -z $WORKSPACE ] ; then echo "No workspace configured, please set your WORKSPACE environment"; exit 1; fi

BUILDENV=$(mktemp -d /tmp/mageteststand.XXXXXXXX)

echo "Using build directory ${BUILDENV}"

mkdir builddir
cd builddir
# Get the rest of this repo
#curl -sL https://github.com/pipedevnull/magento-base-project/archive/master.tar.gz | tar zx -C "${BUILDENV}" --strip-components 1
curl -sL https://github.com/pipedevnull/magento-base-project/get/master.tar.gz | tar zx -C . --strip-components 1

# Copy the actual test subject into .modman folder
# cp -rf "${WORKSPACE}" "${BUILDENV}/.modman/"

# Install Magento
./install.sh

if [ -d "${WORKSPACE}/vendor" ] ; then
  cp -rf ${WORKSPACE}/vendor/* "${BUILDENV}/vendor/"
fi

# Run the tests
if [ ! -d "${TEST_BASEDIR}" ] ; then
    pwd
    echo "Could not find test dir ${TEST_BASEDIR}"
fi

cd "${TEST_BASEDIR}"
${BUILDENV}/tools/phpunit.phar --colors -d display_errors=1 --debug