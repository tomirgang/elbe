#!/usr/bin/make -f

MOD_PATH=`pwd`/debian/tmp/lib/modules/${k_version}
FW_PATH=`pwd`/debian/tmp/lib/firmware
HDR_PATH=`pwd`/debian/tmp/usr
KERNEL_PATH=`pwd`/debian/tmp/boot

MAKE_OPTS= \
ARCH=${k_arch} \
CROSS_COMPILE=${cross_compile} \
KERNELRELEASE=${k_name}-${k_version} \
LOADADDR=${loadaddr} \
INSTALL_MOD_PATH=$(MOD_PATH) \
INSTALL_FW_PATH=$(FW_PATH) \
INSTALL_HDR_PATH=$(HDR_PATH) \
INSTALL_PATH=$(KERNEL_PATH) \
O=debian/build

#export DH_VERBOSE=1

override_dh_auto_clean:
	mkdir -p debian/build
	rm -f debian/files
	rm -rf debian/tmp
	make $(MAKE_OPTS) clean

override_dh_auto_configure:
	mkdir -p debian/build
	make $(MAKE_OPTS) ${defconfig}

override_dh_auto_build:
	rmdir include/config
	make $(MAKE_OPTS) ${imgtype} modules

override_dh_auto_install:
	mkdir -p $(MOD_PATH) $(FW_PATH) $(HDR_PATH) $(KERNEL_PATH)
	make $(MAKE_OPTS) install
	make $(MAKE_OPTS) modules_install
	make $(MAKE_OPTS) firmware_install
	make $(MAKE_OPTS) headers_install

%%:
	dh $@
