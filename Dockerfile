FROM alpine:latest

# Install build deps

RUN apk  add --no-cache --update libgcc libstdc++ ca-certificates libcrypto1.0 libssl1.0 libgomp expat

ARG        PKG_CONFIG_PATH=/usr/lib/pkgconfig
ARG        LD_LIBRARY_PATH=/usr/lib
ARG        PREFIX=/usr
ARG        MAKEFLAGS="-j4"

ENV        MYUSERID=1001
ENV        MYGROUPID=1001
ENV        MYLOCALTIME="Europe/Paris"

RUN apk add --no-cache --update \
	autoconf \
	automake \
	binutils \
	bzip2 \
	cmake \
	coreutils \
	file \
	g++ \
	gcc \
	gperf \
	libtool \
	make \
	python \
	openssl-dev \
	tar \
	yasm \
	zlib-dev \
	expat-dev \
	py2-pip \
	texinfo \
	diffutils \
	curl \
	mercurial

WORKDIR /tmp

# NASM
RUN \
	wget -O nasm.tar.bz2 http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2 && \
	mkdir -p nasm && \
	tar xf nasm.tar.bz2 -C nasm --strip-components 1 && \ 
	cd nasm && \
	./autogen.sh && \
	./configure --prefix=${PREFIX} && \
	make ${MAKEFLAGS} && \
	make install 

# LAME
RUN \
     DIR=/tmp/lame && \
     LAME_VERSION=3.99.5 && \
     mkdir -p ${DIR} && \
     cd ${DIR} && \
     curl -sL https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
     tar -zx --strip-components=1 && \
     ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --enable-pic --disable-frontend && \
     make ${MAKEFLAGS} && \
     make install && \
     rm -rf ${DIR}


## freetype https://www.freetype.org/
RUN  \
        FREETYPE_VERSION=2.5.5 && \
        DIR=/tmp/freetype && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO http://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz && \
        tar -zx --strip-components=1 -f freetype-${FREETYPE_VERSION}.tar.gz && \
        ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}

## libvstab https://github.com/georgmartius/vid.stab
RUN  \
        LIBVIDSTAB_VERSION=1.1.0 && \
        DIR=/tmp/vid.stab && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB_VERSION}.tar.gz &&\
        tar -zx --strip-components=1 -f v${LIBVIDSTAB_VERSION}.tar.gz && \
        cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
        make && \
        make install && \
        rm -rf ${DIR}
 
## fridibi https://www.fribidi.org/
RUN  \
        FRIBIDI_VERSION=0.19.7 && \
        DIR=/tmp/fribidi && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO http://fribidi.org/download/fribidi-${FRIBIDI_VERSION}.tar.bz2 &&\
        tar -jx --strip-components=1 -f fribidi-${FRIBIDI_VERSION}.tar.bz2 && \
        ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}

## fontconfig https://www.freedesktop.org/wiki/Software/fontconfig/
RUN  \
        FONTCONFIG_VERSION=2.12.4 && \
        DIR=/tmp/fontconfig && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.bz2 &&\
        tar -jx --strip-components=1 -f fontconfig-${FONTCONFIG_VERSION}.tar.bz2 && \
        ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}

## libass https://github.com/libass/libass
RUN  \
	LIBASS_VERSION=0.13.7 && \
        DIR=/tmp/libass && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO https://github.com/libass/libass/archive/${LIBASS_VERSION}.tar.gz &&\
        tar -zx --strip-components=1 -f ${LIBASS_VERSION}.tar.gz && \
        ./autogen.sh && \
        ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}


## openjpeg https://github.com/uclouvain/openjpeg
RUN \
        OPENJPEG_VERSION=2.1.2 && \
        DIR=/tmp/openjpeg && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sL https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
        make && \
        make install && \
        rm -rf ${DIR}

RUN apk add --no-cache --update git
### libogg https://www.xiph.org/ogg/
RUN \
        DIR=/tmp/ogg && \
	git clone https://github.com/xiph/ogg.git && \
	ls /tmp && \
        cd ${DIR} && \
        ./autogen.sh && ./configure --prefix="${PREFIX}" --enable-shared  && \
        make && \
        make install && \
        rm -rf ${DIR}

