//
//  SCDemoTableViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-5-30.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCDemoTableViewController.h"

@interface SCDemoTableViewController () {
    BOOL hasShowController;
}

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
//    [self initSCTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSCTableView {
    
    self.scTableView.delegate = self;
    self.scTableView.dataSource = self;
    self.scTableView.scDelegate = self;
    
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    CGFloat tableViewY = (sysVersion < 7.0 ? 0 : (20 + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height)));
    self.scTableView.frame = CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - (sysVersion < 7.0 ? (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height) : tableViewY));
    
    self.scTableView.isRefreshViewOnTableView = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!hasShowController) {
        hasShowController = YES;
        [self initSCTableView];
    }
}

#pragma mark - super method(s)
- (void)sendRequest:(id)sender {
    if (self.dataArray.count <= 0) {
        self.scTableView.isTableRefreshing = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self stopLoading:sender];
        
        if (self.needRemoveObjects) {
            [self.dataArray removeAllObjects];
            self.needRemoveObjects = NO;
        }
        
        for (int i = 0; i < 4; i++) {
            [self.dataArray addObject:@"demo row"];
        }
        [self.scTableView reloadData];
        
        self.scTableView.loadMoreView.hidden = (self.dataArray.count > 0 ? NO : YES);
        self.scTableView.loadMoreView.loadMoreBtn.hidden = (self.dataArray.count >= 50 ? NO : YES);
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
#warning debug iOS6才需要这样
        cell.backgroundColor = self.view.backgroundColor;
        cell.contentView.backgroundColor = self.view.backgroundColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %d", self.dataArray[indexPath.row], indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [(self.navigationController ? self.navigationController : self) dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
