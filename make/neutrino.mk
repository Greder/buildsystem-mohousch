#
#
#
LIBSTB_HAL = libstb-hal-ddt
LIBSTB_HAL_URL = https://github.com/Duckbox-Developers/libstb-hal-ddt.git
LIBSTB_HAL_BRANCH = master
LIBSTB_HAL_PATCHES =
NEUTRINO = neutrino-ddt
NEUTRINO_URL = https://github.com/Duckbox-Developers/neutrino-ddt.git
NEUTRINO_BRANCH = master
NEUTRINO_PATCHES =
NEUTRINO_PLUGINS = neutrino-ddt-plugins
NEUTRINO_PLUGINS_URL = https://github.com/Duckbox-Developers/neutrino-ddt-plugins.git
NEUTRINO_PLUGINS_BRANCH = master
NEUTRINO_PLUGINS_PATCHES = neutrino-ddt-plugins.patch

#
# .version
#
$(TARGET_DIR)/.version:
	echo "distro=mohousch" > $@
	echo "imagename=`sed -n 's/\#define PACKAGE_NAME "//p' $(BUILD_TMP)/neutrino/config.h | sed 's/"//'`" >> $@
	echo "imageversion=`sed -n 's/\#define PACKAGE_VERSION "//p' $(BUILD_TMP)/neutrino/config.h | sed 's/"//'`" >> $@
	echo "homepage=https://github.com/Duckbox-Developers" >> $@
	echo "creator=$(MAINTAINER)" >> $@
	echo "docs=https://github.com/Duckbox-Developers" >> $@
	echo "forum=https://github.com/Duckbox-Developers/neutrino-ddt" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git log | grep "^commit" | wc -l`" >> $@

NEUTRINO_DEPS  = $(D)/bootstrap
NEUTRINO_DEPS += $(D)/e2fsprogs
NEUTRINO_DEPS += $(D)/ncurses  
NEUTRINO_DEPS += $(D)/libcurl
NEUTRINO_DEPS += $(D)/libpng 
NEUTRINO_DEPS += $(D)/libjpeg 
NEUTRINO_DEPS += $(D)/giflib 
NEUTRINO_DEPS += $(D)/freetype
NEUTRINO_DEPS += $(D)/alsa_utils 
NEUTRINO_DEPS += $(D)/ffmpeg
NEUTRINO_DEPS += $(D)/libfribidi 
NEUTRINO_DEPS += $(D)/libsigc 
NEUTRINO_DEPS += $(D)/libdvbsi 
NEUTRINO_DEPS += $(D)/pugixml 
NEUTRINO_DEPS += $(D)/libopenthreads
NEUTRINO_DEPS += $(D)/libid3tag
NEUTRINO_DEPS += $(D)/libmad
NEUTRINO_DEPS += $(D)/flac

NEUTRINO_CFLAGS       = -Wall -W -Wshadow -pipe -Os
NEUTRINO_CFLAGS      += -D__KERNEL_STRICT_NAMES
NEUTRINO_CFLAGS      += -D__STDC_FORMAT_MACROS
NEUTRINO_CFLAGS      += -D__STDC_CONSTANT_MACROS
NEUTRINO_CFLAGS      += -fno-strict-aliasing -funsigned-char -ffunction-sections -fdata-sections

NEUTRINO_CPPFLAGS     = -I$(TARGET_DIR)/usr/include
NEUTRINO_CPPFLAGS    += -I$(CROSS_DIR)/$(TARGET)/sys-root/usr/include

ifeq ($(BOXARCH), sh4)
NEUTRINO_CPPFLAGS    += -I$(KERNEL_DIR)/include
NEUTRINO_CPPFLAGS    += -I$(DRIVER_DIR)/include
NEUTRINO_CPPFLAGS    += -I$(DRIVER_DIR)/bpamem
endif

NEUTRINO_CPPFLAGS    += -ffunction-sections -fdata-sections

ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
NEUTRINO_CPPFLAGS += -I$(DRIVER_DIR)/frontcontroller/aotom_spark
endif

NEUTRINO_CONFIG_OPTS = --enable-freesatepg
NEUTRINO_CONFIG_OPTS += --enable-giflib
NEUTRINO_CONFIG_OPTS += --with-tremor
NEUTRINO_CONFIG_OPTS += --enable-ffmpegdec
#NEUTRINO_CONFIG_OPTS += --enable-pip
NEUTRINO_CONFIG_OPTS += --enable-pugixml

ifeq ($(LUA), lua)
NEUTRINO_DEPS += $(D)/lua 
NEUTRINO_DEPS += $(D)/luaexpat 
NEUTRINO_DEPS += $(D)/luacurl 
NEUTRINO_DEPS += $(D)/luasocket 
NEUTRINO_DEPS += $(D)/luafeedparser 
#NEUTRINO_DEPS += $(D)/luasoap 
NEUTRINO_DEPS += $(D)/luajson
NEUTRINO_CONFIG_OPTS += --enable-lua
endif

ifeq ($(BOXARCH), arm)
NEUTRINO_CONFIG_OPTS += --enable-reschange
endif

ifeq ($(GRAPHLCD), graphlcd)
NEUTRINO_CONFIG_OPTS += --with-graphlcd
endif

ifeq ($(LCD4LINUX), lcd4linux)
NEUTRINO_CONFIG_OPTS += --with-lcd4linux
endif

MACHINE = $(BOXTYPE)
ifeq ($(BOXARCH), arm)
MACHINE = armbox
endif
ifeq ($(BOXARCH), mips)
MACHINE = mipsbox
endif

NEUTRINO_CONFIG_OPTS += \
	--with-boxtype=$(MACHINE) \
	--with-libdir=/usr/lib \
	--with-datadir=/usr/share/tuxbox \
	--with-fontdir=/usr/share/fonts \
	--with-configdir=/var/tuxbox/config \
	--with-gamesdir=/var/tuxbox/games \
	--with-iconsdir=/usr/share/tuxbox/neutrino/icons \
	--with-iconsdir_var=/var/tuxbox/icons \
	--with-luaplugindir=/var/tuxbox/plugins \
	--with-localedir=/usr/share/tuxbox/neutrino/locale \
	--with-localedir_var=/var/tuxbox/locale \
	--with-plugindir=/var/tuxbox/plugins \
	--with-plugindir_var=/var/tuxbox/plugins \
	--with-private_httpddir=/usr/share/tuxbox/neutrino/httpd \
	--with-public_httpddir=/var/tuxbox/httpd \
	--with-themesdir=/usr/share/tuxbox/neutrino/themes \
	--with-themesdir_var=/var/tuxbox/themes \
	--with-webtvdir=/share/tuxbox/neutrino/webtv \
	--with-webtvdir_var=/var/tuxbox/plugins/webtv \
	--with-controldir=/var/tuxbox/control \
	PKG_CONFIG=$(PKG_CONFIG) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	CFLAGS="$(NEUTRINO_CFLAGS)" CXXFLAGS="$(NEUTRINO_CFLAGS)" CPPFLAGS="$(NEUTRINO_CPPFLAGS)"

#
# libstb-hal
#
$(D)/libstb-hal.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/libstb-hal
	rm -rf $(BUILD_TMP)/libstb-hal
	[ -d "$(ARCHIVE)/$(LIBSTB_HAL).git" ] && \
	(cd $(ARCHIVE)/$(LIBSTB_HAL).git; git pull;); \
	[ -d "$(ARCHIVE)/$(LIBSTB_HAL).git" ] || \
	git clone -b $(LIBSTB_HAL_BRANCH) $(LIBSTB_HAL_URL) $(ARCHIVE)/$(LIBSTB_HAL).git; \
	cp -ra $(ARCHIVE)/$(LIBSTB_HAL).git $(SOURCE_DIR)/libstb-hal;\
	set -e; cd $(SOURCE_DIR)/libstb-hal; \
		$(call apply_patches,$(LIBSTB_HAL_PATCHES))
	@touch $@

$(D)/libstb-hal.config.status: $(D)/libstb-hal.do_prepare
	rm -rf $(BUILD_TMP)/libstb-hal; \
	test -d $(BUILD_TMP)/libstb-hal || mkdir -p $(BUILD_TMP)/libstb-hal; \
	cd $(BUILD_TMP)/libstb-hal; \
		$(SOURCE_DIR)/libstb-hal/autogen.sh; \
		$(BUILDENV) \
		$(SOURCE_DIR)/libstb-hal/configure --enable-silent-rules \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr \
			--with-target=cdk \
			--with-targetprefix=/usr \
			$(LH_CONFIG_OPTS) \
			--with-boxtype=$(MACHINE) \
			--enable-silent-rules \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CFLAGS="$(NEUTRINO_CFLAGS)" CXXFLAGS="$(NEUTRINO_CFLAGS)" CPPFLAGS="$(NEUTRINO_CPPFLAGS)"
	@touch $@

$(D)/libstb-hal.do_compile: $(D)/libstb-hal.config.status
	cd $(SOURCE_DIR)/libstb-hal; \
		$(MAKE) -C $(BUILD_TMP)/libstb-hal all DESTDIR=$(TARGET_DIR)
	@touch $@

$(D)/libstb-hal: $(D)/libstb-hal.do_compile
	$(MAKE) -C $(BUILD_TMP)/libstb-hal install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

libstb-hal-clean:
	rm -f $(D)/libstb-hal.do_compile
	$(MAKE) -C $(BUILD_TMP)/libstb-hal clean

libstb-hal-distclean:
	rm -f $(D)/libstb-hal*
	$(MAKE) -C $(BUILD_TMP)/libstb-hal distclean
	rm -rf $(BUILD_TMP)/libstb-hal

#
# neutrino
#
$(D)/neutrino.do_prepare: $(NEUTRINO_DEPS) $(D)/libstb-hal
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/neutrino
	rm -rf $(BUILD_TMP)/neutrino
	[ -d "$(ARCHIVE)/$(NEUTRINO).git" ] && \
	(cd $(ARCHIVE)/$(NEUTRINO).git; git pull;); \
	[ -d "$(ARCHIVE)/$(NEUTRINO).git" ] || \
	git clone -b $(NEUTRINO_BRANCH) $(NEUTRINO_URL) $(ARCHIVE)/$(NEUTRINO).git; \
	cp -ra $(ARCHIVE)/$(NEUTRINO).git $(SOURCE_DIR)/neutrino; \
	set -e; cd $(SOURCE_DIR)/neutrino; \
		$(call apply_patches,$(NEUTRINO_PATCHES))
	@touch $@

$(D)/neutrino.config.status: $(D)/neutrino.do_prepare
	rm -rf $(BUILD_TMP)/neutrino
	test -d $(BUILD_TMP)/neutrino || mkdir -p $(BUILD_TMP)/neutrino; \
	cd $(BUILD_TMP)/neutrino; \
		$(SOURCE_DIR)/neutrino/autogen.sh; \
		$(BUILDENV) \
		$(SOURCE_DIR)/neutrino/configure --enable-silent-rules \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--with-targetprefix=/usr \
			$(NEUTRINO_CONFIG_OPTS) \
			--with-stb-hal-includes=$(SOURCE_DIR)/libstb-hal/include \
			--with-stb-hal-build=$(BUILD_TMP)/libstb-hal
	@touch $@

$(SOURCE_DIR)/neutrino/src/gui/version.h:
	@rm -f $@; \
	echo '#define BUILT_DATE "'`date`'"' > $@
	@if test -d $(SOURCE_DIR)/libstb-hal ; then \
		pushd $(SOURCE_DIR)/libstb-hal ; \
		HAL_REV=$$(git log | grep "^commit" | wc -l) ; \
		popd ; \
		pushd $(SOURCE_DIR)/neutrino ; \
		NMP_REV=$$(git log | grep "^commit" | wc -l) ; \
		popd ; \
		pushd $(BASE_DIR) ; \
		DDT_REV=$$(git log | grep "^commit" | wc -l) ; \
		popd ; \
		echo '#define VCS "DDT-rev'$$DDT_REV'_HAL-rev'$$HAL_REV'_NMP-rev'$$NMP_REV'"' >> $@ ; \
	fi

$(D)/neutrino.do_compile: $(D)/neutrino.config.status $(SOURCE_DIR)/neutrino/src/gui/version.h
	cd $(SOURCE_DIR)/neutrino; \
		$(MAKE) -C $(BUILD_TMP)/neutrino all
	@touch $@

$(D)/neutrino: $(D)/neutrino.do_compile
	$(MAKE) -C $(BUILD_TMP)/neutrino install DESTDIR=$(TARGET_DIR); \
	rm -f $(TARGET_DIR)/.version
	make $(TARGET_DIR)/.version
	$(TOUCH)

neutrino-clean:
	rm -f $(D)/neutrino.do_compile
	$(MAKE) -C $(BUILD_TMP)/neutrino clean
	rm -f $(SOURCE_DIR)/neutrino/src/gui/version.h

neutrino-distclean: libstb-hal-distclean neutrino-plugins-distclean
	rm -f $(D)/neutrino.*
	$(MAKE) -C $(BUILD_TMP)/neutrino distclean
	rm -rf $(BUILD_TMP)/neutrino

#
# neutrino-plugins
#
N_PLUGINS  = $(D)/neutrino-plugins
ifeq ($(LUA), lua)
N_PLUGINS += $(D)/neutrino-plugins-scripts-lua
N_PLUGINS += $(D)/neutrino-plugins-mediathek
#N_PLUGINS += $(D)/neutrino-plugins-xupnpd
endif

ifeq ($(BOXARCH), sh4)
EXTRA_CPPFLAGS_NEUTRINO_PLUGINS = -DMARTII
endif

$(D)/neutrino-plugins.do_prepare:
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/neutrino-plugins
	rm -rf $(BUILD_TMP)/neutrino-plugins
	set -e; 
	[ -d "$(ARCHIVE)/$(NEUTRINO_PLUGINS).git" ] && \
	(cd $(ARCHIVE)/$(NEUTRINO_PLUGINS).git; git pull;); \
	[ -d "$(ARCHIVE)/$(NEUTRINO_PLUGINS).git" ] || \
	git clone -b $(NEUTRINO_PLUGINS_BRANCH) $(NEUTRINO_PLUGINS_URL) $(ARCHIVE)/$(NEUTRINO_PLUGINS).git; \
	cp -ra $(ARCHIVE)/$(NEUTRINO_PLUGINS).git $(SOURCE_DIR)/neutrino-plugins
	set -e; cd $(SOURCE_DIR)/neutrino-plugins; \
		$(call apply_patches, $(NEUTRINO_PLUGINS_PATCHES))
ifeq ($(BOXARCH), $(filter $(BOXARCH), arm mips))
	sed -i -e 's#shellexec fx2#shellexec#g' $(SOURCE_DIR)/neutrino-plugins/Makefile.am
endif
	@touch $@

$(D)/neutrino-plugins.config.status: $(D)/neutrino-plugins.do_prepare
	rm -rf $(BUILD_TMP)/neutrino-plugins; \
	test -d $(BUILD_TMP)/neutrino-plugins || mkdir -p $(BUILD_TMP)/neutrino-plugins; \
	cd $(BUILD_TMP)/neutrino-plugins; \
		$(SOURCE_DIR)/neutrino-plugins/autogen.sh && automake --add-missing; \
		$(BUILDENV) \
		$(SOURCE_DIR)/neutrino-plugins/configure \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--enable-silent-rules \
			--with-target=cdk \
			--include=/usr/include \
			--enable-maintainer-mode \
			--with-boxtype=$(MACHINE) \
			--with-plugindir=/var/tuxbox/plugins \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CPPFLAGS="$(NEUTRINO_CPPFLAGS) $(EXTRA_CPPFLAGS_NEUTRINO_PLUGINS) -DNEW_LIBCURL" \
			LDFLAGS="$(TARGET_LDFLAGS) -L$(BUILD_TMP)/neutrino-plugins/fx2/lib/.libs"
	@touch $@

$(D)/neutrino-plugins.do_compile: $(D)/neutrino-plugins.config.status
	$(MAKE) -C $(BUILD_TMP)/neutrino-plugins DESTDIR=$(TARGET_DIR)
	@touch $@

$(D)/neutrino-plugins: $(D)/neutrino-plugins.do_compile
	$(MAKE) -C $(BUILD_TMP)/neutrino-plugins install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

neutrino-plugins-clean:
	rm -f $(D)/neutrino-plugins.do_compile
	$(MAKE) -C $(BUILD_TMP)/neutrino-plugins clean

neutrino-plugins-distclean:
	rm -f $(D)/neutrino-plugin*
	$(MAKE) -C $(BUILD_TMP)/neutrino-plugins distclean
	rm -rf $(BUILD_TMP)/neutrino-plugins

#
# neutrino-plugins-xupnpd
#
$(D)/neutrino-plugins-xupnpd: $(D)/xupnpd $(D)/lua $(D)/neutrino-plugins-scripts-lua
	install -m 644 $(ARCHIVE)/neutrino-plugin-scripts-lua.git/xupnpd/xupnpd_18plus.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/neutrino-plugin-scripts-lua.git/xupnpd/xupnpd_cczwei.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	: install -m 644 $(ARCHIVE)/neutrino-plugin-scripts-lua.git/xupnpd/xupnpd_coolstream.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/neutrino-plugin-scripts-lua.git/xupnpd/xupnpd_youtube.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(TOUCH)

#
# neutrino-plugins-scripts-lua
#
$(D)/neutrino-plugins-scripts-lua: $(D)/bootstrap
	$(START_BUILD)
	$(REMOVE)/neutrino-plugin-scripts-lua
	set -e; 
	[ -d "$(ARCHIVE)/neutrino-plugin-scripts-lua.git" ] && \
	(cd $(ARCHIVE)/neutrino-plugin-scripts-lua.git; git pull;); \
	[ -d "$(ARCHIVE)/neutrino-plugin-scripts-lua.git" ] || \
	git clone https://github.com/Duckbox-Developers/plugin-scripts-lua.git $(ARCHIVE)/neutrino-plugin-scripts-lua.git; \
	cp -ra $(ARCHIVE)/neutrino-plugin-scripts-lua.git/plugins $(BUILD_TMP)/neutrino-plugin-scripts-lua
	$(CHDIR)/neutrino-plugin-scripts-lua; \
		install -d $(TARGET_DIR)/var/tuxbox/plugins
#		cp -R $(BUILD_TMP)/neutrino-plugin-scripts-lua/favorites2bin/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/neutrino-plugin-scripts-lua/ard_mediathek/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/neutrino-plugin-scripts-lua/mtv/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/neutrino-plugin-scripts-lua/netzkino/* $(TARGET_DIR)/var/tuxbox/plugins/
	$(REMOVE)/neutrino-plugin-scripts-lua
	$(TOUCH)
	
#
# neutrino-mediathek
#
$(D)/neutrino-plugins-mediathek:
	$(START_BUILD)
	$(REMOVE)/neutrino-plugins-mediathek
	set -e; 
	[ -d "$(ARCHIVE)/neutrino-plugins-mediathek.git" ] && \
	(cd $(ARCHIVE)/neutrino-plugins-mediathek.git; git pull;); \
	[ -d "$(ARCHIVE)/neutrino-plugins-mediathek.git" ] || \
	git clone https://github.com/Duckbox-Developers/mediathek.git $(ARCHIVE)/neutrino-plugins-mediathek.git; \
	cp -ra $(ARCHIVE)/neutrino-plugins-mediathek.git $(BUILD_TMP)/neutrino-plugins-mediathek
	install -d $(TARGET_DIR)/var/tuxbox/plugins
	$(CHDIR)/neutrino-plugins-mediathek; \
		cp -a plugins/* $(TARGET_DIR)/var/tuxbox/plugins/; \
#		cp -a share $(TARGET_DIR)/usr/
		rm -f $(TARGET_DIR)/var/tuxbox/plugins/neutrino-mediathek/livestream.lua
	$(REMOVE)/neutrino-plugins-mediathek
	$(TOUCH)
	
#
# neutrino-ipk
#
$(PKGPREFIX)/.version:
	echo "distro=$(MAINTAINER)" > $@
	echo "imagename=`sed -n 's/\#define PACKAGE_NAME "//p' $(BUILD_TMP)/neutrino/config.h | sed 's/"//'`" >> $@
	echo "imageversion=`sed -n 's/\#define PACKAGE_VERSION "//p' $(BUILD_TMP)/neutrino/config.h | sed 's/"//'`" >> $@
	echo "homepage=https://github.com/Duckbox-Developers" >> $@
	echo "creator=$(MAINTAINER)" >> $@
	echo "docs=https://github.com/Duckbox-Developers" >> $@
	echo "forum=https://github.com/Duckbox-Developers/neutrino-ddt" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git log | grep "^commit" | wc -l`" >> $@
	
