#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>

#define GENERAL_PREFS ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.0xkuj.notificationsgroupcountprefs.plist")

@interface NGCRootListController : PSListController
{
    UILabel* _label;
	UILabel* underLabel;
    NSArray* _allSpecifiers;
}
- (void)headerCell;
- (void)defaultsettings:(PSSpecifier*)specifier;
- (void)openTwitter;
- (void)donationLink;
@end
