#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <rootless.h>
#include "NGCBadgeView.h"

#define GENERAL_PREFS ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.0xkuj.notificationsgroupcountprefs.plist")

CGFloat ngcBadgeSize = 20;
int badgeStyle;
CGFloat shadowOpacity;     
BOOL isTweakEnabled, isCustomColors;
UIColor *badgeBackgroundColor, *badgeTextColor;  
BOOL isRTL;

@interface SBWallpaperController
+ (id)sharedInstance;
- (id)averageColorForVariant:(NSInteger)arg1;
@end

@interface NCNotificationRequest
- (id)notificationIdentifier;
@end

@interface NCNotificationShortLookView : UIView
@property (nonatomic, copy, readwrite) NSString *primaryText;
@property (nonatomic, copy, readwrite) UIView *prominentIconView;
- (id)_notificationContentView;
- (BOOL)isNotificationContentViewHidden;
@end 

@interface NCNotificationShortLookViewController : NSObject
- (id)_notificationShortLookViewIfLoaded;
@end

@interface CSNotificationViewController : NCNotificationShortLookViewController
- (id)notificationRequest;
@end

// ios 15
@interface NCNotificationViewController : UIViewController
@end

@interface NCNotificationListCell : UIView
//ios 15
@property (nonatomic, strong, readwrite) CSNotificationViewController *contentViewController;
- (id)notificationViewController;
@end

// @interface NCNotificationGroupList

// @end

@interface NCNotificationListView : UIView
@property (nonatomic, strong, readwrite) NSMutableDictionary *visibleViews;
- (BOOL)isGrouped;
- (NSUInteger)count;
// %new
- (void)updateNotificationCountBadge;
- (void)deleteBadgesFromCurrentListView;
- (CGRect)getBadgePosByFrame:(CGRect)destFrame;
@end

@interface NCNotificationGroupList
@property (nonatomic, strong, readwrite) NCNotificationListView *groupListView;
@property (nonatomic, strong, readwrite) NSMutableArray *orderedRequests;
- (NSUInteger)notificationCount;
- (NSUInteger)count;
- (BOOL)isGrouped;
@end

// ios 15
@interface NCNotificationViewControllerView
- (id)contentView;
@end

// ios 16
@interface NCDimmableView
- (id)contentView;
@end

@interface NCNotificationSeamlessContentView : UIView
@end

@interface NCBadgedIconView : UIView
- (CSNotificationViewController *)badgeViewController;
@end
