#import "NGCBadgeView.h"

CGFloat ngcBadgeSizeLowerThan10 = 20;
CGFloat ngcBadgeSizeHigherThan10 = 30;

@interface NGCBadgeView ()
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, retain) MTMaterialView *blurView;
@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic) CGRect origFrame;
@end

@implementation NGCBadgeView
- (instancetype)initWithFrame:(CGRect)frame badgeText:(NSString *)text badgeColor:(UIColor *)badgeColor textColor:(UIColor *)textColor style:(NSUInteger)style shadowOpacity:(CGFloat)shadowOpacity {
    self = [super initWithFrame:frame];
    if (self) {
        self.origFrame = frame;
        if (style == BadgeStyleIconColors) {
            self.clipsToBounds = YES;
            self.blurView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:6 configuration:1];
            self.blurView.frame = self.bounds;
            self.blurView.weighting = 1;
            self.blurView.recipeDynamic = YES;
            self.blurView.zoomEnabled = YES;
            self.blurView.layer.cornerRadius = frame.size.height / 2;
            [self addSubview:self.blurView];
		} else {
            self.backgroundColor = badgeColor;
            self.layer.cornerRadius = frame.size.height / 2;
        }

        self.badgeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.textColor = textColor == nil ? [UIColor whiteColor] : textColor;
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:13.0];
        self.badgeLabel.adjustsFontSizeToFitWidth = YES;
        self.badgeLabel.minimumScaleFactor = 0.5;
        self.badgeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.badgeLabel];
        [self setBadgeText:text];
        
        //Add shadow to the main view
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);  // Slightly larger offset for more depth
        self.layer.shadowRadius = 3.0;  // Increased radius for softer shadow
        self.layer.shadowOpacity = shadowOpacity;
        self.clipsToBounds = NO;  // Important to show the shadow
    }
    return self;
}

// - (void)layoutSubviews {
//     [super layoutSubviews];
//     self.badgeLabel.frame = self.bounds;
//     if (self.frame.size.width < self.frame.size.height) {
//         CGRect newFrame = self.frame;
//         newFrame.size.width = self.frame.size.height;
//         self.frame = newFrame;
//     }
// }

- (void)setBadgeText:(NSString *)text {
    _badgeText = [text copy];
    self.badgeLabel.text = text;
    // Hide if text is empty or zero
    self.hidden = (text == nil || [text isEqualToString:@""] || [text isEqualToString:@"0"]);
    if (self.hidden) {
        [self removeFromSuperview];
    } else if ([text integerValue] > 9) {
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:11.5];
    } else {
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:13.0];
    }
}

- (NSString *)getBadgeText {
    return self.badgeLabel.text;
}
@end