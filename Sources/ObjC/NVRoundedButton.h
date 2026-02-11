#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A rounded button with built-in press animation.
/// Scales down slightly on touch and springs back on release.
@interface NVRoundedButton : UIButton

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat pressScale;

- (instancetype)initWithTitle:(NSString *)title
                  cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
