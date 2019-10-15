ARCHS = arm64e
TARGET = iphone:clang:12.1:12.1  
SDK = iPhoneOS12.1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PictomizePrefs
PictomizePrefs_FILES = RootListController.m
PictomizePrefs_INSTALL_PATH = /Library/PreferenceBundles
PictomizePrefs_FRAMEWORKS = UIKit
PictomizePrefs_PRIVATE_FRAMEWORKS = Preferences
PictomizePrefs_CFLAGS = -fobjc-arc
PictomizePrefs_LDFLAGS += -lCSColorPicker -lCSPreferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PictomizePrefs.plist$(ECHO_END)
