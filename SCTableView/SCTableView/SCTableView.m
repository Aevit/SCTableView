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
    
    //
    delegateManager = [[SCMessageManager alloc] init];
    delegateManager.middleBridge = self;
    delegateManager.receiver = self.delegate;
    super.delegate = (id)delegateManager;
    
    
    //refreshView
    static CGFloat refreshViewHeight = 50;
    SCRereshHeaderView *aView = [[SCRereshHeaderView alloc] initWithFrame:CGRectMake(0, -refreshViewHeight, self.frame.size.width, refreshViewHeight)];
    aView.delegate = self;
    [self addSubview:aView];
    self.refreshView = aView;
    
    //loadMoreView
    static CGFloat loadMoreViewHeight = 50;
    self.contentInset = UIEdgeInsetsMake(0, 0, loadMoreViewHeight, 0);
    SCLoadMoreFooterView *bView = [[SCLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - loadMoreViewHeight, self.frame.size.width, loadMoreViewHeight)];
    bView.delegate = self;
    [self addSubview:bView];
    self.loadMoreView = bView;
}

#pragma mark - set refresh or loadMore state
- (void)setIsTableRefreshing:(BOOL)isTableRefreshing {
    if (_refreshView) {
        if (_isTableRefreshing == NO) {
            [_refreshView refreshViewDidFinishedLoading:self];
        }
    }
    
}

- (void)setIsTableLoadingMore:(BOOL)isTableLoadingMore {
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
    
    if (_refreshView) {
        [_refreshView refreshViewDidScroll:scrollView];
    }
    if (_loadMoreView) {
        [_loadMoreView loadMoreViewDidScroll:scrollView];
    }
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //响应外部的scrollViewWillBeginDragging
    if (delegateManager.receiver && [delegateManager.receiver respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateManager.receiver scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - RefreshViewDelegate
- (void)refreshViewDidBeginToRefresh:(SCRereshHeaderView *)refreshView {
    if ([_scDelegate respondsToSelector:@selector(didBeginToRefresh:)]) {
        [_scDelegate didBeginToRefresh:self];
    }
}

#pragma mark - LoadMoreViewDelegate
- (void)loadMoreViewDidBeginToLoadMore:(SCLoadMoreFooterView *)loadMoreView {
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
