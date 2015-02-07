//
//  SCDemoTableViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-5-30.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCDemoTableViewController.h"

@interface SCDemoTableViewController ()

@end

@implementation SCDemoTableViewController

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
    
    self.title = @"SCDemoTableViewController";
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    CGFloat tableViewY = (sysVersion < 7.0 ? 0 : (20 + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height)));
    self.scTableView.frame = CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - (sysVersion < 7.0 ? (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height) : tableViewY));
    
    
    self.scTableView.delegate = self;
    self.scTableView.dataSource = self;
    
    if (_shouldMoveRefreshViewWithTableView) {
        // 修改loadMoreBtn的文字
        [self.scTableView.loadMoreView.loadMoreBtn setTitle:@"显示下20条" forState:UIControlStateNormal];
    }
    self.scTableView.isRefreshViewOnTableView = _shouldMoveRefreshViewWithTableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSCTableView {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - super method(s)
- (void)sendRequest:(id)sender {
    if (self.dataArray.count <= 0) {
        self.scTableView.isTableRefreshing = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self stopLoading:sender];
        
        // SCCircleTableViewController里，如果是下拉刷新的，会自动设置needRemoveObjects为YES
        if (self.needRemoveObjects) {
            [self.dataArray removeAllObjects];
            self.needRemoveObjects = NO;
        }
        
        for (int i = 0; i < 20; i++) {
            [self.dataArray addObject:@"demo row"];
        }
        [self.scTableView reloadData];
        
        self.scTableView.loadMoreView.hidden = (self.dataArray.count > 0 ? NO : YES);
        if (_shouldMoveRefreshViewWithTableView) {
            self.scTableView.loadMoreView.loadMoreBtn.hidden = (self.dataArray.count >= 30 ? NO : YES);
        }
    });
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = self.view.backgroundColor;
        cell.contentView.backgroundColor = self.view.backgroundColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %d", self.dataArray[indexPath.row], indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
