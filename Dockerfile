FROM php:5.6-apache

LABEL maintainer="Mosac"

RUN apt-get update && apt-get install --no-install-recommends -y \
  cron \
  m4 \
  git \
  wget \
  libc-client-dev \
  libicu-dev \
  libkrb5-dev \
  libmcrypt-dev \
  libssl-dev \
  unzip \
  zip \
  bzip2 \
  libbz2-dev \
  libpng-dev \
  imagemagick \
  libmagickwand-dev \
  libxslt-dev \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/cron.daily/*

RUN pecl install imagick

RUN mkdir -p /usr/src/php/ext \
  && cd /usr/src/php/ext \
  && git clone --depth 1 https://github.com/Connehito/phpredis.git redis \
  && docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
  && docker-php-ext-install imap intl mbstring mcrypt mysqli pdo_mysql zip bz2 calendar exif ftp gd gettext pcntl shmop sockets sysvmsg sysvsem sysvshm wddx xsl redis \
  && docker-php-ext-enable imap intl mbstring mcrypt mysqli pdo_mysql zip bz2 calendar exif ftp gd gettext pcntl shmop sockets sysvmsg sysvsem sysvshm wddx xsl redis

RUN docker-php-ext-configure opcache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
