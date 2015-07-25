# Build Linux Kernel
# Version 3.16.7-ckt11-1
FROM debian:jessie

MAINTAINER SJ Zhu <zsj950618@gmail.com>

#volume
VOLUME ["/repo"]

ADD build-kernel-3.16.7-ckt11-1.sh secrets/* patch/* aptly.conf /root/

CMD /root/build-kernel-3.16.7-ckt11-1.sh
