# Build Linux Kernel
# Version 3.16.7-ckt11-1+deb8u2
FROM debian:jessie

MAINTAINER SJ Zhu <zsj950618@gmail.com>

#volume
VOLUME ["/repo"]

ADD build-scripts current-build.sh secrets/* patch/* aptly.conf /root/

CMD /root/current-build.sh
