#master makefile

SHELL = /bin/bash
UID := $(shell id -u)
ifeq ($(UID), 0)
warn:
	@echo "You are running as root. Do not do this, it is dangerous."
	@echo "Aborting the build. Log in as a regular user and retry."
else
LC_ALL:=C
LANG:=C
export TOPDIR LC_ALL LANG

# Boxtype
init:
	@echo ""
	@echo "Target receivers:"
	@echo "  Kathrein"
	@echo "    1)  UFS-912"
	@echo ""
	@echo "  Fortis / Divers"
	@echo "    10)  FS9000 / FS9200 (formerly Fortis HDbox)"
	@echo "    11)  HS9510          (formerly Octagon SF1008P)"
	@echo "    12)  HS8200          (formerly Atevio AV7500)"
	@echo "    13)  Hl101"
	@echo ""
	@echo "  AB IPBox/cuberevo/Xsarius"
	@echo "   20)  cuberevo / 9000"
	@echo "   21)  mini / 900HD"
	@echo "   22)  mini2 / 910HD / 3000HD / Xsarius Alpha"
	@echo "   23)  2000HD"
	@echo
	@echo "  Fulan"
	@echo "   30)  Spark"
	@echo "   31)  Spark7162"
	@echo ""
	@echo "  VU Plus"
	@echo "   40)  Vu+ Solo4K"
	@echo "   41)  VU+ Duo"
	@echo "   42)  VU+ Duo2"
	@echo "   43)  VU+ Duo4k"
	@echo "   44)  VU+ Ultimo4k"
	@echo "   45)  VU+ Uno4k"
	@echo "   46)  VU+ Uno4kse"
	@echo "   47)  VU+ Zero4k"
	@echo ""
	@echo "  AX Mutant"
	@echo "   50)  Mut@nt HD51"
	@echo "   51)  Mut@nt HD60"
	@echo ""
	@echo "  Edision"
	@echo "   60)  osnino"
	@echo "   61)  osninoplus" 
	@echo "   62)  osninopro" 
	@echo "   63)  osmio4k"
	@echo "   64)  osmio4kplus"
	@echo "   65)  osmini4k"  
	@echo ""
	@echo "  Giga Blue"
	@echo -e "\033[01;32m   70)  gb800se\033[00m"
	@echo ""
	@echo "  WWIO"
	@echo "   80)  WWIO BRE2ZE 4K"
	@echo "   81)  WWIO BRE2ZE T2C"
	@echo ""
	@echo "  Air Digital"
	@echo "   90)  Zgemma h7"
	@echo "  AXAS"
	@echo "   100)  AXAS E4HD 4K Ultra"
	@echo ""
	@echo "  Dream Media"
	@echo "   110 dm8000"
	@read -p "Select target (1-90)? " BOXTYPE; \
	BOXTYPE=$${BOXTYPE}; \
	case "$$BOXTYPE" in \
		1) BOXTYPE="ufs912";; \
		10) BOXTYPE="fortis_hdbox";; \
		11) BOXTYPE="octagon1008";; \
		12) BOXTYPE="atevio7500";; \
		13) BOXTYPE="hl101";; \
		20) BOXTYPE="cuberevo";; \
		21) BOXTYPE="cuberevo_mini";; \
		22) BOXTYPE="cuberevo_mini2";; \
		23) BOXTYPE="cuberevo_2000hd";; \
		30) BOXTYPE="spark";; \
		31) BOXTYPE="spark7162";; \
		40) BOXTYPE="vusolo4k";; \
		41) BOXTYPE="vuduo";; \
		42) BOXTYPE="vuduo2";; \
		43) BOXTYPE="vuduo4k";; \
		44) BOXTYPE="vuultimo4k";; \
		45) BOXTYPE="vuuno4k";; \
		46) BOXTYPE="vuuno4kse";; \
		47) BOXTYPE="vuzero4k";; \
		50) BOXTYPE="hd51";; \
		51) BOXTYPE="hd60";; \
		60) BOXTYPE="osnino";; \
		61) BOXTYPE="osninoplus";; \
		62) BOXTYPE="osninopro";; \
		63) BOXTYPE="osmio4k";; \
		64) BOXTYPE="osmio4kplus";; \
		65) BOXTYPE="osmini4k";; \
		70) BOXTYPE="gb800se";; \
		80) BOXTYPE="bre2ze4k";; \
		81) BOXTYPE="bre2zet2c";; \
		90) BOXTYPE="h7";; \
		100) BOXTYPE="e4hdultra";; \
		110) BOXTYPE="dm8000";; \
		*) BOXTYPE="gb800se";; \
	esac; \
	echo "BOXTYPE=$$BOXTYPE" > config
	@echo ""		
# WLAN driver
	@echo -e "\nDo you want to build WLAN drivers and tools"
	@echo -e "   \033[01;32m1) no\033[00m"
	@echo "   2) yes (includes WLAN drivers and tools)"
	@read -p "Select to build (1-2)?" WLAN; \
	WLAN=$${WLAN}; \
	case "$$WLAN" in \
		1) echo "WLAN=" >> config;; \
		2) echo "WLAN=wlandriver" >> config;; \
		*) echo "WLAN=" >> config;; \
	esac; \
	echo ""
