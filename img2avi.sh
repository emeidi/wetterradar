#!/bin/sh

SCRIPTROOT=`dirname $0`

MENCODER=`which mencoder`
IMAGEEXTENSION="jpg"
FRAMERATE=20
VCODEC="mpeg4"
VBITRATE="1800"

CONFIG="$SCRIPTROOT/wetterradar.cfg"
if [ -f "$CONFIG" ]
then
	echo "Sourcing configuration from '$CONFIG'"
	source $CONFIG
fi

if [ $# -lt 1 ]
then
	echo "Usage: $0 <directory>"
	exit 1
fi

WORKINGDIR="$1"

if [ ! -d "$WORKINGDIR" ]
then
	echo "Error: Directory '$WORKINGDIR' not acccessible"
	exit 1
fi

if [ ! -x "$MENCODER" ]
then
	echo "Error: mencoder executable not found ($MENCODER)"
	exit 1
fi

echo "Switching to directory '$WORKINGDIR'"
cd "$WORKINGDIR"

AVIMOVIE="movie.avi"

echo "Encoding all JPEG files present in directory '$WORKINGDIR' into an avimovie"
$MENCODER "mf://*.$IMAGEEXTENSION" -really-quiet -mf fps=$FRAMERATE -o "$AVIMOVIE" -ovc lavc -lavcopts vcodec=$VCODEC:vbitrate=$VBITRATE 2>/dev/null

exit 0
