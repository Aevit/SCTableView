//
//  SCRereshHeaderView.m
//  SCTableView
//
//  Created by Aevitx on 14-5-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCRereshHeaderView.h"

@interface SCRereshHeaderView ()

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UILabel *statusLbl;


@end

@implementation SCRereshHeaderView

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
    
    
    
    //
    SCRefreshCircleView *circle = [[SCRefreshCircleView alloc] initWithFrame:CGRectMake((self.frame.size.width - 20) / 2 - 30, (self.frame.size.height - 20) / 2, 20, 20)];
    circle.heightBeginToRefresh = HEIGHT_BEGIN_TO_REFRESH - HEIGHT_BEGIN_TO_DRAW_CIRCLE;
    circle.offsetY = 0;
    [self addSubview:circle];
    self.refreshCircleView = circle;
    
    //
    self.state = SCRefreshStateNormal;
    
    //
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(circle.frame.origin.x + circle.frame.size.width + 5, (self.frame.size.height - 20) / 2, 200, 20)];
    aLbl.backgroundColor = [UIColor clearColor];
    aLbl.font = [UIFont systemFontOfSize:13.f];
    aLbl.textColor = [UIColor blackColor];
    [self addSubview:aLbl];
    self.statusLbl = aLbl;
}

#pragma mark - public
- (void)startRefreshAnimation:(UIScrollView*)scrollView {
    if (self.isLoading) {
        return;
    }
    
    if (_refreshCircleView.offsetY != HEIGHT_BEGIN_TO_REFRESH - HEIGHT_BEGIN_TO_DRAW_CIRCLE) {
        _refreshCircleView.offsetY = HEIGHT_BEGIN_TO_REFRESH - HEIGHT_BEGIN_TO_DRAW_CIRCLE;
        [_refreshCircleView setNeedsDisplay];
    }
    
    
    [scrollView setContentInset:UIEdgeInsetsMake(-scrollView.contentOffset.y, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
    //解决画面会闪一下的问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(self.frame.size.height, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
        }];
    });
    
    [_refreshCircleView.layer removeAllAnimations];
    [_refreshCircleView.layer addAnimation:[SCRefreshCircleView repeatRotateAnimation] forKey:@"rotateAnimation"];
    
    [self setState:SCRefreshStateLoading];
    
    self.isLoading = YES;
}

#pragma mark - scrollView
- (void)refreshViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.hidden) {
        return;
    }
    if (!_isLoading) {
        
        if (ABS(scrollView.contentOffset.y) >= HEIGHT_BEGIN_TO_DRAW_CIRCLE) {
            _refreshCircleView.offsetY = MIN(ABS(scrollView.contentOffset.y), HEIGHT_BEGIN_TO_REFRESH) - HEIGHT_BEGIN_TO_DRAW_CIRCLE;
            [_refreshCircleView setNeedsDisplay];
        }
        if (scrollView.contentOffset.y <= -HEIGHT_BEGIN_TO_REFRESH) {
            [self setState:SCRefreshStatePulling];
        } else {
            [self setState:SCRefreshStateNormal];
        }
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.hidden) {
        return;
    }
    if (!_isLoading && scrollView.contentOffset.y <= -HEIGHT_BEGIN_TO_REFRESH) {
        if ([_delegate respondsToSelector:@selector(refreshViewDidBeginToRefresh:)]) {
            
            [self startRefreshAnimation:scrollView];
            
            [_delegate refreshViewDidBeginToRefresh:self];
        }
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
        
        if (_refreshCircleView) {
            [_refreshCircleView.layer removeAllAnimations];
        }
    }];
    
    self.isLoading = NO;
    
    
}

#pragma mark - set state
- (void)setState:(SCRefreshState)state {
    if (_state == state) {
        return;
    }
    if (!_statusLbl) {
        return;
    }
    _state = state;
    switch (state) {
        case SCRefreshStateNormal:
        {
            _statusLbl.text = @"下拉刷新";
            break;
        }
        case SCRefreshStatePulling:
        {
            _statusLbl.text = @"释放立即更新";
            break;
        }
        case SCRefreshStateLoading:
        {
            _statusLbl.text = @"正在刷新";
            break;
        }
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
