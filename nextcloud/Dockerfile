############################################################
# Dockerfile to build Nextcloud FPM Image
# based on Original nextcloud Image
############################################################
# Container nextcloud
############################################################

# Set the base Image
#FROM nextcloud:fpm
#FROM nextcloud:11.0.2
#FROM nextcloud:11.0.5
#FROM nextcloud:12.0.3
#FROM nextcloud:13.0.4
FROM nextcloud:14.0.1

# File Author / Maintainer
MAINTAINER Sven Berger

# Software hinzufügen
RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y \
        supervisor \
        ffmpeg \
        libmagickwand-dev \
        libgmp3-dev \
        libc-client-dev \
        libkrb5-dev \
        smbclient \
        libsmbclient-dev

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


ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
