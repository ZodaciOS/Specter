TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = specter

specter_FILES = tweak.xm
specter_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
