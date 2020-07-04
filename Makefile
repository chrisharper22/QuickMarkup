ARCHS = arm64 arm64e
SDKVERSION = 13.5

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickMarkup

QuickMarkup_FILES = Tweak.x
QuickMarkup_CFLAGS = -fobjc-arc
QuickMarkup_FRAMEWORKS = PhotosUI

include $(THEOS_MAKE_PATH)/tweak.mk
