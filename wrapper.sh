#!/bin/sh
# This is a wrapper for the docker container created using the docker file
# The variables need to be modified to your needs
# LOCALFOLDER is the folder on the host computer that is mounted in the docker container
# CONTAINERFOLDER is the name of the volume inside the docker container
CONTAINER='automator'
LOCALDL='/Volumes/Downloads'
LOCALVIDEOS='/Volumes/video'

CONTAINERDL='/downloads'
CONTAINERVIDEOS='/videos'
CONFIG='/config/autoProcess.ini'

while test $# -gt 0 ;do
        case "$1" in
                -i)
                shift
                THEPATH=$1
                shift
                ;;
                -c)
                shift
                CONFIG=$1
                shift
                ;;
                *)
                OTHER="$OTHER $1"
                shift
                ;;
        esac
        if test $# -eq 0 ; then
                break
        fi
done

if test "${THEPATH#*$LOCALDL}" != "$THEPATH"; then
	REWRITTEN="$(echo $THEPATH | sed 's,'${LOCALDL}','${CONTAINERDL},)"
elif test "${THEPATH#*$LOCALVIDEOS}" != "$THEPATH"; then
	REWRITTEN="$(echo $THEPATH | sed 's,'${LOCALVIDEOS}','${CONTAINERVIDEOS},)"
fi
echo docker exec -it ${CONTAINER} manual.py -c $CONFIG $OTHER -i $REWRITTEN