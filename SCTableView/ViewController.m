//
//  ViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "ViewController.h"
#import "SCTableView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SCTableViewDelegate>

@property (nonatomic, strong) SCTableView *scTableView;


#warning 测试 number
@property (nonatomic, assign) int rowNum;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _rowNum = 0;
    
    SCTableView *aTable = [[SCTableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    aTable.delegate = self;
    aTable.dataSource = self;
    aTable.scDelegate = self;
    aTable.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
    [self.view addSubview:aTable];
    self.scTableView = aTable;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - SCTableView delegate
- (void)didBeginToRefresh:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum = 20;
        [tableView reloadData];
        tableView.isTableRefreshing = NO;
        
        tableView.loadMoreView.hidden = (_rowNum > 0 ? NO : YES);
    });
}

- (void)didBeginToLoadMoreData:(SCTableView *)tableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rowNum += 10;
        [tableView reloadData];
        tableView.isTableLoadingMore = NO;
        
        if (_rowNum >= 50) {
            tableView.loadMoreView.loadMoreBtn.hidden = NO;
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


@end