$(D)/neutrino-ipk: $(D)/neutrino.do_compile
	$(START_BUILD)
	rm -rf $(PKGPREFIX)
	install -d $(PKGPREFIX)
	install -d $(PKGS_DIR)
	$(MAKE) -C $(BUILD_TMP)/neutrino install DESTDIR=$(PKGPREFIX); \
	rm -f $(PKGPREFIX)/.version
	make $(PKGPREFIX)/.version
ifneq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug normal))
	find $(PKGPREFIX)/ -name '*' -exec $(TARGET)-strip --strip-unneeded {} &>/dev/null \;
endif
	cd $(PKGPREFIX) && tar -cvzf $(PKGS_DIR)/data.tar.gz *
	cd $(PACKAGES)/neutrino && tar -cvzf $(PKGS_DIR)/control.tar.gz *
	cd $(PKGS_DIR) && echo 2.0 > debian-binary && tar -cvzf $(PKGS_DIR)/neutrino_$(BOXARCH)_$(BOXTYPE)_$(shell date '+%d.%m.%Y-%H.%M').tar.gz data.tar.gz control.tar.gz debian-binary && rm -rf data.tar.gz control.tar.gz debian-binary
	rm -rf $(PKGPREFIX)
	$(END_BUILD)
	
$(D)/neutrino-plugins-ipk: $(D)/neutrino-plugins.do_compile
	$(START_BUILD)
	rm -rf $(PKGPREFIX)
	install -d $(PKGPREFIX)
	install -d $(PKGS_DIR)
	$(MAKE) -C $(BUILD_TMP)/neutrino-plugins install DESTDIR=$(PKGPREFIX)
