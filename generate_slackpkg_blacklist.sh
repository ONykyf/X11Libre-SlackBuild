#!/bin/sh
#
# Generates the list of packages to blacklist so that slackpkg doesn't touch
# them.

# Exit on errors.
set -e

# Output directory for the built XLibre Slackware packages.
# By default it matches the one used in the SlackBuild shell script.
X11_BUILD_DIR=${X11_BUILD_DIR:-/tmp/x11-build}

# Output path for the generated blacklist file.
# By default the blacklist file named, well, "blacklist" will be generated in
# the current working directory.
#
# For example: if you are in the /home/foo/bar directory, the result blacklist
# file will be put in the /home/foo/bar/blacklist path.
BLACKLIST_FILE=${BLACKLIST_FILE:-${PWD}/blacklist}

# Check if the build directory does exist and bail out if it doesn't.
if [ ! -e ${X11_BUILD_DIR} ]; then
  echo "Build directory not found: please build the packages first."
  exit 1
fi

# Search inside the build directory all the tarballs and keep only the
# package names.
find ${X11_BUILD_DIR} -name "*.t?z" \
  | sed -E -e "s/-[0-9]+\.[0-9]+\.[0-9].+//" \
           -e "s/-[0-9]+\.[0-9].+//" \
           -e "s/xisxwayland.+/xisxwayland/" \
  | sort \
  | xargs -I _ basename _ > ${BLACKLIST_FILE}

# Print the final diagnostic message and exit.
echo "Generated blacklist file to ${BLACKLIST_FILE}"
