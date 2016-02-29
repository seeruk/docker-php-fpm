FROM ubuntu:trusty
MAINTAINER Elliot Wright <elliot@elliotwright.co>

# Change me!
ENV DOCKER_HOST 192.168.0.1

# Install PHP
RUN \
    useradd -u 1000 -m -s /bin/bash php && \
    mkdir -p /opt/www && \
    chown -R php: /opt/www && \
    apt-get update && \
    apt-get install -y language-pack-en-base software-properties-common && \
    LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php5-5.6 && \
    apt-get update && \
    apt-get install -y \
        php5 php5-cli php5-common php5-curl php5-dev php5-fpm php5-gd php5-imagick php5-json \
        php5-mcrypt php5-memcached php5-mysql php5-xdebug && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure PHP
RUN \
    sed -i 's/user\ =\ www-data/user\ =\ php/g' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/group\ =\ www-data/group\ =\ php/g' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/listen.owner\ =\ www-data/listen.owner\ =\ php/g' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/listen.group\ =\ www-data/listen.group\ =\ php/g' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/listen\ =\ \/var\/run\/php5-fpm\.sock/listen\ =\ [::]:9000/g' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/;daemonize\ =\ yes/daemonize\ =\ no/g' /etc/php5/fpm/php-fpm.conf && \
    echo "zend_extension = xdebug.so" >> /etc/php5/mods-available/xdebug.ini.template && \
    echo "xdebug.remote_enable = on" >> /etc/php5/mods-available/xdebug.ini.template && \
    echo "xdebug.remote_connect_back = on" >> /etc/php5/mods-available/xdebug.ini.template && \
    echo "xdebug.idekey = \"docker\"" >> /etc/php5/mods-available/xdebug.ini.template

EXPOSE 9000

CMD /bin/bash -c "envsubst < /etc/php5/mods-available/xdebug.ini.template > /etc/php5/mods-available/xdebug.ini && /usr/sbin/php5-fpm"
