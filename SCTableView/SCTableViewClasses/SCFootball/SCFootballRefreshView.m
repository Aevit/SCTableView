//
//  SCFootballRefreshView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCFootballRefreshView.h"

#define FLAT_GREEN_COLOR    [UIColor colorWithRed:77 / 255.0 green:132 / 255.0 blue:39 / 255.0 alpha:1]
#define FLAT_BLUE_COLOR    [UIColor colorWithRed:53 / 255.0 green:152 / 255.0 blue:220 / 255.0 alpha:1]


@interface SCCommonLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat heightBeginToRefresh;
@property (nonatomic, assign) CGFloat offsetY;
@end

@interface SCInnerRectLayer : SCCommonLayer
@end

@interface SCOutRectLayer : SCCommonLayer
@end

@interface SCFootballLayer : SCCommonLayer
@end

@interface SCPentagonLayer : SCCommonLayer
@end



@interface SCFootballRefreshView ()

@property (nonatomic, strong) SCInnerRectLayer *innerRectLayer;
@property (nonatomic, strong) SCInnerRectLayer *outRectLayer;
@property (nonatomic, strong) SCFootballLayer *footballLayer;

@end

@implementation SCFootballRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.heightBeginToRefresh = self.frame.size.height;
    
    self.backgroundColor = FLAT_GREEN_COLOR;
//    self.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.layer.borderWidth = 1;
    
    
    [self createInnerRectLayer];
    [self createOutRectLayer];
    [self createAFootball];
}

- (void)createInnerRectLayer {
    // innerRectLayer
    if (_innerRectLayer) {
        return;
    }
    const CGFloat innerRectW = 120;
    const CGFloat innerRectH = 30;
    SCInnerRectLayer *aLayer = [SCInnerRectLayer layer];
    aLayer.frame = CGRectMake((self.frame.size.width - innerRectW) / 2, 0, innerRectW, innerRectH);
    aLayer.heightBeginToRefresh = self.heightBeginToRefresh;
    [self.layer addSublayer:aLayer];
    self.innerRectLayer = aLayer;
}

- (void)createOutRectLayer {
    // outRectLayer
    if (_outRectLayer) {
        return;
    }
    const CGFloat outRectW = 220;
    const CGFloat outRectH = 90;
    SCInnerRectLayer *dLayer = [SCInnerRectLayer layer];
    dLayer.frame = CGRectMake((self.frame.size.width - outRectW) / 2, 0, outRectW, outRectH);
    dLayer.heightBeginToRefresh = self.heightBeginToRefresh;
    [self.layer addSublayer:dLayer];
    self.outRectLayer = dLayer;
}

- (void)createAFootball {
    
    if (_footballLayer) {
        [_footballLayer removeFromSuperlayer];
        self.footballLayer = nil;
    }
    
    // footballLayer
    SCFootballLayer *cLayer = [SCFootballLayer layer];
    const CGFloat footballLength = 24;
    cLayer.frame = CGRectMake((self.frame.size.width - footballLength) / 2, _innerRectLayer.frame.size.height + (_outRectLayer.frame.size.height - _innerRectLayer.frame.size.height - footballLength) / 2, footballLength, footballLength);
    cLayer.heightBeginToRefresh = self.heightBeginToRefresh;
    cLayer.fillColor = [UIColor clearColor].CGColor;
    cLayer.borderColor = [UIColor whiteColor].CGColor;
    cLayer.borderWidth = 1;
    cLayer.cornerRadius = footballLength / 2;
    cLayer.opacity = 0;
//    cLayer.anchorPoint = CGPointZero;
    cLayer.shadowColor = [UIColor blackColor].CGColor;
    cLayer.shadowOpacity = 1;
    cLayer.shadowRadius = 3;
    cLayer.shadowOffset = CGSizeMake(1, 1);
    [self.layer addSublayer:cLayer];
    self.footballLayer = cLayer;
    
    // pentagon layer
    SCPentagonLayer *eLayer = [SCPentagonLayer layer];
    eLayer.frame = (CGRect){.origin = CGPointZero, .size = cLayer.frame.size};
    [cLayer addSublayer:eLayer];
    [eLayer setNeedsDisplay];
}