# Gstreamer
	@echo -e "\nGstreamer:"
	@echo -e "   \033[01;32m1) no\033[00m"
	@echo "   2) yes"
	@read -p "Select Gstreamer (1-2)?" GSTREAMER; \
	GSTREAMER=$${GSTREAMER}; \
	case "$$GSTREAMER" in \
		1) echo "GSTREAMER=" >> config;; \
		2) echo "GSTREAMER=gstreamer" >> config;; \
		*) echo "GSTREAMER=" >> config;; \
	esac; \
	echo ""
# lua
	@echo -e "\nlua support ?:"
	@echo -e "   \033[01;32m1)  yes\033[00m"
	@echo "   2)  no"
	@read -p "Select lua support (1-2)?" LUA; \
	LUA=$${LUA}; \
	case "$$LUA" in \
		1) echo "LUA=lua" >> config;; \
		2) echo "LUA=" >> config;; \
		*) echo "LUA=lua" >> config;; \
	esac; \
	echo ""
# python
	@echo -e "\npython support ?:"
	@echo -e "   \033[01;32m1)  no\033[00m"
	@echo "   2)  yes"
	@read -p "Select python support (1-2)?" PYTHON; \
	PYTHON=$${PYTHON}; \
	case "$$PYTHON" in \
		1) echo "PYTHON=" >> config;; \
		2) echo "PYTHON=python" >> config;; \
		*) echo "PYTHON=" >> config;; \
	esac; \
	echo ""
# GraphLCD
	@echo -e "\nGraphLCD:"
	@echo -e "   \033[01;32m1)  yes\033[00m"
	@echo "   2) no"
	@read -p "Select  GraphLCD (1-2)?" GRAPHLCD; \
	GRAPHLCD=$${GRAPHLCD}; \
	case "$$GRAPHLCD" in \
		1) echo "GRAPHLCD=graphlcd" >> config;; \
		2) echo "GRAPHLCD=" >> config;; \
		*) echo "GRAPHLCD=graphlcd" >> config;; \
	esac; \
	echo ""
# LCD4Linux
	@echo -e "\nLCD4linux:"
	@echo -e "   \033[01;32m1)  yes\033[00m"
	@echo "   2) no"
	@read -p "Select  LCD4Linux (1-2)?" LCD4LINUX; \
	LCD4LINUX=$${LCD4LINUX}; \
	case "$$LCD4LINUX" in \
		1) echo "LCD4LINUX=lcd4linux" >> config;; \
		2) echo "LCD4LINUX=" >> config;; \
		*) echo "LCD4LINUX=lcd4linux" >> config;; \
	esac; \
	echo ""	
#	
	@echo ""
	@make printenv
	@echo "Your next step could be:"
	@echo "  make image-neutrino2"
	@echo "or"
	@echo "  make image-neutrino"
	@echo "  make image-titan"
	@echo "  make image-enigma2"
	@echo ""
	@echo ""
	@echo "for more details:"
	@echo "  make help"
	@echo "to check your build enviroment:"
	@echo "  make printenv"
	@echo ""
	
init-clean:
	rm -f config

include make/buildenv.mk

PARALLEL_JOBS := $(shell echo $$((1 + `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`)))
override MAKE = make $(if $(findstring j,$(filter-out --%,$(MAKEFLAGS))),,-j$(PARALLEL_JOBS))

#
#  A print out of environment variables
#
# maybe a help about all supported targets would be nice here, too...
#
printenv:
	@echo
	@echo '================================================================================'
	@echo "Build Environment Variables:"
	@echo "PATH             : `type -p fmt>/dev/null&&echo $(PATH)|sed 's/:/ /g' |fmt -65|sed 's/ /:/g; 2,$$s/^/                 : /;'||echo $(PATH)`"
	@echo "ARCHIVE_DIR      : $(ARCHIVE)"
	@echo "BASE_DIR         : $(BASE_DIR)"
	@echo "CUSTOM_DIR       : $(CUSTOM_DIR)"
	@echo "TOOLS_DIR        : $(TOOLS_DIR)"
	@echo "DRIVER_DIR       : $(DRIVER_DIR)"
	@echo "IMAGE_DIR        : $(IMAGE_DIR)"
	@echo "PKGS_DIR         : $(PKGS_DIR)"
	@echo "CROSS_DIR        : $(CROSS_DIR)"
	@echo "RELEASE_DIR      : $(RELEASE_DIR)"
	@echo "HOST_DIR         : $(HOST_DIR)"
	@echo "TARGET_DIR       : $(TARGET_DIR)"
	@echo "KERNEL_DIR       : $(KERNEL_DIR)"
	@echo "MAINTAINER       : $(MAINTAINER)"
	@echo "BOXARCH          : $(BOXARCH)"
	@echo "BUILD            : $(BUILD)"
	@echo "TARGET           : $(TARGET)"
	@echo "GCC_VER          : $(GCC_VER)"
	@echo "BOXTYPE          : $(BOXTYPE)"
	@echo "KERNEL_VERSION   : $(KERNEL_VER)"
	@echo "OPTIMIZATIONS    : $(OPTIMIZATIONS)"
	@echo "WLAN             : $(WLAN)"
	@echo "GSTREAMER        : $(GSTREAMER)"
	@echo "LUA              : $(LUA)"
	@echo "PYTHON           : $(PYTHON)"
	@echo "GRAPHLCD         : $(GRAPHLCD)"
	@echo "LCD4LINUX        : $(LCD4LINUX)"
	@echo "CICAM            : $(CICAM)"
	@echo "SCART            : $(SCART)"
	@echo "F-KEYS           : $(FKEYS)"
	@echo "LCD              : $(LCD)"
	@echo "PARALLEL_JOBS    : $(PARALLEL_JOBS)"
	@echo '================================================================================'
	@make --no-print-directory toolcheck