ifneq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug normal))
	find $(PKGPREFIX)/ -name '*' -exec $(TARGET)-strip --strip-unneeded {} &>/dev/null \;
endif
	cd $(PKGPREFIX) && tar -cvzf $(PKGS_DIR)/data.tar.gz *
	cd $(PACKAGES)/neutrino && tar -cvzf $(PKGS_DIR)/control.tar.gz *
	cd $(PKGS_DIR) && echo 2.0 > debian-binary && tar -cvzf $(PKGS_DIR)/neutrino_plugins_$(BOXARCH)_$(BOXTYPE)_$(shell date '+%d.%m.%Y-%H.%M').tar.gz data.tar.gz control.tar.gz debian-binary && rm -rf data.tar.gz control.tar.gz debian-binary
	rm -rf $(PKGPREFIX)
	$(END_BUILD)
	
#
# release-neutrino
#
release-neutrino: $(RELEASE_DEPS) $(D)/neutrino $(N_PLUGINS) release-common release-$(BOXTYPE)
	$(START_BUILD)
	install -d $(RELEASE_DIR)/var/tuxbox
	install -d $(RELEASE_DIR)/usr/share/iso-codes
	install -d $(RELEASE_DIR)/usr/share/tuxbox
	install -d $(RELEASE_DIR)/var/tuxbox
	install -d $(RELEASE_DIR)/var/tuxbox/config/{webtv,zapit}
	install -d $(RELEASE_DIR)/var/tuxbox/plugins
	install -d $(RELEASE_DIR)/var/httpd
	cp -af $(TARGET_DIR)/usr/bin/neutrino $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/backup.sh $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/install.sh $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/luaclient $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/pzapit $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/rcsim $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/restore.sh $(RELEASE_DIR)/usr/bin/
	cp -af $(TARGET_DIR)/usr/bin/sectionsdcontrol $(RELEASE_DIR)/usr/bin/
	cp -dp $(TARGET_DIR)/.version $(RELEASE_DIR)/
	cp -aR $(TARGET_DIR)/usr/share/tuxbox/neutrino $(RELEASE_DIR)/usr/share/tuxbox
