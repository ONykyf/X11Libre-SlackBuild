# X11Libre-SlackBuild
Slackware-current X11 build tree modified to build XLibre

You can run x11libre.SlackBuild to rebuild (and by default to upgrade, if UPGRADE_PACKAGE=no is not set) the entire X packages set, which will be found in /tmp/x11-build. This takes a while to complete, but the dependencies will be certainly satisfied. If Your Slackware is too outdated, it may take two passes (very unlikely, but libSM, libXaw, libXaw3d and libXt needed a second pass to build on one of my boxes). If Your system is more or less up-to-date, You can try to recompile only X servers and drivers. In the latter case just run (keeping the default UPGRADE_PACKAGE=always)

./x11libre.SlackBuild xlibre-server

./x11libre.SlackBuild xlibre-driver

./x11libre.SlackBuild xlibre-server

XOrg and XLibre sources initially were as of Slackware-current and github.com/X11Libre on 01.07.2025. Source files are constantly updated, and You can do it yourself. In case of eventual problems after Your modifications You will find a *.patch_failed, *.configure_failed, or *.make_failed file instead of a built package. Please report issues at this page or at the link below, and we'll do our best to fix them as soon as possible.

You can find more detailed instructions at https://github.com/orgs/X11Libre/discussions/217 and/or ask for help at https://github.com/orgs/X11Libre/discussions/categories/xlibre-on-slackware-linux (feel free to start a new discussion in this category if the existing ones do not meet Your needs).
