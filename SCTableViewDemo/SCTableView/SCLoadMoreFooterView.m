//
//  SCLoadMoreFooterView.m
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCLoadMoreFooterView.h"

@interface SCLoadMoreFooterView ()

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SCLoadMoreFooterView

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
    _bottomOffsetToBeginLoadMoreData = self.frame.size.height;
    
    //
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(15, 5, self.frame.size.width - 15 * 2, self.frame.size.height - 5 * 2);
    [aButton addTarget:self action:@selector(loadMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setTitle:@"显示更多" forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1]];
    aButton.layer.borderColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1].CGColor;
    aButton.layer.borderWidth = 1;
    aButton.layer.shadowColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1].CGColor;
    aButton.layer.shadowOffset = CGSizeMake(1, 1);
    aButton.layer.shadowRadius = 1;
    aButton.layer.shadowOpacity = 1;
    [aButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    aButton.hidden = YES;
    [self addSubview:aButton];
    self.loadMoreBtn = aButton;
    
    
    // loading view
    UIActivityIndicatorView *aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aView.frame = (CGRect){.origin = CGPointMake(0, 0), .size = self.frame.size};
    aView.backgroundColor = self.backgroundColor;
    [self addSubview:aView];
    self.loadMoreIndicatorView = aView;
}

#pragma mark - loadMore Button
- (void)loadMoreButtonPressed:(UIButton*)sender {
    [self beginToLoadMore];
}

#pragma mark - scrollView
- (void)loadMoreViewDidScroll:(UIScrollView *)scrollView {
    if (self.hidden) {
        return;
    }
    //
    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
    if (!_isLoading && bottomOffset <= -(_bottomOffsetToBeginLoadMoreData - 30) && _loadMoreBtn.hidden) {
        [self beginToLoadMore];
    }
    
    //reset frame
    CGRect frame = self.frame;
    frame.origin.y = MAX(scrollView.frame.size.height - self.frame.size.height, scrollView.contentSize.height);
    if (frame.origin.y != self.frame.origin.y) {
        self.frame = frame;
    }
}

- (void)loadMoreViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.hidden) {
        return;
    }
}

- (void)loadMoreViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.hidden) {
        return;
    }
}

- (void)loadMoreViewDidFinishedLoading:(UIScrollView *)scrollView {
    if (self.hidden) {
        return;
    }
    self.isLoading = NO;
    if (_loadMoreIndicatorView) {
        [_loadMoreIndicatorView stopAnimating];
//        _loadMoreBtn.hidden = NO;
    }
}


#pragma mark - Util

- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView {
    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
    
    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight;
    
    CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
    
    return normalizedOffset;
    
}

#pragma mark - private
- (void)beginToLoadMore {
    if ([_delegate respondsToSelector:@selector(loadMoreViewDidBeginToLoadMore:)]) {
        [_loadMoreIndicatorView startAnimating];
        _loadMoreBtn.hidden = YES;
        self.isLoading = YES;
        [_delegate loadMoreViewDidBeginToLoadMore:self];
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
