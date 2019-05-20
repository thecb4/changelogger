#!/bin/bash
#
# name:
#   install.sh
#
# description:
#   Install Changelogger to /usr/local
#
#     - /usr/local/bin/changelogger
#
# parameters:
#   - 1: install location

PREFIX=${PREFIX:-${1:-/usr/local}}
BASE_DIR=$(cd `dirname $0`; pwd)

#cp -r $BASE_DIR/share "${PREFIX}"
cp -r $BASE_DIR/bin "${PREFIX}"
