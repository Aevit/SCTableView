//
//  SCBasicTableView.h
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRefreshBasicView.h"
#import "SCLoadMoreBasicView.h"

@protocol SCBasicTableViewDelegate;

@interface SCBasicTableView : UITableView <UIScrollViewDelegate, SCRefreshBasicViewDelegate, SCLoadMoreBasicViewDelegate>

@property (nonatomic, assign) IBOutlet id <SCBasicTableViewDelegate> scDelegate;

/**
 *  set hidden to YES：cancel the refersh data module
 *  set hidden to NO： add the refersh module
 */
@property (nonatomic, strong) SCRefreshBasicView *refreshBasicView;

/**
 *  YES: start the refresh animation, and call the refresh method to get data
 *  NO:  stop the refresh animation
 */
@property (nonatomic, assign) BOOL isTableRefreshing;

/**
 *  set hidden to YES：cancel the load more data module
 *  set hidden to NO： add the load more data module
 */
@property (nonatomic, strong) SCLoadMoreBasicView *loadMoreBasicView;

/**
 *  YES: start the load more animation, and call the load more method to get data
 *  NO:  stop the load more animation
 */
@property (nonatomic, assign) BOOL isTableLoadingMore;

/**
 *  the previous offsetY
 */
@property (nonatomic, assign) CGFloat preOffsetY;

/**
 *  you can init your custom views in this method
 */
- (void)commonInit;

@end


@protocol SCBasicTableViewDelegate <NSObject>

@optional

- (void)didBeginToRefresh:(SCBasicTableView*)tableView;

- (void)didBeginToLoadMoreData:(SCBasicTableView*)tableView;

@end