ifeq ($(BOXARCH), sh4)
	rm -rf $(RELEASE_DIR)/usr/share/fonts
endif
	cp -aR $(TARGET_DIR)/usr/share/fonts $(RELEASE_DIR)/usr/share/
	cp -aR $(TARGET_DIR)/usr/share/iso-codes $(RELEASE_DIR)/usr/share/
	cp -aR $(TARGET_DIR)/var/tuxbox/* $(RELEASE_DIR)/var/tuxbox
	cp -dp $(TARGET_DIR)/.version $(RELEASE_DIR)/
	install -m 0755 $(BASE_DIR)/machine/$(BOXTYPE)/files/rcS_NEUTRINO $(RELEASE_DIR)/etc/init.d/rcS
#
# delete unnecessary files
#
	[ -e $(RELEASE_DIR)/usr/bin/neutrino2 ] && rm -rf $(RELEASE_DIR)/usr/bin/neutrino2 || true
	[ -d $(RELEASE_DIR)/var/tuxbox/locale/de/LC_MESSAGES/neutrino2.mo ] && rm -rf $(RELEASE_DIR)/var/tuxbox/locale || true
	[ -e $(RELEASE_DIR)/usr/bin/enigma2 ] && rm -rf $(RELEASE_DIR)/usr/bin/enigma2 || true
	[ -e $(RELEASE_DIR)/usr/bin/titan ] && rm -rf $(RELEASE_DIR)/usr/bin/titan || true
ifeq ($(BOXARCH), sh4)
	[ -e $(RELEASE_DIR)/usr/bin/amixer ] && rm -rf $(RELEASE_DIR)/usr/bin/amixer || true
	[ -e $(RELEASE_DIR)/usr/bin/eplayer3 ] && rm -rf $(RELEASE_DIR)/usr/bin/eplayer3 || true
	[ -e $(RELEASE_DIR)/usr/bin/satip_client ] && rm -rf $(RELEASE_DIR)/usr/bin/satip* || true
	[ -e $(RELEASE_DIR)/sbin/sfdisk ] && rm -rf $(RELEASE_DIR)/sbin/sfdisk || true
	[ -e $(RELEASE_DIR)/usr/bin/lircd ] && rm -rf $(RELEASE_DIR)/usr/bin/lircd || true
	rm -rf $(RELEASE_DIR)/usr/lib/locale
	rm -rf $(RELEASE_DIR)/usr/share/zoneinfo
	[ -e $(RELEASE_DIR)/usr/lib/libipkg.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libipkg* || true
	[ -e $(RELEASE_DIR)/usr/bin/ipkg-cl ] && rm -rf $(RELEASE_DIR)/usr/bin/ipkg* || true
	[ -e $(RELEASE_DIR)/usr/lib/libarchive.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libarchive* || true
	[ -e $(RELEASE_DIR)/usr/lib/libdbus-1.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libdbus-1* || true
	[ -e $(RELEASE_DIR)/usr/lib/libeplayer3.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libeplayer3* || true
	[ -e $(RELEASE_DIR)/usr/lib/libglib-2.0.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libglib-2.0* || true
	[ -e $(RELEASE_DIR)/usr/lib/libgmodule-2.0.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libgmodule-2.0* || true
	[ -e $(RELEASE_DIR)/usr/lib/libgobject-2.0.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libgobject-2.0* || true
	[ -e $(RELEASE_DIR)/usr/lib/libgthread-2.0.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libgthread-2.0* || true
	[ -e $(RELEASE_DIR)/usr/lib/libpython2.7.so ] && rm -rf $(RELEASE_DIR)/usr/lib/libpython* || true
endif
#
# imigrate /etc to /var/etc
#
	cp -dpfr $(RELEASE_DIR)/etc $(RELEASE_DIR)/var
	rm -fr $(RELEASE_DIR)/etc
	ln -sf /var/etc $(RELEASE_DIR)
	$(TUXBOX_CUSTOMIZE)
#
# strip
#	
ifneq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug normal))
	find $(RELEASE_DIR)/ -name '*' -exec $(TARGET)-strip --strip-unneeded {} &>/dev/null \;
endif
	$(END_BUILD)

#
# image-neutrino
#
image-neutrino: release-neutrino
	$(START_BUILD)
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), fortis_hdbox octagon1008 cuberevo cuberevo_mini cuberevo_mini2 cuberevo_2000hd spark spark7162 atevio7500 ufs912))
	$(MAKE) flash-image-$(BOXTYPE)
endif
ifeq ($(BOXTYPE), hl101)
	$(MAKE) usb-image-$(BOXTYPE)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vuduo vuduo2 gb800se bre2zet2c osnino osninoplus osninopro dm8000))
	$(MAKE) flash-image-$(BOXTYPE)
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), bre2ze4k h7 hd51 hd60 osmini4k osmio4k osmio4kplus e4hdultra))
	$(MAKE) flash-image-$(BOXTYPE)-disk flash-image-$(BOXTYPE)-rootfs
endif
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
	$(MAKE) flash-image-$(BOXTYPE)-rootfs
endif
	$(END_BUILD)
	
