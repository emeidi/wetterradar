#!/bin/sh

if [ $# -lt 1 ]
then
	echo "Usage: $0 <directory>"
	exit 1
fi

# Default settings are used when no configuration file is present
DEBUG=0
MENCODER=`which mencoder`
IMAGEEXTENSION="jpg"
FRAMERATE=20
VCODEC="mpeg4"
VBITRATE=1800

AVIMOVIE="movie.avi"
if [ $# -eq 2 ]
then
	AVIMOVIE="$2.avi"
	[ $DEBUG -eq 1 ] && echo "Using custom set video name '$AVIMOVIE'"
fi

SCRIPTROOT=`dirname $0`
CONFIG="$SCRIPTROOT/wetterradar.cfg"
if [ -f "$CONFIG" ]
then
	[ $DEBUG -eq 1 ] && echo "Sourcing configuration from '$CONFIG'"
	source $CONFIG
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

[ $DEBUG -eq 1 ] && echo "Switching to directory '$WORKINGDIR'"
cd "$WORKINGDIR"

[ $DEBUG -eq 1 ] && echo "Encoding all *.$IMAGEEXTENSION files present in directory '$WORKINGDIR' into an avi movie"
$MENCODER "mf://*.$IMAGEEXTENSION" -really-quiet -mf fps=$FRAMERATE -o "$AVIMOVIE" -ovc lavc -lavcopts vcodec=$VCODEC:vbitrate=$VBITRATE 2>/dev/null

exit 0
