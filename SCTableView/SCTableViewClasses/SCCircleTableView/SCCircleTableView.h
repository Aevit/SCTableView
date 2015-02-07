//
//  SCCircleTableView.h
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCBasicTableView.h"
#import "SCRefreshHeaderView.h"
#import "SCLoadMoreFooterView.h"

@interface SCCircleTableView : SCBasicTableView


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
 *  set hidden to YES：cancel the load more data module
 *  set hidden to NO： add the load more data module
 */
@property (nonatomic, strong) SCLoadMoreFooterView *loadMoreView;

@end
