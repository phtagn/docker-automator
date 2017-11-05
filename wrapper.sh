#!/bin/sh
# This is a wrapper for the docker container created using the docker file
# The variables need to be modified to your needs
# LOCALFOLDER is the folder on the host computer that is mounted in the docker container
# CONTAINERFOLDER is the name of the volume inside the docker container
CONTAINER='automator'
LOCALFOLDER='/Volumes/Downloads'
CONTAINERFOLDER='/downloads'
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

if test "${THEPATH#*$LOCALFOLDER}" != "$THEPATH"; then
	REWRITTEN="$(echo $THEPATH | sed 's,'${LOCALFOLDER}','${CONTAINERFOLDER},)"
	docker exec -it ${CONTAINER} manual.py -c $CONFIG $OTHER -i $REWRITTEN
else
	exit 1
fi