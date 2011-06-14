#!/bin/sh

CONVERT=`which convert`
MENCODER=`which mencoder`
WGET=`which wget`

SCRIPTROOT=`dirname $0`

CONFIG="$SCRIPTROOT/wetterradar.cfg"
if [ ! -f "$CONFIG" ]
then
	echo "Config file '$CONFIG' missing"
	exit 1
fi

# Import configuration settings like storage path etc.
source $CONFIG

if [ ! -d $DATADIR ]
then
	mkdir -p $DATADIR
fi

if [ ! -d "$DATADIR/iphone" ]
then
	mkdir -p "$DATADIR/iphone"
fi

IMG="$DATADIR$UHRZEIT.gif"

$WGET -T 5 --referer "http://www.meteoschweiz.admin.ch/web/de/wetter/aktuelles_wetter/radarbild.html" -U "Mozilla/5.001 (windows; U; NT4.0; en-us) Gecko/25250101" -q -O "$IMG" http://www.meteoschweiz.admin.ch/web/de/wetter/aktuelles_wetter/radarbild.Par.0005.Data.img_1.gif

if [ ! -f "$IMG" ];
then
	echo "File $IMG not found"
	exit 1
fi

# Convert to JPEG
$CONVERT -quality $JPEGQUALITY "$IMG" "$DATADIR$UHRZEIT.jpg"
$CONVERT -quality 5 -rotate 90 "$IMG" "$DATADIR/iphone/$UHRZEIT.jpg"

# Create Movie
cd "$DATADIR"
AVIMOVIE="$DATADIR$DATUM.avi"
rm -f "$AVIMOVIE"
$MENCODER "mf://*.jpg" -really-quiet -mf fps=$FRAMERATE -o "$AVIMOVIE" -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1800 2>/dev/null

#Debug
#$MENCODER "mf://*.jpg" -really-quiet -mf fps=$FRAMERATE -o "$AVIMOVIE" -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1800

if [ ! -f "$AVIMOVIE" ];
then
	echo "File $AVIMOVIE not found"
	exit 1
fi

MP4MOVIE="$DATADIR/iphone/$DATUM.mp4"
$AVI2MP4 "$AVIMOVIE" "$MP4MOVIE" 2>/dev/null

# Debug
#$AVI2MP4 "$AVIMOVIE" "$MP4MOVIE"

if [ ! -f "$MP4MOVIE" ];
then
        echo "File $MP4MOVIE not found"
        exit 1
fi

exit 0
