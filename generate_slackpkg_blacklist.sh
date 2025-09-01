#!/bin/sh
#
# Generates the list of packages to blacklist so that slackpkg doesn't touch
# them.

# Exit on errors.
set -e

X11_BUILD_DIR=${X11_BUILD_DIR:-/tmp/x11-build}
BLACKLIST_FILE=${PWD}/blacklist

if [ ! -e ${X11_BUILD_DIR} ]; then
  echo "Build directory not found: please build the packages first."
  exit 1
fi

find ${X11_BUILD_DIR} -name "*.t?z" \
  | sed -E -e "s/-[0-9]+\.[0-9]+\.[0-9].+//" \
           -e "s/-[0-9]+\.[0-9].+//" \
           -e "s/xisxwayland.+/xiswayland/" \
  | sort \
  | xargs -I _ basename _ > ${BLACKLIST_FILE}

echo "Generated blacklist file to ${BLACKLIST_FILE}"
