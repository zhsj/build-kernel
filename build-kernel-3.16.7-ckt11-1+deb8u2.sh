##############################################
# only works for linux-3.16.7-ckt11-1+deb8u2 #
#                                            #
# build result store in /repo                #
# run as root                                #
# provide ~/gpgkey, ~/aptly.conf             #
#         ~/builddeb.patch                   #
##############################################


sed -i 's/httpredir\.debian\.org/mirrors\.ustc\.edu\.cn/g' /etc/apt/sources.list
sed -i 's/security\.debian\.org/mirrors\.ustc\.edu\.cn\/debian-security/g' /etc/apt/sources.list
echo "deb-src http://mirrors.ustc.edu.cn/debian jessie main" >> /etc/apt/sources.list
echo "deb-src http://mirrors.ustc.edu.cn/debian-security jessie/updates main" >> /etc/apt/sources.list

apt-get update && apt-get -y upgrade

apt-get -y install linux-source && apt-get -y build-dep linux && apt-get -y install openssl gnupg aptly

cd ~
tar xf /usr/src/linux-source-3.16.tar.xz
xzcat /usr/src/linux-config-3.16/config.amd64_none_amd64.xz > ~/linux-source-3.16/.config

cd linux-source-3.16

# to fix script/packags/builddeb
patch -p1 < ~/builddeb.patch

# add signing module config
patch -p1 -l << "EOF"
--- linux-source-3.16-org/.config       2015-07-05 08:15:00.013292933 +0000
+++ linux-source-3.16/.config   2015-07-05 06:53:47.433453612 +0000
@@ -224,7 +224,7 @@
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
-# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
+CONFIG_SYSTEM_TRUSTED_KEYRING=y
 CONFIG_PROFILING=y
 CONFIG_TRACEPOINTS=y
 CONFIG_OPROFILE=m
@@ -296,7 +296,19 @@
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 # CONFIG_MODULE_SRCVERSION_ALL is not set
-# CONFIG_MODULE_SIG is not set
+CONFIG_MODULE_SIG=y
+CONFIG_MODULE_SIG_FORCE=y
+# CONFIG_MODULE_SIG_ALL is not set
+
+#
+# Do not forget to sign required modules with scripts/sign-file
+#
+# CONFIG_MODULE_SIG_SHA1 is not set
+# CONFIG_MODULE_SIG_SHA224 is not set
+# CONFIG_MODULE_SIG_SHA256 is not set
+# CONFIG_MODULE_SIG_SHA384 is not set
+CONFIG_MODULE_SIG_SHA512=y
+CONFIG_MODULE_SIG_HASH="sha512"
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 CONFIG_BLK_DEV_BSG=y
@@ -350,6 +362,7 @@
 CONFIG_DEFAULT_IOSCHED="cfq"
 CONFIG_PREEMPT_NOTIFIERS=y
 CONFIG_PADATA=y
+CONFIG_ASN1=y
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
 CONFIG_INLINE_READ_UNLOCK=y
 CONFIG_INLINE_READ_UNLOCK_IRQ=y
@@ -6640,7 +6653,7 @@
 CONFIG_CRYPTO_SHA256_SSSE3=m
 CONFIG_CRYPTO_SHA512_SSSE3=m
 CONFIG_CRYPTO_SHA256=m
-CONFIG_CRYPTO_SHA512=m
+CONFIG_CRYPTO_SHA512=y
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
@@ -6698,6 +6711,7 @@
 CONFIG_CRYPTO_USER_API=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
+CONFIG_CRYPTO_HASH_INFO=y
 CONFIG_CRYPTO_HW=y
 CONFIG_CRYPTO_DEV_PADLOCK=m
 CONFIG_CRYPTO_DEV_PADLOCK_AES=m
@@ -6705,7 +6719,10 @@
 CONFIG_CRYPTO_DEV_CCP=y
 CONFIG_CRYPTO_DEV_CCP_DD=m
 CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
-# CONFIG_ASYMMETRIC_KEY_TYPE is not set
+CONFIG_ASYMMETRIC_KEY_TYPE=y
+CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
+CONFIG_PUBLIC_KEY_ALGO_RSA=y
+CONFIG_X509_CERTIFICATE_PARSER=y
 CONFIG_HAVE_KVM=y
 CONFIG_HAVE_KVM_IRQCHIP=y
 CONFIG_HAVE_KVM_IRQFD=y
@@ -6799,9 +6816,11 @@
 CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
 CONFIG_LRU_CACHE=m
 CONFIG_AVERAGE=y
+CONFIG_CLZ_TAB=y
 CONFIG_CORDIC=m
 # CONFIG_DDR is not set
-CONFIG_OID_REGISTRY=m
+CONFIG_MPILIB=y
+CONFIG_OID_REGISTRY=y
 CONFIG_UCS2_STRING=y
 CONFIG_FONT_SUPPORT=y
 # CONFIG_FONTS is not set
EOF

make -j8 deb-pkg LOCALVERSION=-ustclugsigned DEBFULLNAME="Shengjing Zhu" \
	DEBEMAIL=zsj950618@gmail.com

mkdir -p /repo/debs
mv ~/*.deb /repo/debs/

# to add gpg private key
gpg --import ~/gpgkey

mkdir -p /repo/aptly
cp ~/aptly.conf ~/.aptly.conf
aptly repo create -architectures="amd64" -distribution="jessie" linux-ustclugsigned
aptly repo add linux-ustclugsigned /repo/debs
aptly snapshot create linux-3.16.7-ckt11-1+deb8u2 from repo linux-ustclugsigned
aptly publish snapshot linux-3.16.7-ckt11-1+deb8u2

