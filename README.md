# Kernel with Signed Module Build on Debian

It aims to build a kernel for Debian that supports module signature verification.

# Kernel build history

* debian jessie 3.16.7-ckt11-1

# What it does

1. Download the linux source in Debian.

2. Build with config from Debian and sig support added.

3. publish with aptly

# Notice

It will automatically destroy the key which signs the modules.

It means you can't add other modules anymore. If you need to
add new modules, rebuild it. Or you can retrieve the key before the
docker container is destroyed. But take your own risk.
