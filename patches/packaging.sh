#!/bin/sh
IFS=''
release=$(make kernelrelease)
export INSTALL_PATH=./${release}/boot
export INSTALL_MOD_PATH=./${release}

mkdir -p ${release}/boot
make modules_install install

rm -r ${release}/boot/vmlinux-${release}
rm -r ${release}/lib/modules/${release}/build
rm -r ${release}/lib/modules/${release}/source
cp COPYING ${release}

tar -cf - ${release} |
  xz $( [ $((LOONGSON_PATCH_LOGGING)) -ne 0 ] && printf %s -v) --lzma2=preset=9e,nice=273 - > linux-${release}.tar.xz
rm -rf ${release}

gpg -o linux-${release}.tar.xz.sig -ab linux-${release}.tar.xz
