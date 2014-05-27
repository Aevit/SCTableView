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
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    //
    UIActivityIndicatorView *aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aView.frame = (CGRect){.origin = CGPointMake(0, 0), .size = self.frame.size};
    aView.backgroundColor = self.backgroundColor;
    [self addSubview:aView];
    self.refreshIndicatorView = aView;
}

#pragma mark - scrollView
- (void)refreshViewDidScroll:(UIScrollView *)scrollView {
    //
    if (!self.hidden && !_isLoading && scrollView.contentOffset.y <= self.frame.size.height) {
        //设置拖动状态
    }
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //
    
    if (!self.hidden && !_isLoading && scrollView.contentOffset.y <= -(self.frame.size.height / 2)) {
        if ([_delegate respondsToSelector:@selector(refreshViewDidBeginToRefresh:)]) {
            
            [scrollView setContentInset:UIEdgeInsetsMake(self.frame.size.height, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
            [scrollView setContentOffset:CGPointMake(0, -self.frame.size.height) animated:YES];
            
            [_refreshIndicatorView startAnimating];
            self.isLoading = YES;
            [_delegate refreshViewDidBeginToRefresh:self];
        }
    }
}

- (void)refreshViewDidFinishedLoading:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollView setContentInset:UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
    
    self.isLoading = NO;
    if (_refreshIndicatorView) {
        [_refreshIndicatorView stopAnimating];
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
