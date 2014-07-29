//
//  DemoViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-7-29.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "DemoViewController.h"
#import "SCTableView.h"

@interface DemoViewController () <UITableViewDelegate, UITableViewDataSource, SCTableViewDelegate>

#warning debug ViewController
@property (nonatomic, assign) int rowNum;

@property (nonatomic, strong) SCTableView *scTableView;

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"DemoViewController";
    
    _rowNum = 0;
    
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat tableViewY = (sysVersion < 7.0 ? 0 : (20 + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height)));
    
    SCTableView *aTable = [[SCTableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - (sysVersion < 7.0 ? (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height) : tableViewY)) style:UITableViewStylePlain];
    aTable.isRefreshViewOnTableView = _shouldMoveRefreshViewWithTableView;
    aTable.delegate = self;
    aTable.dataSource = self;
    aTable.scDelegate = self;
    aTable.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
    
    if (_shouldMoveRefreshViewWithTableView) {
        // 修改loadMoreBtn的文字
        [aTable.loadMoreView.loadMoreBtn setTitle:@"显示下10条" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:aTable];
    self.scTableView = aTable;
    
    if (_rowNum <= 0) {
        aTable.isTableRefreshing = YES;
        [self didBeginToRefresh:aTable];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.scTableView.delegate = nil;// 需要置空，不然pop或dismiss controller后，tableView的didScrollView方法仍会执行，这时就会报错
    self.scTableView = nil;
}

#pragma mark - SCTableView delegate
- (void)didBeginToRefresh:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum = 20;
        [tableView reloadData];
        tableView.isTableRefreshing = NO;
        
        tableView.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
        
        tableView.loadMoreView.loadMoreBtn.hidden = (_rowNum >= 30 ? NO : YES);
    });
}

- (void)didBeginToLoadMoreData:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum += 10;
        [tableView reloadData];
        tableView.isTableLoadingMore = NO;
        
        if (_shouldMoveRefreshViewWithTableView) {
            tableView.loadMoreView.loadMoreBtn.hidden = (_rowNum >= 30 ? NO : YES);
        }
    });
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowNum;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row: %d", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
