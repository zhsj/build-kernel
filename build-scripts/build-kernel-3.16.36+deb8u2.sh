##############################################
# only works for linux-3.16.7-ckt11-1+deb8u2 #
#                                            #
# build result store in /repo                #
# run as root                                #
# provide ~/x509.genkey                      #
#         ~/signing_key_extra.x509           #
#         ~/builddeb.patch                   #
#         ~/config.patch                     #
##############################################


sed -i 's/httpredir\.debian\.org/mirrors\.ustc\.edu\.cn/g' /etc/apt/sources.list
sed -i 's/security\.debian\.org/mirrors\.ustc\.edu\.cn\/debian-security/g' /etc/apt/sources.list
echo "deb-src http://mirrors.ustc.edu.cn/debian jessie main" >> /etc/apt/sources.list
echo "deb-src http://mirrors.ustc.edu.cn/debian-security jessie/updates main" >> /etc/apt/sources.list

apt-get update && apt-get -y upgrade

apt-get -y install linux-source && apt-get -y build-dep linux && apt-get -y install openssl

cd ~
tar xf /usr/src/linux-source-3.16.tar.xz
xzcat /usr/src/linux-config-3.16/config.amd64_none_amd64.xz > ~/linux-source-3.16/.config

cd linux-source-3.16

# to fix script/packags/builddeb
patch -p1 < ~/builddeb.patch

# add signing module config
patch < ~/config.patch

cp ~/x509.genkey .

cp ~/signing_key_extra.x509 .

make -j8 deb-pkg LOCALVERSION=-ustclugsigned+deb8u2 DEBFULLNAME="Shengjing Zhu" \
	DEBEMAIL=zsj950618@gmail.com
