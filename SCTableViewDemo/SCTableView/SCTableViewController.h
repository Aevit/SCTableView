//
//  SCTableViewController.h
//  SCTableView
//
//  Created by Aevitx on 14-5-30.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableView.h"

@interface SCTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SCTableViewDelegate>


@property (nonatomic, strong) IBOutlet SCTableView *scTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger currentPage;
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

@end
