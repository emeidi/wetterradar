#!/bin/sh

CONVERT=`which convert`
#QUALITY=85
QUALITY=50

MENCODER=`which mencoder`
FRAMERATE=20

AVI2MP4="avi2mp4.sh"

DATUM=`date +%Y-%m-%d`
UHRZEIT=`date +%H-%M`
#DATADIR="/multimedia/Swap/Radar/$DATUM/"
DATADIR="/var/www/apps/radar/data/$DATUM/"

if [ ! -d $DATADIR ]
then
	mkdir $DATADIR
fi

if [ ! -d "$DATADIR/iphone" ]
then
	mkdir "$DATADIR/iphone"
fi

#wget -T 5 --referer "http://www.nzz.ch/wetter/radar_grossbild_aktuell.html" -U "Mozilla/5.001 (windows; U; NT4.0; en-us) Gecko/25250101" -q -O "$DATADIR$UHRZEIT.gif" http://www.nzz.ch/images/radar_gross_1.168.

IMG="$DATADIR$UHRZEIT.gif"

wget -T 5 --referer "http://www.meteoschweiz.admin.ch/web/de/wetter/aktuelles_wetter/radarbild.html" -U "Mozilla/5.001 (windows; U; NT4.0; en-us) Gecko/25250101" -q -O "$IMG" http://www.meteoschweiz.admin.ch/web/de/wetter/aktuelles_wetter/radarbild.Par.0005.Data.img_1.gif

if [ ! -f "$IMG" ];
then
	echo "File $IMG not found"
	exit 1
fi

# Convert to JPEG
$CONVERT -quality $QUALITY "$IMG" "$DATADIR$UHRZEIT.jpg"
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