#pragma mark - override scrollView methods
- (void)refreshViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.hidden || self.state == SCRefreshStateLoading) {
        return;
    }
    if (_innerRectLayer) {
        _innerRectLayer.offsetY = MIN(ABS(scrollView.contentOffset.y), self.heightBeginToRefresh);
        [_innerRectLayer setNeedsDisplay];
    }
    if (_outRectLayer) {
        _outRectLayer.offsetY = MIN(ABS(scrollView.contentOffset.y), self.heightBeginToRefresh);
        [_outRectLayer setNeedsDisplay];
    }
    if (_footballLayer) {
        _footballLayer.offsetY = MIN(ABS(scrollView.contentOffset.y), self.heightBeginToRefresh);
        [_footballLayer setNeedsDisplay];
    }
    
    if (scrollView.contentOffset.y <= -self.heightBeginToRefresh) {
        [self setState:SCRefreshStatePulling];
    } else {
        [self setState:SCRefreshStateNormal];
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.hidden || self.state == SCRefreshStateLoading || scrollView.contentOffset.y > -self.heightBeginToRefresh) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(refreshViewDidBeginToRefresh:)]) {
        
        [self startRefreshAnimation:scrollView];
        
        [self.delegate refreshViewDidBeginToRefresh:self];
    }
}

- (void)refreshViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.hidden) {
        return;
    }
}

- (void)refreshViewDidFinishedLoading:(UIScrollView *)scrollView {
    
    if (self.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
    } completion:^(BOOL finished) {
        
        [self setState:SCRefreshStateNormal];
        
        if (_footballLayer) {
            [_footballLayer removeAllAnimations];
            [_footballLayer removeFromSuperlayer];
            self.footballLayer = nil;
            [self createAFootball];
        }
    }];
}

- (void)startRefreshAnimation:(UIScrollView *)scrollView {
    
    if (self.state == SCRefreshStateLoading) {
        return;
    }
    
    if (self.footballLayer.offsetY != self.heightBeginToRefresh) {
        self.innerRectLayer.offsetY = self.heightBeginToRefresh;
        [self.innerRectLayer setNeedsDisplay];
        
        self.outRectLayer.offsetY = self.heightBeginToRefresh;
        [self.outRectLayer setNeedsDisplay];
        
        self.footballLayer.offsetY = self.heightBeginToRefresh;
        [self.footballLayer setNeedsDisplay];
        
        [self shootAnimationInCenter:YES];
    } else {
        [self shootAnimationInCenter:YES];
    }
    
    
    [scrollView setContentInset:UIEdgeInsetsMake(-scrollView.contentOffset.y, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
    // 解决画面会闪一下的问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(self.frame.size.height, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
        }];
    });
    
    [self loadingAnimation];
    
    [self setState:SCRefreshStateLoading];
}

#pragma mark - animation
+ (CAKeyframeAnimation*)moveCurveAnimationWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CAKeyframeAnimation *curveAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddCurveToPoint(path, NULL, endPoint.x, startPoint.y, endPoint.x - 50, startPoint.y, endPoint.x, endPoint.y);

    curveAni.path = path;
    CGPathRelease(path);
    
    
    curveAni.duration = 0.4;
    curveAni.calculationMode = kCAAnimationPaced;
    curveAni.removedOnCompletion = NO;
    curveAni.fillMode = kCAFillModeForwards;
    return curveAni;
}

+ (CAKeyframeAnimation*)scaleAnimationWithScaleNumsArr:(NSArray*)values {
    CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni.duration = 0.4;
    scaleAni.removedOnCompletion = NO;
    scaleAni.fillMode = kCAFillModeForwards;
    scaleAni.values = values;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return scaleAni;
}

+ (CABasicAnimation*)repeatRotateAnimation {
    
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotateAni.duration = 0.25;
    rotateAni.cumulative = YES;
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAni.toValue = [NSNumber numberWithFloat:M_PI / 2];
    rotateAni.repeatCount = MAXFLOAT;
    
    return rotateAni;
}

