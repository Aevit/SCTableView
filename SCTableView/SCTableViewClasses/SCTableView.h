//
//  SCTableView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRefreshHeaderView.h"
#import "SCLoadMoreFooterView.h"

@protocol SCTableViewDelegate;

@interface SCTableView : UITableView <UIScrollViewDelegate, SCRefreshHeaderViewDelegate, SCLoadMoreFooterViewDelegate>

@property (nonatomic, assign) IBOutlet id <SCTableViewDelegate> scDelegate;

/**
 *  YES: refreshView is the subview of tableView (refreshView will move with tableview)
 *  NO: refreshView is the subview of tableView.superView (refreshView will NOT move with tableview)
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  set hidden to YES：cancel the refersh data module
 *  set hidden to NO： add the refersh module
 */
@property (nonatomic, strong) SCRefreshHeaderView *refreshView;

/**
 *  YES: start the refresh animation, and call the refresh method to get data
 *  NO:  stop the refresh animation
 */
@property (nonatomic, assign) BOOL isTableRefreshing;

/**
 *  set hidden to YES：cancel the load more data module
 *  set hidden to NO： add the load more data module
 */
@property (nonatomic, strong) SCLoadMoreFooterView *loadMoreView;

/**
 *  YES: start the load more animation, and call the load more method to get data接口
 *  NO:  stop the load more animation
 */
@property (nonatomic, assign) BOOL isTableLoadingMore;

@end


@protocol SCTableViewDelegate <NSObject>

@optional

- (void)didBeginToRefresh:(SCTableView*)tableView;

- (void)didBeginToLoadMoreData:(SCTableView*)tableView;

@end
