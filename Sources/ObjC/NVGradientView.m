#import "NVGradientView.h"

@implementation NVGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors {
    return [self initWithColors:colors
                     startPoint:CGPointMake(0.5, 0.0)
                       endPoint:CGPointMake(0.5, 1.0)];
}

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors
                    startPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _colors = [colors copy];
        _startPoint = startPoint;
        _endPoint = endPoint;
        [self updateGradient];
    }
    return self;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = [colors copy];
    [self updateGradient];
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    [self updateGradient];
}

- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    [self updateGradient];
}

- (void)updateGradient {
    CAGradientLayer *gradient = (CAGradientLayer *)self.layer;

    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:self.colors.count];
    for (UIColor *color in self.colors) {
        [cgColors addObject:(id)color.CGColor];
    }

    gradient.colors = cgColors;
    gradient.startPoint = self.startPoint;
    gradient.endPoint = self.endPoint;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self updateGradient];
    }
}

@end
