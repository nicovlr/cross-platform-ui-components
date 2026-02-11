#import "NVRoundedButton.h"

@implementation NVRoundedButton

- (instancetype)initWithTitle:(NSString *)title
                 cornerRadius:(CGFloat)cornerRadius {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _cornerRadius = cornerRadius;
        _pressScale = 0.95;

        [self setTitle:title forState:UIControlStateNormal];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;

        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        self.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24);

        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)touchDown {
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.transform = CGAffineTransformMakeScale(self.pressScale, self.pressScale);
    } completion:nil];
}

- (void)touchUp {
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:0
                     animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
