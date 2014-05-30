//
//  SCTableView.m
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCTableView.h"
#import "SCMessageManager.h"


@interface SCTableView () {
    SCMessageManager *delegateManager;
    CGFloat preOffsetY;
}

@end

@implementation SCTableView

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
    
    preOffsetY = 0;
    
    //
    delegateManager = [[SCMessageManager alloc] init];
    delegateManager.middleBridge = self;
    delegateManager.receiver = self.delegate;
    super.delegate = (id)delegateManager;
    
    
    //refreshView
    _isRefreshViewOnTableView = YES;
    
    static CGFloat refreshViewHeight = 50;
    SCRereshHeaderView *aView = [[SCRereshHeaderView alloc] initWithFrame:(_isRefreshViewOnTableView ? CGRectMake(0, -refreshViewHeight, self.frame.size.width, refreshViewHeight) : CGRectMake(0, self.frame.origin.y, self.frame.size.width, refreshViewHeight))];
    aView.delegate = self;
    if (_isRefreshViewOnTableView) {
        [self addSubview:aView];
    }
    aView.refreshCircleView.isRefreshViewOnTableView = _isRefreshViewOnTableView;
    self.refreshView = aView;
    
    
    //loadMoreView
    static CGFloat loadMoreViewHeight = 50;
    self.contentInset = UIEdgeInsetsMake(0, 0, loadMoreViewHeight, 0);
    SCLoadMoreFooterView *bView = [[SCLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - loadMoreViewHeight, self.frame.size.width, loadMoreViewHeight)];
    bView.delegate = self;
    [self addSubview:bView];
    self.loadMoreView = bView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (_isRefreshViewOnTableView == NO) {
        self.backgroundColor = [UIColor clearColor];
        [newSuperview insertSubview:_refreshView belowSubview:self];
    }
}

- (void)setIsRefreshViewOnTableView:(BOOL)isRefreshViewOnTableView {
    if (_isRefreshViewOnTableView != isRefreshViewOnTableView) {
        
        _isRefreshViewOnTableView = isRefreshViewOnTableView;
        _refreshView.refreshCircleView.isRefreshViewOnTableView = isRefreshViewOnTableView;
        
        [_refreshView removeFromSuperview];
        
        _refreshView.frame = (_isRefreshViewOnTableView ? CGRectMake(0, -_refreshView.frame.size.height, self.frame.size.width, _refreshView.frame.size.height) : CGRectMake(0, self.frame.origin.y, self.frame.size.width, _refreshView.frame.size.height));
        
        if (_isRefreshViewOnTableView) {
            [self addSubview:_refreshView];
        } else {
            self.backgroundColor = [UIColor clearColor];
            [self.superview insertSubview:_refreshView belowSubview:self];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_refreshView) {
        CGRect refreshFrame = _refreshView.frame;
        refreshFrame.origin.y = (_isRefreshViewOnTableView ? -refreshFrame.size.height : frame.origin.y);
        _refreshView.frame = refreshFrame;
    }
}

#pragma mark - set refresh or loadMore state
- (void)setIsTableRefreshing:(BOOL)isTableRefreshing {
    _isTableRefreshing = isTableRefreshing;
    if (_refreshView) {
        if (_isTableRefreshing == NO) {
            [_refreshView refreshViewDidFinishedLoading:self];
        } else {
//            [self setContentOffset:CGPointMake(0, -HEIGHT_BEGIN_TO_REFRESH) animated:YES];
            [_refreshView startRefreshAnimation:self];
        }
    }
    
}

- (void)setIsTableLoadingMore:(BOOL)isTableLoadingMore {
    _isTableLoadingMore = isTableLoadingMore;
    if (_loadMoreView) {
        if (_isTableLoadingMore == NO) {
            [_loadMoreView loadMoreViewDidFinishedLoading:self];
        }
    }
}

#pragma mark - rewrite
- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if(delegateManager) {
        super.delegate = nil;
        delegateManager.receiver = delegate;
        super.delegate = (id)delegateManager;
    } else {
        super.delegate = delegate;
    }
}

- (void)reloadData {
    [super reloadData];
    //加载完数据后，调整loadMoreView的frame
    [_loadMoreView loadMoreViewDidScroll:self];
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_refreshView && !_isTableLoadingMore) {
        [_refreshView refreshViewDidScroll:scrollView];
    }
    if (_loadMoreView && !_isTableRefreshing) {
        [_loadMoreView loadMoreViewDidScroll:scrollView];
    }
    preOffsetY = scrollView.contentOffset.y;
    
    
    //响应外部的scrollViewDidScroll
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateManager.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_refreshView) {
        [_refreshView refreshViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (_loadMoreView) {
        [_loadMoreView loadMoreViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    //响应外部的scrollViewDidEndDragging
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateManager.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //响应外部的scrollViewDidEndDecelerating
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [delegateManager.receiver scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //响应外部的scrollViewWillBeginDragging
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateManager.receiver scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - RefreshViewDelegate
- (void)refreshViewDidBeginToRefresh:(SCRereshHeaderView *)refreshView {
    _isTableRefreshing = YES;

    if ([_scDelegate respondsToSelector:@selector(didBeginToRefresh:)]) {
        [_scDelegate didBeginToRefresh:self];
    }
}

#pragma mark - LoadMoreViewDelegate
- (void)loadMoreViewDidBeginToLoadMore:(SCLoadMoreFooterView *)loadMoreView {
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
