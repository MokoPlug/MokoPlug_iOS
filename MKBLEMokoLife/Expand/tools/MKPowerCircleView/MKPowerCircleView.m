//
//  MKPowerCircleView.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKPowerCircleView.h"

static CGFloat const circleLabelViewOffset = 25.f;

@interface MKPowerCircleLabelView : UIImageView

@property (nonatomic, strong)UILabel *numberLabel1;

@property (nonatomic, strong)UILabel *numberLabel2;

@property (nonatomic, strong)UILabel *numberLabel3;

@property (nonatomic, strong)UILabel *numberLabel4;

@property (nonatomic, strong)UILabel *numberLabel5;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UILabel *wattsLabel;

@end

@implementation MKPowerCircleLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.valueLabel];
        [self addSubview:self.wattsLabel];
        [self addSubview:self.numberLabel1];
        [self addSubview:self.numberLabel2];
        [self addSubview:self.numberLabel3];
        [self addSubview:self.numberLabel4];
        [self addSubview:self.numberLabel5];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-6.f);
        make.width.mas_equalTo(150.f);
        make.height.mas_equalTo(MKFont(30.f).lineHeight);
    }];
    [self.wattsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(6.f);
        make.width.mas_equalTo(150.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.numberLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(30.f);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.numberLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.valueLabel.mas_top).mas_offset(-3.f);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
        make.left.mas_equalTo(35.f);
        make.width.mas_equalTo(25.f);
    }];
    [self.numberLabel4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.valueLabel.mas_top).mas_offset(-3.f);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
        make.right.mas_equalTo(-35.f);
        make.width.mas_equalTo(30.f);
    }];
    [self.numberLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.numberLabel2.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(20.f);
        make.bottom.mas_equalTo(-(self.frame.size.height / 5));
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.numberLabel5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.numberLabel4.mas_centerX).mas_offset(-30.f);
        make.width.mas_equalTo(30.f);
        make.bottom.mas_equalTo(self.numberLabel1.mas_bottom);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

#pragma mark - getter
- (UILabel *)numberLabel1 {
    if (!_numberLabel1) {
        _numberLabel1 = [[UILabel alloc] init];
        _numberLabel1.textColor = RGBCOLOR(128, 128, 128);
        _numberLabel1.textAlignment = NSTextAlignmentRight;
        _numberLabel1.font = MKFont(11.f);
        _numberLabel1.text = @"0";
    }
    return _numberLabel1;
}

- (UILabel *)numberLabel2 {
    if (!_numberLabel2) {
        _numberLabel2 = [[UILabel alloc] init];
        _numberLabel2.textColor = RGBCOLOR(128, 128, 128);
        _numberLabel2.textAlignment = NSTextAlignmentRight;
        _numberLabel2.font = MKFont(11.f);
        _numberLabel2.text = @"300";
    }
    return _numberLabel2;
}

- (UILabel *)numberLabel3 {
    if (!_numberLabel3) {
        _numberLabel3 = [[UILabel alloc] init];
        _numberLabel3.textAlignment = NSTextAlignmentCenter;
        _numberLabel3.textColor = RGBCOLOR(128, 128, 128);
        _numberLabel3.font = MKFont(11.f);
        _numberLabel3.text = @"800";
    }
    return _numberLabel3;
}

- (UILabel *)numberLabel4 {
    if (!_numberLabel4) {
        _numberLabel4 = [[UILabel alloc] init];
        _numberLabel4.textColor = RGBCOLOR(128, 128, 128);
        _numberLabel4.textAlignment = NSTextAlignmentLeft;
        _numberLabel4.font = MKFont(11.f);
        _numberLabel4.text = @"1500";
    }
    return _numberLabel4;
}

- (UILabel *)numberLabel5 {
    if (!_numberLabel5) {
        _numberLabel5 = [[UILabel alloc] init];
        _numberLabel5.textColor = RGBCOLOR(128, 128, 128);
        _numberLabel5.textAlignment = NSTextAlignmentCenter;
        _numberLabel5.font = MKFont(11.f);
        _numberLabel5.text = @"3600";
    }
    return _numberLabel5;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = RGBCOLOR(38, 129, 255);
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.font = MKFont(30.f);
        _valueLabel.text = @"0.0";
    }
    return _valueLabel;
}

