#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Simple gradient background view.
/// Supports vertical and horizontal gradients with configurable colors.
@interface NVGradientView : UIView

@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors;
- (instancetype)initWithColors:(NSArray<UIColor *> *)colors
                    startPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
