## General overview
This container pulls and builds the latest stable version of ffmpeg and dependencies, from git repos when available and relevant. This part is *heavily* inspired by [jrottenberg's docker files on ffmpeg](https://github.com/jrottenberg/ffmpeg).
The container will also pull [sickbeard_mp4_automator from mdhiggins](https://github.com/mdhiggins/sickbeard_mp4_automator), with the necessary python dependencies.
The container sets up a watchfolder, and will convert any mkv files put in there. The watchfolder is configured through the environment variable.
Any mkv added to the folder will be transformed into an mp4 file using the defaults in /config/autoProcess.ini.


The container exposes the following volumes :
* /config, which contains autoProcess.ini, the main configuration file for sickbeard_mp4_automator
* /downloads, for convenience
* /videos, for convenience.

## Usage

docker run -e WATCHFOLDER=/PATH-TO-WATCHFODLER -v PATH-TO-CONFIG-DIR:/config -v PATH-TO-DOWNLOADS-DIR:/downloads -v PATH-TO-VIDEO-DIR:/videos -d --name automator phtagn/docker_mp4_automator 