//
//  ViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "ViewController.h"
#import "SCTableView.h"
#import "SCDemoTableViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SCTableViewDelegate>

@property (nonatomic, strong) SCTableView *scTableView;


#warning debug ViewController
@property (nonatomic, assign) int rowNum;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _rowNum = 0;
    
    SCTableView *aTable = [[SCTableView alloc] initWithFrame:CGRectMake(0, ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20 : 0)) style:UITableViewStylePlain];
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

#pragma mark - SCTableView delegate
- (void)didBeginToRefresh:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum = 20;
        [tableView reloadData];
        tableView.isTableRefreshing = NO;
        
        tableView.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
        tableView.loadMoreView.loadMoreBtn.hidden = (_rowNum >= 50 ? NO : YES);
    });
}

- (void)didBeginToLoadMoreData:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum += 10;
        [tableView reloadData];
        tableView.isTableLoadingMore = NO;
        
        tableView.loadMoreView.loadMoreBtn.hidden = (_rowNum >= 50 ? NO : YES);
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
    
    //进入继承自SCTableViewController的一个实例
    SCDemoTableViewController *con = [[SCDemoTableViewController alloc] initWithNibName:@"SCDemoTableViewController" bundle:nil];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:con animated:YES completion:^{
        ;
    }];
}


@end
