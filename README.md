# X11Libre-SlackBuild

This repository provides a Slackware X11 build tree modified to build [XLibre](https://github.com/X11Libre/xserver). The sources were imported from Slackware-current Xorg and the XLibre project on July 1, 2025 and are constantly updated.


## Prerequisites

It is assumed that you have installed the entire X packages set. Some things of it will be necessary to build XLibre, another ones will be overwritten or upgraded during XLibre install. This set is not that large, so it's safer to install it completely.

If you have a more or less recent Slackware-current, this is sufficient. Thanks to [rc-05](https://github.com/ONykyf/X11Libre-SlackBuild/issues/4#issuecomment-3220084418) it turned out that it is perfectly possible to build XLibre on a stable Slackware-15.0. All you have to do is:

- to go to [slackware-15.0 testing directory](http://slackware.uk/slackware/slackware64-15.0/testing/packages/graphics-updates/), grab `libdrm-2.4.125-x86_64-1_slack15.0.txz` and `mesa-25.0.7-x86_64-2_slack15.0.txz`, and run
```shell
upgradepkg --reinstall libdrm-2.4.125-x86_64-1_slack15.0.txz mesa-25.0.7-x86_64-2_slack15.0.txz
```
to replace `libdrm` and `mesa` with newer versions;

- to take `llvm-20.1.8-x86_64-1_slack15.0.txz` at [slackware-15.0 extra directory](http://slackware.uk/slackware/slackware64-15.0/extra/) and install it:
```shell
installpkg llvm-20.1.8-x86_64-1_slack15.0.txz
```
side-by-side with the existing older LLVM versions, for X drivers to build and function correctly.


## Preparing for Install

Before building and installing the packages, it is recommended to set the default runlevel of your system to `text mode` a.k.a. runlevel `3` instead of `graphical mode` a.k.a. `4` in the file `/etc/inittab`:

```
#id:4:initdefault:
id:3:initdefault:
```

Doing so will make your system always boot into `text mode` and gives you a nice safety margin in case the X server fails to start. After system startup and logging in as `root` user you will be able to manually switch to `graphical mode` by running `telinit 4`.

When you see that XLibre works the way you want it, you can switch the default runlevel back to `4` in `/etc/inittab`. Another possibility to work around problems with X server is to have a SSH server start up on your machine by default and remote controlling it from another computer.


## Getting the Build Files

There are two ways to obtain the build files: via downloading a ZIP archive or via Git cloning the repository.


### Downloading the ZIP Archive

You can download the [ZIP archive of this repository](https://github.com/ONykyf/X11Libre-SlackBuild/archive/refs/heads/main.zip) and extract it afterwards:

```shell
wget -O X11Libre-SlackBuild.zip https://github.com/ONykyf/X11Libre-SlackBuild/archive/refs/heads/main.zip
unzip X11Libre-SlackBuild.zip
mv X11Libre-SlackBuild-main X11Libre-SlackBuild
cd X11Libre-SlackBuild
```

Please be advised that the initial download of the ZIP archive is about 76 MB.


### Cloning the Repository

You can also clone the repository with [Git](https://git-scm.com) like so:

```shell
git clone https://github.com/ONykyf/X11Libre-SlackBuild.git
cd X11Libre-SlackBuild 
```

Using this method gives you the opportunity to later simply update the repository by running `git pull`. Please be advised that the initial download of the Git repository is about 160 MB.


## Running the SlackBuild

After downloading and changing into the main directory, just run the SlackBuild to build all the packages provided by this build tree:

```shell
./x11libre.Slackbuild
```

Grab some coffee and wait. It won't take too long to compile the entire X11 tree with XLibre instead of Xorg. By default the built packages are immediately installed and replace older versions you have on your system. As a bonus, you get the most up-to-date X libraries and applications with all dependencies satisfied.


### Building the XLibre Xserver and its Drivers Only

If your system is more or less up-to-date, you can try to recompile the X server and its drivers only:

```shell
./x11libre.SlackBuild xlibre-server
./x11libre.SlackBuild xlibre-driver
# second pass due to circular dependencies on libinput
./x11libre.SlackBuild xlibre-server
```


### Building Select Packages Only

To build select packages only you can utilize the structure of the `src` directory. If you e.g. only want to build the package `xkeyboard-config` located under `src/data` you would invoke the build with:

```shell
./x11libre.SlackBuild data xkeyboard-config
```

This applies to all the other directories and files found in `src` as well.


### Controlling the Upgrade Process

You can control how packages are upgraded as they are built via the environment variable `UPGRADE_PACKAGES`. The default is to always upgrade newly-built packages, effectively setting `UPGRADE_PACKAGES=always`. To install newly built packages only if a package with the exact name is not already installed, use `UPGRADE_PACKAGES=yes`. To not upgrade any packages when they are built, pass `UPGRADE_PACKAGES=no`.


### Logging and Debugging the Build

Although in most cases the upgrade works flawlessly, you might want to collect the configure and build logs of all packages for future reference or troubleshooting by invoking the SlackBuild like this:

```shell
./x11libre.SlackBuild 2>&1 | tee ~/X-configure-build.log
```

In the unlikely case some package `foo` fails to build, a file `foo.patch_failed`, `foo.configure_failed`, or `foo.make_failed` will appear in `/tmp/x11-build` instead of `foo.txz`.


### Known Pitfalls

If your Slackware is too outdated, you may have to build all packages via `x11libre.SlackBuild` and it may take two passes to build them. This is very unlikely, but libSM, libXaw, libXaw3d and libXt needed a second pass to build on one of my boxes.

On another rather outdated system `xkeyboard-config` failed to configure and the log revealed that `python3` lacked the module `strenum`. So I installed the missing module and reran the build:

```shell
pip3 install strenum
./x11libre.SlackBuild data xkeyboard-config
```

### Finishing the Build

After the build you will find the built packages in `/tmp/x11-build/*.txz`. Please keep them in a safe place. You may also use them to install XLibre on another computer. In the `x11-build` directory there will also be subdirectories containing source code. You may remove them if you are not curious about their contents.


## Securing the build if you are using slackpkg

To prevent _slackpkg_ package manager from accidentally downgrading the installed XLibre packages, use the provided `generate_slackpkg_blacklist.sh` script to generate a `blacklist` file and add its content to `/etc/slackpkg/blacklist`. Add `libdrm` and `mesa` to the latter file manually as well.

## Uninstalling

_Don't worry, you can go back to Xorg any time!_

Switch your default runlevel to `text mode` as [described above](#preparing-for-install), change to your safe place where you kept the `*.txz` packages and run [`removepkg`](http://www.slackware.com/config/packages.php):

```shell
cd <safe-place-of-packages>
removepkg *.txz
```

Then change into the main SlackBuild directory `X11Libre-SlackBuild`, open the file `x11libre.SlackBuild` in your text editor of choice and uncomment the line below the line `# you can build Xorg as well` and comment the second line after it containing `xlibre-server` like so:

```diff
--- x11libre.SlackBuild.orig
+++ x11libre.SlackBuild
@@ -145,9 +145,9 @@
 # before getting this script to work.  It wasn't that hard...  I think.  ;-)
 ( cd src
   # You can build Xorg as well
-  #  for x_source_dir in proto data util xcb lib app doc xserver driver font ; do
+  for x_source_dir in proto data util xcb lib app doc xserver driver font ; do
   # xlibre-server is built twice due to a circular dependency on input-libinput in xlibre-driver
-  for x_source_dir in proto data util xcb lib app doc xlibre-server xlibre-driver xlibre-server font ; do
+  #for x_source_dir in proto data util xcb lib app doc xlibre-server xlibre-driver xlibre-server font ; do
 #  for x_source_dir in xlibre-driver xlibre-server ; do
     # See if $1 is a source directory like "lib":
     if [ ! -z "$1" ]; then
```

Grab another cup of coffee and run:

```shell
./x11libre.SlackBuild
```

You will get a brand new Xorg... but what for?.


## nVidia legacy proprietary drivers

They are not included into this repository, but you can get [here](https://github.com/ONykyf/nvidia390-slackbuild) slackbuilds with sources for _nvidia390_ and _nvidia470_ drivers that work nicely with this XLibre install.


## Contact

Please report any issues to [Issues · ONykyf/X11Libre-SlackBuild](https://github.com/ONykyf/X11Libre-SlackBuild/issues). In case you need help, want to report success or talk about other aspects of the build, just go to [Welcome to XLibre on Slackware Linux! · X11Libre · Discussion #217](https://github.com/orgs/X11Libre/discussions/217).
