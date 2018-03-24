#!/usr/bin/with-contenv bash

if [ ! -f /config/removetoredoconf ]; then
    echo "First time set-up of automator"
    PUID=${PUID:-911}
    PGID=${PGID:-911}
    echo "PUID set to $PUID"
    echo "PGID set to $PGID"

    groupmod -o -g "$PGID" abc
    usermod -o -u "$PUID" abc
    git clone -b ${GITBRANCH} ${GITSERVER} /automator

    FFMPEG=`which ffmpeg`
    FFPROBE=`which ffprobe`

    if [ ! -f /config/autoProcess.ini ]; then
        cp /automator/autoProcess.ini.sample /config/autoProcess.ini
        sed -i -e 's,ffmpeg =.*,ffmpeg = '"${FFMPEG}", /config/autoProcess.ini
        sed -i -e 's,ffprobe =.*,ffprobe = '"${FFPROBE}", /config/autoProcess.ini
    fi

    ln -sf /config/autoProcess.ini /automator/autoProcess.ini
    mkdir -p /var/log/server
    mkdir -p /var/log/watchfolder
    chown nobody:nogroup /var/log/watchfolder
    chown nobody:nogroup /var/log/server
    chown abc:abc -R /config
    chown abc:abc -R /automator
    touch /config/removetoredoconf
fi