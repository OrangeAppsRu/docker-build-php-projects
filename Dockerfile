FROM ubuntu:16.04
MAINTAINER Dmitry Sergeev <identw@gmail.com>
ENV DEBIAN_FRONTEND noninteractive 
# Set user for build cocos
RUN useradd -u 1001 user
RUN apt-get update && \
    apt-get install -y \
        openjdk-8-jre \
        openjdk-8-jdk \
        curl \
        unzip \
        zip \
        php-cli \
        php-curl \
        php-mysql \
        php-mbstring \
        php-json && \
    rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean

# Npm
RUN apt-get update && curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean

RUN /usr/bin/npm install -g \
    less@2.7.3 \
    uglify-js@3.3.15

# Php
RUN php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');" && \ 
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    sed -i 's@short_open_tag = Off@short_open_tag = On@g' /etc/php/7.0/cli/php.ini

USER user
WORKDIR /app
ENV PROCESSES=2
ENTRYPOINT ["/usr/bin/php"]
