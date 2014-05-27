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
    _bottomOffsetToBeginLoadMoreData = (self.frame.size.height + 5);
    
    //
    self.backgroundColor = [UIColor lightGrayColor];
    
    //
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(10, 5, self.frame.size.width - 10 * 2, self.frame.size.height - 5 * 2);
    [aButton addTarget:self action:@selector(loadMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setTitle:@"显示下20条" forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor whiteColor]];
    aButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    aButton.layer.borderWidth = 1;
    [aButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    aButton.hidden = YES;
    [self addSubview:aButton];
    self.loadMoreBtn = aButton;
    
    
    //
    UIActivityIndicatorView *aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aView.frame = (CGRect){.origin = CGPointMake(0, 0), .size = self.frame.size};
//    aView.frame = (CGRect){.origin = CGPointMake((self.frame.size.width - aView.frame.size.width) / 2, (self.frame.size.height - aView.frame.size.height) / 2), .size = aView.frame.size};
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
    //
    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
    if (!self.hidden && !_isLoading && bottomOffset <= -_bottomOffsetToBeginLoadMoreData && _loadMoreBtn.hidden) {
        [self beginToLoadMore];
    }
    
    //reset frame
    CGRect frame = self.frame;
    frame.origin.y = scrollView.contentSize.height;
    if (frame.origin.y != self.frame.origin.y) {
        self.frame = frame;
    }
}

- (void)loadMoreViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)loadMoreViewDidFinishedLoading:(UIScrollView *)scrollView {
    self.isLoading = NO;
    if (_loadMoreIndicatorView) {
        [_loadMoreIndicatorView stopAnimating];
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
