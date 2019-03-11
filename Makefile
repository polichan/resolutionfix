GO_EASY_ON_ME = 1
ARCHS = arm64
SDKVERSION = 11.2
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
resolutionfix_CFLAGS += -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = resolutionfix
resolutionfix_FILES = resolutionfix.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += resolutionfixsettings
include $(THEOS_MAKE_PATH)/aggregate.mk
