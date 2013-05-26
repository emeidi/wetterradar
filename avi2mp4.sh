#!/bin/sh

FFMPEG=`which ffmpeg`

#$FFMPEG -y -i "$1" -b 768000 -s 320x240 -vcodec libxvid -ab 128 -acodec aac -ac 2 -ab 64 -f mp4 "$2"
#$FFMPEG -flags +loop -y -i "$1" -b 200000 -s 320x240 -vcodec libxvid -an -f mp4 "$2"

# On Debian Squeeze
#$FFMPEG -flags +loop -y -i "$1" -b 200000 -s 320x240 -vcodec mpeg4 -vtag xvid -an -f mp4 "$2"
#$FFMPEG -flags +loop -y -i "$1" -b 200000 -s 320x240 -vcodec mpeg4 -an -f mp4 "$2"
#$FFMPEG -flags +loop -y -i "$1" -b 200000 -s 640x480 -vcodec libx264 -an -f mp4 "$2"
$FFMPEG -i "$1" -vcodec libx264 -b 2000000 -preset slow "$2"

exit 0