- (void)shootAnimationInCenter:(BOOL)willInCenter {
    [_footballLayer removeAllAnimations];
    CGFloat footballLength = _footballLayer.frame.size.width;
    CAKeyframeAnimation *curveAni = [SCFootballRefreshView moveCurveAnimationWithStartPoint:CGPointMake(_footballLayer.frame.origin.x + footballLength / 2, _footballLayer.frame.origin.y + footballLength / 2)  endPoint:CGPointMake((willInCenter ? _footballLayer.frame.origin.x + footballLength / 2 : 110), _footballLayer.frame.size.width / 2)];
    CAKeyframeAnimation *scaleAni = [SCFootballRefreshView scaleAnimationWithScaleNumsArr:
                                     @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]]];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.4f;
    group.animations = @[curveAni, scaleAni];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [_footballLayer addAnimation:group forKey:@"goalGroupAni"];
}

- (void)loadingAnimation {
    if (_footballLayer) {
        _footballLayer.anchorPoint = CGPointMake(0.5, 0.5);
        CABasicAnimation *rotateAni = [SCFootballRefreshView repeatRotateAnimation];
        [_footballLayer addAnimation:rotateAni forKey:@"refreshAni"];
    }
}

#pragma mark - set state
- (void)setTheState:(SCRefreshState)state {
    
    switch (state) {
        case SCRefreshStateNormal:
        {
            if (_innerRectLayer) {
                _innerRectLayer.offsetY = 0;
                [_innerRectLayer setNeedsDisplay];
            }
            
            if (_outRectLayer) {
                _outRectLayer.offsetY = 0;
                [_outRectLayer setNeedsDisplay];
            }
            if (_footballLayer) {
                _footballLayer.offsetY = 0;
                [_footballLayer setNeedsDisplay];
            }
            break;
        }
        case SCRefreshStatePulling:
        {
            break;
        }
        case SCRefreshStateLoading:
        {
            break;
        }
        default:
            break;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    if (_innerRectLayer) {
//        [_innerRectLayer setNeedsDisplay];
//    }
//}

@end

// 0. SCCommonLayer
@implementation SCCommonLayer

@end

// 1. SCInnerRectLayer
@implementation SCInnerRectLayer

- (void)drawInContext:(CGContextRef)ctx {
    
    if (!self.superlayer) {
        return;
    }

    const CGFloat perimeter = self.frame.size.width + self.frame.size.height * 2;
    
    const CGFloat drawedPerimeter = perimeter / self.heightBeginToRefresh * self.offsetY;
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    
    CGContextMoveToPoint(ctx, 0, 0);
    
    if (drawedPerimeter <= self.frame.size.height) {
        CGContextAddLineToPoint(ctx, 0, drawedPerimeter);
        
    } else if (drawedPerimeter < self.frame.size.height + self.frame.size.width) {
        CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
        CGContextMoveToPoint(ctx, 0, self.frame.size.height);
        CGContextAddLineToPoint(ctx, drawedPerimeter - self.frame.size.height, self.frame.size.height);
        
    } else if (drawedPerimeter <= perimeter) {
        CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
        CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height);
        CGContextMoveToPoint(ctx, self.frame.size.width, self.frame.size.height);
        CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height - (drawedPerimeter - self.frame.size.width - self.frame.size.height));
    }
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end

// 2. SCFootballLayer
@implementation SCFootballLayer

- (void)drawInContext:(CGContextRef)ctx {
    self.opacity = (self.offsetY / self.heightBeginToRefresh);
}

@end

// 3. SCPentagonLayer
@implementation SCPentagonLayer
#define TO_RADIAN(x) (M_PI / (180.00000 / x))

- (void)drawInContext:(CGContextRef)ctx {
    
    CGFloat footballLength = self.frame.size.width;
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    
    //************ the inner pentagon *************
    // 1. the side length of the innerPentagon
    const CGFloat innerPentagonSideLength = 6;
    // 2. the center of the innerPentagon in the SCFootballLayer
    const CGPoint innerPentagonCenter = CGPointMake(footballLength / 2, footballLength / 2);
    NSArray *innerPoints = [self calculatePointsOfPentagonWithSideLength:innerPentagonSideLength pentagonInnerRadius:-1 pentagonCenter:innerPentagonCenter];
    
    CGContextMoveToPoint(ctx, [innerPoints[0] CGPointValue].x, [innerPoints[0] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [innerPoints[1] CGPointValue].x, [innerPoints[1] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [innerPoints[2] CGPointValue].x, [innerPoints[2] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [innerPoints[3] CGPointValue].x, [innerPoints[3] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [innerPoints[4] CGPointValue].x, [innerPoints[4] CGPointValue].y);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    
    
    
    //************ the out points of the pentagon *************
    // 1. the side length of the outPentagon
    const CGFloat outPentagonInnerRadius = footballLength / 2;
    // 2. the center of the outPentagon in the SCFootballLayer
    const CGPoint outPentagonCenter = CGPointMake(footballLength / 2, footballLength / 2);
    NSArray *outPoints = [self calculatePointsOfPentagonWithSideLength:-1 pentagonInnerRadius:outPentagonInnerRadius pentagonCenter:outPentagonCenter];
    
    CGContextMoveToPoint(ctx, [innerPoints[0] CGPointValue].x, [innerPoints[0] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [outPoints[0] CGPointValue].x, [outPoints[0] CGPointValue].y);
    
    CGContextMoveToPoint(ctx, [innerPoints[1] CGPointValue].x, [innerPoints[1] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [outPoints[1] CGPointValue].x, [outPoints[1] CGPointValue].y);
    
    CGContextMoveToPoint(ctx, [innerPoints[2] CGPointValue].x, [innerPoints[2] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [outPoints[2] CGPointValue].x, [outPoints[2] CGPointValue].y);
    
    CGContextMoveToPoint(ctx, [innerPoints[3] CGPointValue].x, [innerPoints[3] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [outPoints[3] CGPointValue].x, [outPoints[3] CGPointValue].y);
    
    CGContextMoveToPoint(ctx, [innerPoints[4] CGPointValue].x, [innerPoints[4] CGPointValue].y);
    CGContextAddLineToPoint(ctx, [outPoints[4] CGPointValue].x, [outPoints[4] CGPointValue].y);
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

/**
 *  calculate the five points of the pentagon
 *
 *  @param pentagonSideLength the side length of the pentagon ( pentagonSideLength and innerRadius, the two parameters, you should just pass one, and set the value of the other parameter to -1 )
 *  @param innerRadius        the length that from the center of the pentagon to every point of the pentagon ( pentagonSideLength and innerRadius, the two parameters, you should just pass one, and set the value of the other parameter to -1 )
 *  @param pentagonCenter     the center point of pentagon
 *
 *  @return five points
 */
- (NSArray*)calculatePointsOfPentagonWithSideLength:(CGFloat)pentagonSideLength pentagonInnerRadius:(CGFloat)innerRadius pentagonCenter:(CGPoint)pentagonCenter {
    
    if (innerRadius == -1) {
        // each inner side length in the pentagon (the radius)
        innerRadius = pentagonSideLength / (2 * cos(TO_RADIAN(54)));
        
    } else if (pentagonSideLength == -1) {
        // each side length of the pentagon
        pentagonSideLength = cos(TO_RADIAN(54)) * innerRadius * 2;
    }
    
    // the points arrange by NOT clockwise
    CGPoint A = CGPointMake(pentagonCenter.x, pentagonCenter.y - innerRadius);
    CGPoint B = CGPointMake(pentagonCenter.x - sin(TO_RADIAN(54)) * pentagonSideLength, pentagonCenter.y - (innerRadius - pentagonSideLength * cos(TO_RADIAN(54))));
    CGPoint C = CGPointMake(pentagonCenter.x - innerRadius * cos(TO_RADIAN(54)), pentagonCenter.y + innerRadius * sin(TO_RADIAN(54)));
    CGPoint D = CGPointMake(pentagonCenter.x + innerRadius * cos(TO_RADIAN(54)), pentagonCenter.y + innerRadius * sin(TO_RADIAN(54)));
    CGPoint E = CGPointMake(pentagonCenter.x + pentagonSideLength * sin(TO_RADIAN(54)), pentagonCenter.y - (innerRadius - pentagonSideLength * cos(TO_RADIAN(54))));
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:A], [NSValue valueWithCGPoint:B], [NSValue valueWithCGPoint:C], [NSValue valueWithCGPoint:D], [NSValue valueWithCGPoint:E], nil];
}

@end