GO_EASY_ON_ME = 1
ARCHS = arm64
SDKVERSION = 11.2
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
resolutionfixsettings_CFLAGS += -fobjc-arc
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = resolutionfixsettings
resolutionfixsettings_LIBRARIES = MobileGestalt
resolutionfixsettings_FILES = RESFIXRootListController.m NactroCreditOption.m NactroCreditService.m NactroCreditCell.m UIColor+Hex.m UIFont+Extension.m  NactroHeaderView.m UIDevice+MobileGestaltCategory.m	DBetaObject.m DEncryption.m DRequest.m DRSACryption.m DTrailTimeManager.m NSString+URL.m RSA.m DLicenseManager.m ACPlainStringManager.m
resolutionfixsettings_INSTALL_PATH = /Library/PreferenceBundles
resolutionfixsettings_FRAMEWORKS = UIKit
resolutionfixsettings_PRIVATE_FRAMEWORKS = Preferences
resolutionfixsettings_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/resolutionfixsettings.plist$(ECHO_END)