- (UILabel *)wattsLabel {
    if (!_wattsLabel) {
        _wattsLabel = [[UILabel alloc] init];
        _wattsLabel.textColor = RGBCOLOR(51, 51, 51);
        _wattsLabel.textAlignment = NSTextAlignmentCenter;
        _wattsLabel.font = MKFont(15.f);
        _wattsLabel.text = @"WATTS";
    }
    return _wattsLabel;
}

@end

@interface MKPowerCircleView ()

@property (nonatomic, strong)CAShapeLayer *bottomCircleLayer;

@property (nonatomic, strong)CAShapeLayer *topCircleLayer;

@property (nonatomic, strong)MKPowerCircleLabelView *lableView;

@end

@implementation MKPowerCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.bottomCircleLayer];
        [self.layer addSublayer:self.topCircleLayer];
        [self addSubview:self.lableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(circleLabelViewOffset);
        make.right.mas_equalTo(-circleLabelViewOffset);
        make.top.mas_equalTo(circleLabelViewOffset);
        make.bottom.mas_equalTo(-circleLabelViewOffset);
    }];
}

#pragma mark - public method
- (void)updatePowerValues:(CGFloat)powerValue {
    if (powerValue >= 3600) {
        powerValue = 3600;
    }
    float progress = (powerValue / 3600);
    if (progress >= 1) {
        progress = 1;
    }
    self.lableView.valueLabel.text = [NSString stringWithFormat:@"%.f",powerValue];
    [self.topCircleLayer removeAnimationForKey:@"mk_progressAnimationKey"];
    [self.topCircleLayer addAnimation:[self circleAnimationWithEndValue:progress] forKey:@"mk_progressAnimationKey"];
}

#pragma mark - private method
- (CABasicAnimation *)circleAnimationWithEndValue:(CGFloat)endValue{
    CABasicAnimation * circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 0.01f;
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    circleAnimation.fromValue = @(0);
    circleAnimation.toValue = @(endValue);
    circleAnimation.autoreverses = NO;
    circleAnimation.fillMode = kCAFillModeForwards;
    circleAnimation.removedOnCompletion = NO;
    return circleAnimation;
}

#pragma mark - getter
- (MKPowerCircleLabelView *)lableView {
    if (!_lableView) {
        _lableView = [[MKPowerCircleLabelView alloc] init];
        _lableView.image = LOADIMAGE(@"haloRing", @"png");
    }
    return _lableView;
}

- (CAShapeLayer *)bottomCircleLayer {
    if (!_bottomCircleLayer) {
        _bottomCircleLayer = [CAShapeLayer layer];
        _bottomCircleLayer.frame = self.bounds;
        _bottomCircleLayer.path = [self circleLayerPath].CGPath;
        _bottomCircleLayer.strokeColor = RGBCOLOR(203, 203, 204).CGColor;
        _bottomCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _bottomCircleLayer.lineWidth = 12.f;
        //线的宽度  每条线的间距
        _bottomCircleLayer.lineDashPattern  = @[@2,@2];
    }
    return _bottomCircleLayer;
}

- (CAShapeLayer *)topCircleLayer{
    if (!_topCircleLayer) {
        _topCircleLayer = [CAShapeLayer layer];
        _topCircleLayer.frame = self.bounds;
        _topCircleLayer.path = [self circleLayerPath].CGPath;
        _topCircleLayer.strokeColor = COLOR_NAVIBAR_CUSTOM.CGColor;
        _topCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _topCircleLayer.lineWidth = 12.f;
        //线的宽度  每条线的间距
        _topCircleLayer.lineDashPattern  = @[@2,@2];
        _topCircleLayer.strokeStart = 0;
        _topCircleLayer.strokeEnd = 0;
    }
    return _topCircleLayer;
}

- (UIBezierPath *)circleLayerPath {
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                        radius:(self.bounds.size.width - 2 * 30) / 2
                                                    startAngle:M_PI_4 * 3
                                                      endAngle:M_PI_4
                                                     clockwise:YES];
    return path;
}

@end
