#!/usr/bin/with-contenv bash

if [ ${AUTOUPDATE} = true ]; then
    cd /automator
    git checkout ${GITBRANCH} && git pull
fi