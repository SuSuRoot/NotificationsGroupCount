#include "Tweak.h"

@interface NSMutableDictionary (NGC)
-(UIColor *)colorWithHexString:(NSString*)hex;
@end

@implementation NSMutableDictionary (NGC)
-(UIColor *)colorWithHexString:(NSString*)hex {
  if ([hex isEqualToString:@"red"]) {
    return UIColor.systemRedColor;
  } else if ([hex isEqualToString:@"orange"]) {
    return UIColor.systemOrangeColor;
  } else if ([hex isEqualToString:@"yellow"]) {
    return UIColor.systemYellowColor;
  } else if ([hex isEqualToString:@"green"]) {
    return UIColor.systemGreenColor;
  } else if ([hex isEqualToString:@"blue"]) {
    return UIColor.systemBlueColor;
  } else if ([hex isEqualToString:@"teal"]) {
    return UIColor.systemTealColor;
  } else if ([hex isEqualToString:@"indigo"]) {
    return UIColor.systemIndigoColor;
  } else if ([hex isEqualToString:@"purple"]) {
    return UIColor.systemPurpleColor;
  } else if ([hex isEqualToString:@"pink"]) {
    return UIColor.systemPinkColor;
  } else if ([hex isEqualToString:@"default"]) {
    return UIColor.labelColor;
  } else if ([hex isEqualToString:@"tertiary"]) {
    return UIColor.tertiaryLabelColor;
  } else {

    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
      cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
      [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
      [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
      [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
      cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
  }
}
@end

static void loadPrefs() {
	NSMutableDictionary* mainPreferenceDict = [[NSMutableDictionary alloc] initWithContentsOfFile:GENERAL_PREFS];
	isTweakEnabled = [mainPreferenceDict objectForKey:@"isTweakEnabled"] ? [[mainPreferenceDict objectForKey:@"isTweakEnabled"] boolValue] : YES;
	isCustomColors = [mainPreferenceDict objectForKey:@"isCustomColors"] ? [[mainPreferenceDict objectForKey:@"isCustomColors"] boolValue] : NO;
	shadowOpacity = [mainPreferenceDict objectForKey:@"shadowOpacity"] ? [[mainPreferenceDict objectForKey:@"shadowOpacity"] floatValue] : 0.8f;

	if ([mainPreferenceDict objectForKey:@"badgeBackgroundColor"] != nil) {
		badgeBackgroundColor = [mainPreferenceDict colorWithHexString:[mainPreferenceDict objectForKey:@"badgeBackgroundColor"]];
	} else {
		badgeBackgroundColor = [UIColor blackColor];
	}

	if ([mainPreferenceDict objectForKey:@"badgeTextColor"] != nil) {
		badgeTextColor = [mainPreferenceDict colorWithHexString:[mainPreferenceDict objectForKey:@"badgeTextColor"]];
	} else {
		badgeTextColor = [UIColor whiteColor];
	}

	if ([mainPreferenceDict objectForKey:@"badgeStyle"] != nil) {
		badgeStyle = [[mainPreferenceDict objectForKey:@"badgeStyle"] intValue];
	} else {
		badgeStyle = 0;
	}                                      
}

%group groupNotifications
%hook NCNotificationGroupList
- (void)insertNotificationRequest:(id)arg1 {
 	%orig;
	[self.groupListView updateNotificationCountBadge];
} 

// ios 15
- (void)_toggleGroupedState {
	%orig;
	[self.groupListView updateNotificationCountBadge];
}

// ios 16
- (void)toggleGroupedState {
	%orig;
	[self.groupListView updateNotificationCountBadge];
}

//for the first notification after lockscreen is loaded
- (void)_reloadNotificationViewForNotificationRequest:(id)arg1 {
	%orig;
	[self.groupListView updateNotificationCountBadge];
}
%end

%hook NCNotificationListView 
%new
- (CGRect)getBadgePosByFrame:(CGRect)destFrame {
	if (@available(iOS 16.0, *)) {
		if (isRTL) {
			return CGRectMake(destFrame.origin.x, destFrame.origin.y-7, ngcBadgeSize, ngcBadgeSize);
		} else {
			return CGRectMake(destFrame.size.width, destFrame.origin.y-7, ngcBadgeSize, ngcBadgeSize);
		}
	} else {
		if (isRTL) {
			return CGRectMake(destFrame.origin.x-7, destFrame.origin.y-3, ngcBadgeSize, ngcBadgeSize);
		} else {
			return CGRectMake(destFrame.size.width-7, destFrame.origin.y-3, ngcBadgeSize, ngcBadgeSize);
		}
	}
}

- (void)layoutSubviews {
	%orig;
	[self updateNotificationCountBadge];
}

- (void)_setVisibleView:(id)arg1 atIndex:(NSUInteger)arg2 {
	%orig;
	[self updateNotificationCountBadge];
}

%new
- (void)updateNotificationCountBadge {
	if ([self isGrouped] && [self count] > 1) {
		if (self.visibleViews.count <= 0  || ![self.visibleViews[@(0)] isKindOfClass:NSClassFromString(@"NCNotificationListCell")]) {
			return;
		}

		NCNotificationListCell *shownCell = self.visibleViews[@(0)];
		if (![shownCell isKindOfClass:NSClassFromString(@"NCNotificationListCell")] || ![shownCell respondsToSelector:@selector(contentViewController)]) {
			return;
		}

		CSNotificationViewController *csnv = [shownCell contentViewController];
		if (![csnv respondsToSelector:@selector(_notificationShortLookViewIfLoaded)]) {
			return;
		}

		NCNotificationShortLookView *shortLookView = [csnv _notificationShortLookViewIfLoaded];
		NSString *numberString = [NSString stringWithFormat:@"%lu",[self count]];
		BOOL alreadyAdded = NO;
		for (id view in shortLookView.subviews) {
			if ([view isKindOfClass:NSClassFromString(@"NGCBadgeView")]) {
				if ([((NCNotificationShortLookView *)((UIView *)view).superview) isNotificationContentViewHidden] == NO) {
					NCNotificationSeamlessContentView *nsc = [shortLookView _notificationContentView];
					NCBadgedIconView *badgeIcon = MSHookIvar<NCBadgedIconView *>(nsc, "_badgedIconView");
					((NGCBadgeView *)view).frame = [self getBadgePosByFrame:badgeIcon.frame];
					[view setBadgeText:numberString];
				} else {
					// THIS MEANS WE FOUND A GHOST BADGE
					[view setBadgeText:@"0"];
				}
				alreadyAdded = YES;
				break;
			}
		}

		if (alreadyAdded == NO) {
			UIColor *badgeBackgroundColorInit = nil;
			UIColor *badgeTextColorInit = nil;
			if (isCustomColors == YES) {
				badgeBackgroundColorInit = badgeBackgroundColor;
				badgeTextColorInit = badgeTextColor;
				badgeStyle = BadgeStyleCustomColors;
			} else if (badgeStyle == BadgeStyleDynamicBackgroundColor) {
				badgeBackgroundColorInit = [[%c(SBWallpaperController) sharedInstance] averageColorForVariant:0];
				CGFloat r, g, b, alpha;
				[badgeBackgroundColorInit getRed:&r green:&g blue:&b alpha:&alpha];
				CGFloat brightness = (r * 0.3 + g * 0.6 + b * 0.1);
				badgeTextColorInit = brightness < 0.5 ? [UIColor whiteColor] : [UIColor blackColor];
			}

			NCNotificationSeamlessContentView *nsc = [shortLookView _notificationContentView];
			NCBadgedIconView *badgeIcon = MSHookIvar<NCBadgedIconView *>(nsc, "_badgedIconView");
			NGCBadgeView *ngcBadgeView = [[NGCBadgeView alloc] initWithFrame:[self getBadgePosByFrame:badgeIcon.frame] badgeText:numberString badgeColor:badgeBackgroundColorInit textColor:badgeTextColorInit style:badgeStyle shadowOpacity:shadowOpacity];
			if ([shortLookView isNotificationContentViewHidden] == NO) {
				[shortLookView addSubview:ngcBadgeView];	
			}
		}
	} else if ([self isGrouped] == NO || [self count] == 1) {
		[self deleteBadgesFromCurrentListView];
	}
}	

%new 
- (void)deleteBadgesFromCurrentListView {
	NSMutableDictionary *visibleViewsFromCurrentList = self.visibleViews;
	for (NCNotificationListCell *cell in [visibleViewsFromCurrentList allValues]) {
		if (![cell isKindOfClass:NSClassFromString(@"NCNotificationListCell")] || ![cell respondsToSelector:@selector(contentViewController)]) {
			continue;
		}
		CSNotificationViewController *csnv = [cell contentViewController];
		if (![csnv respondsToSelector:@selector(_notificationShortLookViewIfLoaded)]) {
			continue;
		}

		NCNotificationShortLookView *shortLookView = [csnv _notificationShortLookViewIfLoaded];
		for (id view in shortLookView.subviews) {
			if ([view isKindOfClass:NSClassFromString(@"NGCBadgeView")]) {
				[view setBadgeText:@"0"];
			}
		}
	}
}
%end

// if we ever decide to push text.. start here
// %hook NCNotificationSeamlessContentView
// - (void)layoutSubviews {
// 	%orig;
// 	UILabel *primaryTextLabel = MSHookIvar<UILabel *>(self, "_primaryTextLabel");
// 	primaryTextLabel.frame = CGRectMake(70, primaryTextLabel.frame.origin.y, primaryTextLabel.frame.size.width, primaryTextLabel.frame.size.height);
// }
// %end
%end

%ctor {
	loadPrefs();
	if (isTweakEnabled) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			UIApplication *springboardApp = [UIApplication sharedApplication];
			isRTL = [springboardApp userInterfaceLayoutDirection];
			%init(groupNotifications);
		});
	}
}
