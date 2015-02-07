//
//  SCBasicTableViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCBasicTableViewController.h"

@interface SCBasicTableViewController ()

@end

@implementation SCBasicTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentPage = 1;
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    [self commonInit];
}

- (void)commonInit {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    
    self.scBasicTableView.delegate = nil; // 需要置空，不然pop或dismiss controller后，tableView的didScrollView方法仍会执行，这时就会报错
    self.scBasicTableView = nil;
}

#pragma mark - public
/**
 *  请求网络数据
 *
 *  @param sender _scTableView
 */
- (void)sendRequest:(id)sender {
}

/**
 *  停止上拉、下拉的显示状态
 *
 *  @param sender _scTableView
 */
- (void)stopLoading:(id)sender {
    if ([sender isKindOfClass:[SCBasicTableView class]]) {
        if (((SCBasicTableView *)sender).isTableRefreshing) {
            ((SCBasicTableView *)sender).isTableRefreshing = NO;
        }
        if (((SCBasicTableView *)sender).isTableLoadingMore) {
            ((SCBasicTableView *)sender).isTableLoadingMore = NO;
        }
    }
}

/**
 *  重置列表数据
 */
- (void)reloadData {
    [_dataArray removeAllObjects];
    [self requestData];
}

#pragma mark - private
/**
 *  发送更新信息，标记needRemoveObjects设置为yes, currentPage重置为第一页
 *
 *  @param sender _scTableView
 */
- (void)refresh:(id)sender {
    _needRemoveObjects = YES;
    _currentPage = 1;
    [self sendRequest:_scBasicTableView];
}

/**
 *  请求数据，根据currentPage，已有数据来判断是否需要发送请求
 */
- (void)requestData {
    if ([_dataArray count] > 0) {
        return;
    } else {
        _currentPage = 1;
        [self sendRequest:_scBasicTableView];
    }
}

/**
 *  请求下一页的数据
 *
 *  @param sender _scTableView
 */
- (void)requestNextPage:(id)sender {
    _currentPage++;
    [self sendRequest:sender];
}

#pragma mark - SCTableView delegate
- (void)didBeginToRefresh:(SCBasicTableView *)tableView {
    [self performSelector:@selector(refresh:) withObject:_scBasicTableView afterDelay:0.05f];
}

- (void)didBeginToLoadMoreData:(SCBasicTableView *)tableView {
    [self performSelector:@selector(requestNextPage:) withObject:_scBasicTableView afterDelay:0.05f];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
