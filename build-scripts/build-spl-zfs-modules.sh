apt-get install git && apt-get build-dep zfs-linux spl-linux

git clone git://anonscm.debian.org/pkg-zfsonlinux/zfs.git
git clone git://anonscm.debian.org/pkg-zfsonlinux/spl.git

dpkg -i linux-headers-4.9.18-ustclugsigned_4.9.18-ustclugsigned-3_amd64.deb

export KVERS=4.9.18-ustclugsigned
export KSRC=/usr/src/linux-headers-$KVERS

export SPLOBJ=$(pwd)/spl
export SPL=$(pwd)/spl

export SIGNFILE=$KSRC/scripts/sign-file
export HASH=sha512
export KEY=/root/signing_key_extra.priv
export CERT=/root/signing_key_extra.x509

cd spl
patch -p1 < add-spl-sign.patch
patch -p1 < spl-postinst.patch
./debian/rules override_dh_binary-modules

cd zfs
patch -p1 < add-zfs-sign.patch
patch -p1 < zfs-postinst.patch
./debian/rules override_dh_binary-modules
