#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTMaterialRecipe) {
  MTMaterialRecipeNone,
  MTMaterialRecipeNotifications,
  MTMaterialRecipeWidgetHosts,
  MTMaterialRecipeWidgets,
  MTMaterialRecipeControlCenterModules,
  MTMaterialRecipeSwitcherContinuityItem,
  MTMaterialRecipePreviewBackground,
  MTMaterialRecipeNotificationsDark,
  MTMaterialRecipeControlCenterModulesSheer
};

@interface MTMaterialView : UIView
@property (assign,nonatomic) BOOL shouldCrossfade;
@property (assign, nonatomic) BOOL recipeDynamic;
@property (nonatomic, assign, readwrite) NSUInteger recipe;
@property (assign,nonatomic) double weighting;
@property (assign,getter=isBlurEnabled,nonatomic) BOOL blurEnabled;
@property (assign,getter=isZoomEnabled,nonatomic) BOOL zoomEnabled;
@property (assign,getter=isCaptureOnly,nonatomic) BOOL captureOnly;
@property (assign,getter=isHighlighted,nonatomic) BOOL highlighted;
@property (assign,nonatomic) BOOL useBuiltInAlphaTransformerAndBackdropScaleAdjustment;
@property (assign,nonatomic) BOOL useBuiltInAlphaTransformerAndBackdropScaleAdjustmentIfNecessary;
+(instancetype)materialViewWithRecipeNamed:(NSString *)arg1 inBundle:(NSBundle *)arg2 configuration:(NSInteger)arg3 initialWeighting:(float)arg4 scaleAdjustment:(id)arg5;
+(instancetype)materialViewWithRecipe:(NSInteger)arg1 configuration:(NSInteger)arg2;
+(instancetype)materialViewWithRecipe:(NSInteger)arg1 options:(NSInteger)arg2;
+(id)materialViewWithRecipeNamed:(id)arg1 ;
-(void)setBlurEnabled:(BOOL)arg1 ;
-(BOOL)isHighlighted;
-(void)setHighlighted:(BOOL)arg1 ;
+ (id)materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2 initialWeighting:(double)arg3 ;
@end

typedef NS_ENUM(NSInteger, BadgeStyle) {
  BadgeStyleIconColors,
  BadgeStyleDynamicBackgroundColor,
  BadgeStyleCustomColors
};

@interface NGCBadgeView : UIView
- (instancetype)initWithFrame:(CGRect)frame badgeText:(NSString *)text badgeColor:(UIColor *)badgeColor textColor:(UIColor *)textColor style:(NSUInteger)style shadowOpacity:(CGFloat)shadowOpacity;
- (void)setBadgeText:(NSString *)text;
- (NSString *)getBadgeText;
@end