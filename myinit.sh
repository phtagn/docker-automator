#!/sbin/openrc-run
FFMPEG=`which ffmpeg` && \
FFPROBE=`which ffprobe` && \

start()
{
if [ ! -f /config/autoProcess.ini ]; then
	cp /automator/autoProcess.ini.sample /config/autoProcess.ini
	sed -i -e 's,ffmpeg =.*,ffmpeg = '"${FFMPEG}", /config/autoProcess.ini
	sed -i -e 's,ffprobe =.*,ffprobe = '"${FFPROBE}", /config/autoProcess.ini
	ln -sf /config/autoProcess.ini /automator/autoProcess.ini
fi
ln -sf /automator/info.log /config/log
}