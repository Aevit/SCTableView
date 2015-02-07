//
//  FootballDemoViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-8-31.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "FootballDemoViewController.h"
#import "SCFootballTableView.h"

@interface FootballDemoViewController () <UITableViewDelegate, UITableViewDataSource, SCBasicTableViewDelegate>

#warning debug
@property (nonatomic, assign) int rowNum;
@property (nonatomic, strong) SCFootballTableView *scTableView;

@end

@implementation FootballDemoViewController

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
    
    self.title = @"FootballDemoViewController";
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    _rowNum = 0;
    
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat tableViewY = (sysVersion < 7.0 ? 0 : (20 + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height)));
    
    SCFootballTableView *aTable = [[SCFootballTableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - (sysVersion < 7.0 ? (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height) : tableViewY)) style:UITableViewStylePlain];
    aTable.delegate = self;
    aTable.dataSource = self;
    aTable.scDelegate = self;
    aTable.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
    
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
- (void)didBeginToRefresh:(SCFootballTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum = 20;
        [tableView reloadData];
        tableView.isTableRefreshing = NO;
        
        tableView.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
        
        tableView.loadMoreView.loadMoreBtn.hidden = (_rowNum >= 30 ? NO : YES);
    });
}

- (void)didBeginToLoadMoreData:(SCFootballTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum += 10;
        [tableView reloadData];
        tableView.isTableLoadingMore = NO;
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
