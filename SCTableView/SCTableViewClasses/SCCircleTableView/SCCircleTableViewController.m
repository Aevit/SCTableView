//
//  SCCircleTableViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCircleTableViewController.h"

@interface SCCircleTableViewController ()

@end

@implementation SCCircleTableViewController

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
    // Do any additional setup after loading the view.
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
    
    self.scTableView.delegate = nil; // 需要置空，不然pop或dismiss controller后，tableView的didScrollView方法仍会执行，这时就会报错
    self.scTableView.delegate = nil;
}

- (void)commonInit {
    // 如果没用xib添加tableView，才需要在这里用代码添加talbeView
    if (!_scTableView) {
        SCCircleTableView *aTable = [[SCCircleTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.view addSubview:aTable];
        self.scTableView = aTable;
        self.scBasicTableView = aTable;
    }
    _scTableView.delegate = self;
    _scTableView.dataSource = self;
    _scTableView.scDelegate = self;
    [self refresh:_scTableView];
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
