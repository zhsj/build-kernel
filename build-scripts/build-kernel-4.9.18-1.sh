##############################################
# only works for linux-4.9.18-1              #
#                                            #
# build result store in /repo                #
# run as root                                #
# provide ~/x509.genkey                      #
#         ~/signing_key_extra.x509           #
#         ~/config.patch                     #
##############################################


echo "deb http://mirrors.ustc.edu.cn/debian stretch main" > /etc/apt/sources.list
echo "deb-src http://mirrors.ustc.edu.cn/debian stretch main" >> /etc/apt/sources.list

apt-get update && apt-get -y upgrade

apt-get -y install linux-source && apt-get -y build-dep linux && apt-get -y install openssl

cd ~
tar xf /usr/src/linux-source-4.9.tar.xz
xzcat /usr/src/linux-config-4.9/config.amd64_none_amd64.xz > ~/linux-source-4.9/.config

cd linux-source-4.9

# add signing module config
patch < ~/config-4.patch

cp ~/x509.genkey ./certs

cp ~/signing_key_extra.x509 ./certs

make -j8 deb-pkg LOCALVERSION=-ustclugsigned DEBFULLNAME="Shengjing Zhu" \
	DEBEMAIL=zsj950618@gmail.com
