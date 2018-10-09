############################################################
# Dockerfile to build Nextcloud FPM Image
# based on Original nextcloud Image
############################################################
# Container nextcloud
############################################################

# Set the base Image
#FROM nextcloud:latest
#FROM nextcloud:11.0.2-fpm
#FROM nextcloud:11.0.5-fpm
#FROM nextcloud:12.0.3-fpm
#FROM nextcloud:13.0.4-fpm
FROM nextcloud:13.0.6-fpm-alpine
#FROM nextcloud:14.0.1-fpm-alpine

# File Author / Maintainer
MAINTAINER Sven Berger

# Software hinzufügen
RUN mkdir -p /usr/share/man/man1 \
    && apk -U upgrade && apk add -t \
        supervisor \
        ffmpeg \
        libmagickwand-dev \
        libgmp3-dev \
        libc-client-dev \
        libkrb5-dev \
        smbclient \
        libsmbclient-dev \
        php-oauth

# RUN php5enmod oauth

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && ln -s "/usr/include/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)/gmp.h" /usr/include/gmp.h

RUN docker-php-ext-install bz2 gmp imap

RUN pecl install imagick smbclient \
    && docker-php-ext-enable imagick smbclient

RUN pecl install oauth \
    && docker-php-ext-enable oauth

RUN mkdir /var/log/supervisord /var/run/supervisord

COPY scripte/supervisord.conf /etc/supervisor/supervisord.conf

# Apt Speicher leeren um das Image zu verkleinern
RUN rm -rf /var/lib/apt/lists/*


CMD ["/usr/bin/supervisord"]
