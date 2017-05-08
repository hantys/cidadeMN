FROM ruby:2.4

MAINTAINER pedro fausto <pedro.fausto@hotmail.com>

# Used aptitude

RUN apt-get update -qq

RUN apt-get install -y build-essential libpq-dev aptitude optipng pngquant jpegoptim ntp ufw htop imagemagick nodejs git libmagickwand-dev openssl python-software-properties

# make the "pt_BR.UTF-8" locale so postgres will be utf-8 enabled by default
RUN aptitude update \
  && aptitude install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

ENV app /app
RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /box

ADD . $app

CMD rails s -b 0.0.0.0