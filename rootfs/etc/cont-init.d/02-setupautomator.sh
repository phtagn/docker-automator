#!/usr/bin/with-contenv bash
FFMPEG=`which ffmpeg`
FFPROBE=`which ffprobe`

if [ ! -f /config/autoProcess.ini ]; then
	cp /automator/autoProcess.ini.sample /config/autoProcess.ini
	sed -i -e 's,ffmpeg =.*,ffmpeg = '"${FFMPEG}", /config/autoProcess.ini
	sed -i -e 's,ffprobe =.*,ffprobe = '"${FFPROBE}", /config/autoProcess.ini
fi
ln -sf /config/autoProcess.ini /automator/autoProcess.ini

if [ ! -f /config/info.log ]; then
    touch /automator/info.log
    ln -sf /automator/info.log /config/log
fi

chown abc:abc -R /config
chown abc:abc -R /automator