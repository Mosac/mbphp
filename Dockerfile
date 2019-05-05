FROM php:7.0.33-apache

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
  libxslt-dev \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/cron.daily/*

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear

RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
  && docker-php-ext-install opcache imap intl mbstring mcrypt mysqli pdo_mysql zip bz2 calendar exif ftp gd gettext pcntl shmop sockets sysvmsg sysvsem sysvshm wddx xsl  \
  && docker-php-ext-enable opcache redis imap intl mbstring mcrypt mysqli pdo_mysql zip bz2 calendar exif ftp gd gettext pcntl shmop sockets sysvmsg sysvsem sysvshm wddx xsl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