ifeq ($(MAINTAINER),)
	@echo "##########################################################################"
	@echo "# The MAINTAINER variable is not set. It defaults to your name from the  #"
	@echo "# passwd entry, but this seems to have failed. Please set it in 'config'.#"
	@echo "##########################################################################"
	@echo
endif
	@echo
	@echo "If you want to create or modify the configuration, run 'make init or make'"
	@echo

help:
	@echo "main target (image):"
	@echo " make image-neutrino2		- build neutrino2 image"
	@echo " make image-neutrino		- build neutrino image"
	@echo " make image-titan		- build titan image"
	@echo " make image-enigma2		- build enigma2 image (exp)"
	@echo ""
	@echo "show board configuration:"
	@echo " make printenv			- show board build configuration"
	@echo ""
	@echo "toolchains:"
	@echo " make crosstool			- build cross toolchain"
	@echo " make bootstrap			- prepares for building"
	@echo ""
	@echo "show all build-targets:"
	@echo " make print-targets		- show all available targets"
	@echo ""
	@echo "later, you might find these useful:"
	@echo " make update			- update the build system"
	@echo ""
	@echo "release:"
	@echo " make release-neutrino2		- build neutrino2 release  with full release dir"
	@echo " make release-neutrino		- build neutrino release  with full release dir"
	@echo " make release-titan		- build titan release  with full release dir"
	@echo " make release-enigma2		- build enigma2 release  with full release dir"
	@echo ""
	@echo "GUI:"
	@echo " make neutrino2			- build neutrino2"
	@echo " make neutrino			- build neutrino"
	@echo " make titan			- build titan"
	@echo " make enigma2			- build enigma2"
	@echo ""
	@echo "cleantargets:"
	@echo " make clean			- clears everything except toolchain."
	@echo " make distclean			- clears the whole construction."
	@echo ""
	@echo "show all supported boards:"
	@echo " make print-boards		- show all supported boards"
	@echo

ifeq ($(BOXARCH), sh4)
include make/crosstool-sh4.mk
endif
ifeq ($(BOXARCH), $(filter $(BOXARCH), arm mips))
include make/crosstool.mk
endif
include make/bootstrap.mk
include make/contrib-libs.mk
include make/contrib-apps.mk
include make/ffmpeg.mk
include make/gstreamer.mk
include make/root-etc.mk
include make/python.mk
include make/lua.mk
include make/tools.mk
include make/cleantargets.mk
include make/release.mk
include make/neutrino2.mk
include make/enigma2.mk
include make/titan.mk
include make/neutrino.mk
include make/packages.mk

update:
	@if test -d $(BASE_DIR); then \
		cd $(BASE_DIR)/; \
		if [ "$(GIT_STASH_PULL)" = "stashpull" ]; then \
			git stash && git stash show -p > ./pull-stash-cdk.patch || true && git pull && git stash pop || true; \
		else \
			git pull; \
		fi; \
	fi
	@echo;

all:
	@echo "'make all' is not a valid target. Please read the documentation."

# print all present targets...
print-targets:
	@sed -n 's/^\$$.D.\/\(.*\):.*/\1/p' \
		`ls -1 make/*.mk|grep -v make/buildenv.mk|grep -v make/release.mk` | \
		sort -u | fold -s -w 65
		
# print all supported boards ...
print-boards:
	@ls machine | sed 's/.mk//g' 

# for local extensions, e.g. special plugins or similar...
# put them into $(BASE_DIR)/local since that is ignored in .gitignore
-include ./Makefile.local

# debug target, if you need that, you know it. If you don't know if you need
# that, you don't need it.
.print-phony:
	@echo $(PHONY)

PHONY += print-targets
PHONY += all printenv .print-phony
PHONY += update
.PHONY: $(PHONY)

# this makes sure we do not build top-level dependencies in parallel
# (which would not be too helpful anyway, running many configure and
# downloads in parallel...), but the sub-targets are still built in
# parallel, which is useful on multi-processor / multi-core machines
.NOTPARALLEL:

endif

