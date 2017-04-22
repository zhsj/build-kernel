# Build Linux Kernel
FROM debian:stretch

MAINTAINER SJ Zhu <zsj950618@gmail.com>

#volume
VOLUME ["/repo"]

ADD current-build.sh misc/* secrets/* patch/* /root/

CMD /root/current-build.sh
