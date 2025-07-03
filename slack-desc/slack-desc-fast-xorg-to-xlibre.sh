#/bin/bash

for foo in xf86-* ; do
    NAME=`echo $foo | cut -f 2-3 -d -`
    cat $foo | sed "s|xf86-$NAME|xlibre-$NAME|g" \
             | sed "s|http://www.x.org|https://github.com/X11Libre|g" \
             | sed "s| For more information about the X.Org Foundation (the providers of the||g" \
             | sed "s| X.Org implementation of the X Window System), see their website:| Homepage:|g" \
             | sed "s/|-----/  |-----/" > xlibre-$NAME
done
