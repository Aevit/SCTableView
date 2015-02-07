//
//  SCBasicTableViewController.h
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBasicTableView.h"

@interface SCBasicTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SCBasicTableViewDelegate>


@property (nonatomic, strong) IBOutlet SCBasicTableView *scBasicTableView;

/**
 *  存储数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  当前加载的页数
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 *  清除全部数据
 */
@property (nonatomic, assign) BOOL needRemoveObjects;

/**
 *  请求网络数据
 *
 *  @param sender _scTableView
 */
- (void)sendRequest:(id)sender;

/**
 *  停止上拉、下拉的显示状态
 *
 *  @param sender _scTableView
 */
- (void)stopLoading:(id)sender;

/**
 *  重置列表数据
 */
- (void)reloadData;

/**
 *  private method 发送更新信息，标记needRemoveObjects设置为yes, currentPage重置为第一页
 *
 *  @param sender _scTableView
 */
- (void)refresh:(id)sender;


@end
