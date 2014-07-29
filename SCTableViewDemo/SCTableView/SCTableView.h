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

@property (nonatomic, assign) IBOutlet id <SCTableViewDelegate> scDelegate;

/**
 *  isRefreshViewOnTableView
 *  YES: refreshView是tableView的子view
 *  NO: refreshView是tableView.superView的子view
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  其hidden设为YES：不显示refreshView
 *  其hidden设为NO： 显示refreshView
 */
@property (nonatomic, strong) SCRereshHeaderView *refreshView;

/**
 *  YES: 开始刷新动画，调用刷新接口
 *  NO:  隐藏刷新动画
 */
@property (nonatomic, assign) BOOL isTableRefreshing;

/**
 *  其hidden设为YES：不显示loadMoreView
 *  其hidden设为NO： 显示loadMoreView
 */
@property (nonatomic, strong) SCLoadMoreFooterView *loadMoreView;

/**
 *  YES: 开始加载更多动画，调用加载更多接口
 *  NO:  隐藏加载更多动画
 */
@property (nonatomic, assign) BOOL isTableLoadingMore;

@end


@protocol SCTableViewDelegate <NSObject>

@optional

- (void)didBeginToRefresh:(SCTableView*)tableView;

- (void)didBeginToLoadMoreData:(SCTableView*)tableView;

@end
