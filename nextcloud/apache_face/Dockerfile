############################################################
# Dockerfile to build Nextcloud Apache Image
# based on Original nextcloud Image
############################################################
# Container nextcloud
############################################################

#
# Use a temporary image to compile and test the libraries
#
FROM nextcloud:20.0.4 as builder

# Build and install dlib on builder

RUN apt-get update ; \
    apt-get install -y build-essential wget cmake libx11-dev libopenblas-dev

ARG DLIB_BRANCH=v19.19
RUN wget -c -q https://github.com/davisking/dlib/archive/$DLIB_BRANCH.tar.gz \
    && tar xf $DLIB_BRANCH.tar.gz \
    && mv dlib-* dlib \
    && cd dlib/dlib \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON --config Release .. \
    && make \
    && make install

# Build and install PDLib on builder

ARG PDLIB_BRANCH=master
RUN apt-get install unzip
RUN wget -c -q https://github.com/matiasdelellis/pdlib/archive/$PDLIB_BRANCH.zip \
    && unzip $PDLIB_BRANCH \
    && mv pdlib-* pdlib \
    && cd pdlib \
    && phpize \
    && ./configure \
    && make \
    && make install

# Enable PDlib on builder

# If necesary take the php settings folder uncommenting the next line
# RUN php -i | grep "Scan this dir for additional .ini files"
RUN echo "extension=pdlib.so" > /usr/local/etc/php/conf.d/pdlib.ini

# Install bzip2 needed to extract models

RUN apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2

# Test PDlib instalation on builder

RUN apt-get install -y git
RUN git clone https://github.com/matiasdelellis/pdlib-min-test-suite.git \
    && cd pdlib-min-test-suite \
    && make

#
# If pass the tests, we are able to create the final image.
#

# Set the base Image
#FROM nextcloud:13.0.4
#FROM nextcloud:13.0.5
#FROM nextcloud:13.0.6
#FROM nextcloud:14.0.0
#FROM nextcloud:14.0.1
#FROM nextcloud:14.0.2
#FROM nextcloud:14.0.3
#FROM nextcloud:14.0.4
#FROM nextcloud:14.0.6
#FROM nextcloud:15.0.2
#FROM nextcloud:15.0.5
#FROM nextcloud:15.0.8
#FROM nextcloud:15.0.11
#FROM nextcloud:16.0.4
#FROM nextcloud:16.0.7
#FROM nextcloud:16.0.8
#FROM nextcloud:17.0.2
#FROM nextcloud:17.0.3
#FROM nextcloud:17.0.4
#FROM nextcloud:17.0.5
#FROM nextcloud:17.0.6
#FROM nextcloud:18.0.1
#FROM nextcloud:18.0.3
#FROM nextcloud:18.0.4
#FROM nextcloud:18.0.5
#FROM nextcloud:18.0.6
#FROM nextcloud:18.0.7
#FROM nextcloud:18.0.10
#FROM nextcloud:19.0.4
#FROM nextcloud:19.0.5
#FROM nextcloud:20.0.0
#FROM nextcloud:20.0.2
#FROM nextcloud:20.0.3
FROM nextcloud:20.0.4

#
# File Author / Maintainer
MAINTAINER Sven Berger

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libmagickcore-6.q16-3-extra \
        procps \
        smbclient \
        supervisor \
 #      libreoffice \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libgmp3-dev \
        libkrb5-dev \
        libsmbclient-dev \
        \
# Änderung für Outh (Grauphel)
        libpcre++-dev \
# Änderung für Outh (Grauphel)
        \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
#    ln -s "/usr/include/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)/gmp.h" /usr/include/gmp.h; \
    docker-php-ext-install \
        bz2 \
#        gmp \
        imap \
    ; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
    \
# Änderung für Outh (Grauphel)
    pecl install oauth; \
    docker-php-ext-enable oauth; \
# Änderung für Outh (Grauphel)
    \
    apt-mark auto '.*' > /dev/null; \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

# Install dependencies to image for FACERECOGNITION

RUN apt-get update ; \
    apt-get install -y libopenblas-base

# Install dlib and PDlib to image

COPY --from=builder /usr/local/lib/libdlib.so* /usr/local/lib

# If is necesary take the php extention folder uncommenting the next line
# RUN php -i | grep extension_dir
COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdlib.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/

# Enable PDlib on final image

RUN echo "extension=pdlib.so" > /usr/local/etc/php/conf.d/pdlib.ini

# Increse memory limits

RUN echo memory_limit=1024M > /usr/local/etc/php/conf.d/memory-limit.ini

# Pdlib is already installed, now without all build dependencies.
# You could test again if everything is correct, uncommenting the next lines
#
# RUN apt-get install -y git wget
# RUN git clone https://github.com/matiasdelellis/pdlib-min-test-suite.git \
#    && cd pdlib-min-test-suite \
#    && make

#
# At this point you meet all the dependencies to install the application
# If is available you can skip this step and install the application from the application store
#
ARG FR_BRANCH=master
RUN apt-get install -y wget unzip nodejs npm
RUN wget -c -q -O facerecognition https://github.com/matiasdelellis/facerecognition/archive/$FR_BRANCH.zip \
  && unzip facerecognition \
  && mv facerecognition-*  /usr/src/nextcloud/facerecognition \
  && cd /usr/src/nextcloud/facerecognition \
  && make

# Install dependencies to image for FACERECOGNITION






RUN mkdir -p \
    /usr/share/man/man1 \
    /var/log/supervisord \
    /var/run/supervisord \
;

COPY scripte/supervisord.conf /etc/supervisor/supervisord.conf

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord"]
