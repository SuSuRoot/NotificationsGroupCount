TARGET := iphone:clang:14.5:14.5
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NotificationsGroupCount

NotificationsGroupCount_FILES =  $(wildcard NGC*.*m)
NotificationsGroupCount_FRAMEWORKS = UIKit
NotificationsGroupCount_PRIVATE_FRAMEWORKS = Preferences
NotificationsGroupCount_INSTALL_PATH = /Library/PreferenceBundles
NotificationsGroupCount_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
