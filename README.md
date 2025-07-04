# X11Libre-SlackBuild
Slackware-current X11 build tree modified to build X11Libre

You can run x11libre.SlackBuild to rebuild (and by default upgrade, if UPGRADE_PACKAGE=no is not set) everything. This takes a while to complete, but the dependencies will be satisfied. If Your Slackware is a bit outdated, it may took two passes (libSM, libXaw, libXaw3d and libXt failed to build during my first pass). If Your system is more or less up-to-date, You can try to recompile only X servers and drivers. In the latter case just run (keeping the default UPGRADE_PACKAGE=always)

./x11libre.SlackBuild xlibre-server

./x11libre.SlackBuild xlibre-driver

./x11libre.SlackBuild xlibre-server

X source and X11Libre drivers initially were as of Slackware-current and github.com/X11Libre on 01.07.2025. Source files will be updated, or You can do it yourself. 