### libvorbis https://xiph.org/vorbis/
RUN \
        DIR=/tmp/vorbis && \
	git clone https://github.com/xiph/vorbis.git && \
	cd ${DIR} && \
        ./autogen.sh && ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}


### libtheora http://www.theora.org/
RUN \
        DIR=/tmp/theora && \
	git clone https://github.com/xiph/theora.git && \
        cd ${DIR} && \
        ./autogen.sh && ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}


# Opus
RUN \
	git clone https://github.com/xiph/opus && \
       	cd opus && \
	autoreconf -fiv && \
       	./configure --prefix="${PREFIX}" --enable-shared && \
       	make && \
       	make install

# xvid
RUN \
	XVID_VERSION=1.3.4 && \
        DIR=/tmp/xvid && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sLO http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz && \
        tar -zx -f xvidcore-${XVID_VERSION}.tar.gz && \
        cd xvidcore/build/generic && \
        ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${DIR}" --enable-shared --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}

# X264
RUN \
	git clone http://git.videolan.org/git/x264.git && \
	cd x264 && \
	./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
	make ${MAKEFLAGS} && \
	make install

# fdk-aac
RUN \
	git clone https://github.com/mstorsjo/fdk-aac.git fdk-aac && \
	cd fdk-aac && \
	autoreconf -fiv && \
	./configure --prefix="${PREFIX}" --enable-shared --datadir=/tmp/fdk-aac && \
	make ${MAKEFLAGS} && \
	make install

# VPX
RUN \
	git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
	cd libvpx && \
	./configure --prefix=${PREFIX} --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --disable-install-bins --disable-debug --enable-shared && \
	make ${MAKEFLAGS} && \
	make install

# x265
RUN \
	hg clone https://bitbucket.org/multicoreware/x265 && \
	cd x265/build/linux && \
	sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
	sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
	./multilib.sh && \
	 make -C 8bit install


RUN \
	OPENCOREAMR_VERSION=0.1.4 && \
    DIR=/tmp/opencore-amr && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://downloads.sf.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR} 

RUN \
	git clone https://github.com/ffmpeg/ffmpeg && \
	cd ffmpeg && \
	./configure \
	--prefix=${PREFIX} \
	--extra-cflags="-I${PREFIX}/include" \
	--extra-ldflags="-L${PREFIX}/lib" \
	--extra-libs=-ldl \
	--enable-shared \
	--disable-doc \
	--disable-debug \
	--disable-ffplay \
	--enable-gpl \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
	--enable-libass \
	--enable-libfdk-aac \
	--enable-libfreetype \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libtheora \
	--enable-libvorbis \
	--enable-libxvid \
	--enable-postproc \
	--enable-libopenjpeg \
	--enable-avresample \
	--enable-small \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libvidstab \
	--enable-version3 \
	--enable-nonfree && \
	make ${MAKEFLAGS} && \
	make install && \
	make distclean && \
	hash -r && \
	cd tools && \
	make qt-faststart && \
	cp qt-faststart ${PREFIX}/bin

RUN LD_LIBRARY_PATH=/usr/lib ffmpeg -buildconf

RUN rm -Rf /tmp/*

RUN pip install requests requests[security] requests-cache "stevedore==1.19.1" babelfish "guessit<2" "subliminal<2" qtfaststart deluge-client


RUN \
 	git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git /automator && \
 	cd /automator && cp autoProcess.ini.sample autoProcess.ini && \
	rm -Rf /tmp/*

RUN apk add openrc && \
        sed -i '/tty/d' /etc/inittab && \
		sed -i 's/#rc_sys=""/rc_sys="docker"/g' /etc/rc.conf && \
		echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
		sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
		sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \
		sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh && \
		sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
		rm -f hwclock hwdrivers modules modules-load modloop

ADD https://raw.githubusercontent.com/phtagn/docker_mp4_automator/master/Mkv2mp4%20Docker/myinit.sh /etc/init.d/myinit
ENV PATH $PATH:/automator
RUN \
	chmod +x /etc/init.d/myinit && \
	rc-update add myinit default

WORKDIR /automator
VOLUME /downloads /videos /config
ENTRYPOINT  ["/sbin/init"]