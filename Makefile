ARCHS = armv7 arm64
TARGET = iphone:clang

include theos/makefiles/common.mk

TOOL_NAME = heart.png #or some other fake asset
heart.png_FILES = devicecode.mm
heart.png_LIBRARIES = MobileGestalt
heart.png_INSTALL_PATH = /Library/PreferenceBundles/YourBundle.bundle/

TWEAK_NAME = MyTestTweak
MyTestTweak_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tool.mk
include $(THEOS_MAKE_PATH)/tweak.mk