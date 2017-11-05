## General overview
This container pulls and builds the latest stable version of ffmpeg and dependencies, from git repos when available and relevant. This part is *heavily* inspired by [jrottenberg's docker files on ffmpeg](https://github.com/jrottenberg/ffmpeg).
The container will also pull [sickbeard_mp4_automator from mdhiggins](https://github.com/mdhiggins/sickbeard_mp4_automator), with the necessary python dependencies.
The container is meant to use manual.py (the manual script for converting .mkv to .mp4 in sickbeard_mp4_automator).
The container exposes the following volumes :
* /config, which contains autoProcess.ini, the main configuration file for sickbeard_mp4_automator
* /downloads, for convenience
* /videos, for convenience.

## Usage
docker run -v $MYCONFIGFOLDER:/config -v $MYFOLDER:/downloads -v $MYOTHERFOLDER:/videos -d --name automator phtagn/docker_mp4_automator
Then, you can either :
docker exec -it automator bash
or execute manual.py directly
docker exec -it automator manual.py --help (for example)

A wrapper script is also available. It calls on the container while doing path substitution so that, for example, /mnt/downloads/myfile.mkv is correctly replaced with the path inside the container e.g. /downloads/myfile.mkv