apt-get install git && apt-get build-dep zfs-linux spl-linux

git clone git://anonscm.debian.org/pkg-zfsonlinux/zfs.git
git clone git://anonscm.debian.org/pkg-zfsonlinux/spl.git

dpkg -i linux-headers-3.16.36-ustclugsigned+deb8u2_3.16.36-ustclugsigned+deb8u2-1_amd64.deb

export KVERS=3.16.36-ustclugsigned+deb8u2
export KSRC=/usr/src/linux-headers-3.16.36-ustclugsigned+deb8u2

export SPLOBJ=$(pwd)/spl

export SIGNFILE=/usr/src/linux-headers-3.16.36-ustclugsigned+deb8u2/scripts/sign-file
export HASH=sha512
export KEY=/build/signing_key_extra.priv
export CERT=/build/signing_key_extra.x509

cd spl
patch -p1 < add-spl-sign.patch
./debian/rules override_dh_binary-modules

cd zfs
patch -p1 < add-zfs-sign.patch
./debian/rules override_dh_binary-modules
