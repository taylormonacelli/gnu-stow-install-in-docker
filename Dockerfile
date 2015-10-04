# https://github.com/phusion/baseimage-docker#getting_started

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.17
MAINTAINER Taylor Monacelli <taylormonacelli@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get -qq update
RUN apt-get -y -qq install curl make

ENV STOWVERSION 2.1.3

RUN mkdir -p /usr/local/src && \
	cd /usr/local/src && \
	curl -O http://ftp.gnu.org/gnu/stow/stow-${STOWVERSION}.tar.gz && \
	tar xvf stow-${STOWVERSION}.tar.gz && \
	cd stow-${STOWVERSION}

RUN \
	mkdir -p /usr/local/stow && \
	cd /usr/local/src/stow-${STOWVERSION} && \
	./configure --prefix=/usr/local/stow/stow-${STOWVERSION}; \
	make install && \
	/usr/local/stow/stow-${STOWVERSION}/bin/stow --version && \
	cd /usr/local/stow && /usr/local/stow/stow-${STOWVERSION}/bin/stow stow-${STOWVERSION}

RUN cd ~ && stow --version

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && apt-get autoremove
