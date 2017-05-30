FROM ubuntu:xenial
MAINTAINER Elliot Wright <hello@elliotdwright.com>

COPY provisioning/docker-entrypoint.sh /opt/php-setup/docker-entrypoint.sh

ENV PHP_UID 1000
ENV PHP_GID 1000
ENV PHP_HOME /home/php
ENV PHP_WORKDIR /opt/www

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git-core \
        language-pack-en-base \
        openssh-client \
        software-properties-common \
    && LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        php7.1 \
        php7.1-apcu \
        php7.1-bz2 \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-dev \
        php7.1-fpm \
        php7.1-gd \
        php7.1-intl \
        php7.1-json \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-mysql \
        php7.1-pgsql \
        php7.1-xml \
        php7.1-zip \
        php-amqp \
        php-apcu \
        php-imagick \
        php-memcache \
        php-memcached \
        php-redis \
        php-xdebug \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/php \
    && chmod +x /opt/php-setup/docker-entrypoint.sh

# Configure PHP
RUN set -x \
    && sed -i 's/user\ =\ www-data/user\ =\ php/g' /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i 's/group\ =\ www-data/group\ =\ php/g' /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i 's/listen.owner\ =\ www-data/listen.owner\ =\ php/g' /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i 's/listen.group\ =\ www-data/listen.group\ =\ php/g' /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i 's/listen\ =\ \/run\/php\/php7.1-fpm\.sock/listen\ =\ [::]:9000/g' /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i 's/;daemonize\ =\ yes/daemonize\ =\ no/g' /etc/php/7.1/fpm/php-fpm.conf \
    && echo "opcache.enable = 1" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "opcache.fast_shutdown = 1" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "opcache.interned_strings_buffer = 16" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "opcache.max_accelerated_files = 7963" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "opcache.memory_consumption = 128" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "opcache.revalidate_freq = 0" >> /etc/php/7.1/mods-available/opcache.ini \
    && echo "xdebug.remote_enable = on" >> /etc/php/7.1/mods-available/xdebug.ini \
    && echo "xdebug.remote_connect_back = on" >> /etc/php/7.1/mods-available/xdebug.ini \
    && echo "xdebug.idekey = \"docker\"" >> /etc/php/7.1/mods-available/xdebug.ini \
    && echo "xdebug.profiler_enable = 0" >> /etc/php/7.1/mods-available/xdebug.ini \
    && echo "xdebug.profiler_output_dir = /opt/www/debug" >> /etc/php/7.1/mods-available/xdebug.ini \
    && echo "xdebug.profiler_enable_trigger = 1" >> /etc/php/7.1/mods-available/xdebug.ini

EXPOSE 9000

ENTRYPOINT ["/opt/php-setup/docker-entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7.1"]