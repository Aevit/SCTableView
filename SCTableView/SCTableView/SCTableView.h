//
//  SCTableView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRereshHeaderView.h"
#import "SCLoadMoreFooterView.h"

@protocol SCTableViewDelegate;

@interface SCTableView : UITableView <UIScrollViewDelegate, SCRereshHeaderViewDelegate, SCLoadMoreFooterViewDelegate>

@property (nonatomic, assign) id <SCTableViewDelegate> scDelegate;

//refresh
@property (nonatomic, strong) SCRereshHeaderView *refreshView;
@property (nonatomic, assign) BOOL isTableRefreshing;

//load more
@property (nonatomic, strong) SCLoadMoreFooterView *loadMoreView;
@property (nonatomic, assign) BOOL isTableLoadingMore;

@end


@protocol SCTableViewDelegate <NSObject>

@optional

- (void)didBeginToRefresh:(SCTableView*)tableView;

- (void)didBeginToLoadMoreData:(SCTableView*)tableView;

@end
