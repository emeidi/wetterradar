Requirements
------------
*  wget
*  mencoder
*  ffmpeg

bash Scripts
------------
Install them somewhere suitable on your server — e.g. in `/usr/local/bin/wetterradar`. I advise against putting them into a directory accessible by a browser out of security reasons.

www
---
You can adjust the storage location of the images and the movies in the configuration file (wetterradar.cfg). I store the data in `/var/www/apps/radar/*`. If the parent directories don't exist, they are being created automatically.

crontab
-------
```
...
*/10 * * * *    /usr/local/bin/wetterradar/wetterradar.sh
...
```
