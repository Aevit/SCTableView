//
//  SCBasicTableView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCBasicTableView.h"
#import "SCMessageManager.h"


@interface SCBasicTableView () {
    SCMessageManager *delegateManager;
}

@end

@implementation SCBasicTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}

#pragma mark - set refresh or loadMore state
- (void)setIsTableRefreshing:(BOOL)isTableRefreshing {
    _isTableRefreshing = isTableRefreshing;
    if (_refreshBasicView) {
        if (_isTableRefreshing == NO) {
            [_refreshBasicView refreshViewDidFinishedLoading:self];
        } else {
            [_refreshBasicView startRefreshAnimation:self];
        }
    }
    
}

- (void)setIsTableLoadingMore:(BOOL)isTableLoadingMore {
    _isTableLoadingMore = isTableLoadingMore;
    if (_loadMoreBasicView) {
        if (_isTableLoadingMore == NO) {
            [_loadMoreBasicView loadMoreViewDidFinishedLoading:self];
        }
    }
}

#pragma mark - override
- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (!delegate) {
        delegateManager.middleBridge = nil;
        delegateManager.receiver = nil;
        delegateManager = nil;
        super.delegate = nil;
        return;
    }
    if (!delegateManager) {
        delegateManager = [[SCMessageManager alloc] init];
    }
    delegateManager.middleBridge = self;
    delegateManager.receiver = delegate;
    super.delegate = (id)delegateManager;
}

- (void)reloadData {
    [super reloadData];
    //加载完数据后，调整loadMoreView的frame
    [_loadMoreBasicView loadMoreViewDidScroll:self];
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_refreshBasicView && !_isTableLoadingMore) {
        [_refreshBasicView refreshViewDidScroll:scrollView];
    }
    if (_loadMoreBasicView && !_isTableRefreshing) {
        [_loadMoreBasicView loadMoreViewDidScroll:scrollView];
    }
    self.preOffsetY = scrollView.contentOffset.y;
    
    
    //响应外部的scrollViewDidScroll
    if (!delegateManager) {
        return;
    }
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateManager.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_refreshBasicView) {
        [_refreshBasicView refreshViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (_loadMoreBasicView) {
        [_loadMoreBasicView loadMoreViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    //响应外部的scrollViewDidEndDragging
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateManager.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - RefreshViewDelegate
- (void)refreshViewDidBeginToRefresh:(SCRefreshBasicView *)refreshView {
    _isTableRefreshing = YES;
    
    if ([_scDelegate respondsToSelector:@selector(didBeginToRefresh:)]) {
        [_scDelegate didBeginToRefresh:self];
    }
    
}

#pragma mark - LoadMoreViewDelegate
- (void)loadMoreViewDidBeginToLoadMore:(SCLoadMoreBasicView *)loadMoreView {
    self.isTableLoadingMore = YES;
    if ([_scDelegate respondsToSelector:@selector(didBeginToLoadMoreData:)]) {
        [_scDelegate didBeginToLoadMoreData:self];
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
