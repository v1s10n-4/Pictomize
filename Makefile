ARCHS = arm64e
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:12.1:12.1
SDK = iPhoneOS12.1

GO_EASY_ON_ME = 0

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Pictomize

Pictomize_FILES = Tweak.x
Pictomize_CFLAGS = -fobjc-arc
Pictomize_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += pictomizeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
