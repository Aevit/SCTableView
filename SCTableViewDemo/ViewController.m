//
//  ViewController.m
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "ViewController.h"
#import "SCDemoTableViewController.h"
#import "DemoViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    CGFloat tableViewY = (sysVersion < 7.0 ? 0 : (20 + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height)));
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - (sysVersion < 7.0 ? (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height) : tableViewY)) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.textLabel.text =
    (indexPath.row == 0 ? @"move refresh view (Controller)" :
     (indexPath.row == 1 ? @"static refresh view (Controller)" :
      (indexPath.row == 2 ? @"move refresh view (View)" :
       (indexPath.row == 3 ? @"static refresh view (View)" : @"see the ghost"))));
    
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text =
    (indexPath.row == 0 ? @"Inherit from SCTableViewController. \nAnd the refresh view will move with tableview" :
     (indexPath.row == 1 ? @"Inherit from SCTableViewController. \nAnd the refresh view will NOT move with tableview" :
      (indexPath.row == 2 ? @"Only add a SCTableView to a controller. \nAnd the refresh view will move with tableview" :
       (indexPath.row == 3 ? @"Only add a SCTableView to a controller. \nAnd the refresh view NOT move with tableview" : @"see the ghost"))));
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            SCDemoTableViewController *con = [[SCDemoTableViewController alloc] initWithNibName:@"SCDemoTableViewController" bundle:nil];
            con.shouldMoveRefreshViewWithTableView = YES;
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
        case 1:
        {
            SCDemoTableViewController *con = [[SCDemoTableViewController alloc] initWithNibName:@"SCDemoTableViewController" bundle:nil];
            con.shouldMoveRefreshViewWithTableView = NO;
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
        case 2:
        {
            DemoViewController *con = [[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
            con.shouldMoveRefreshViewWithTableView = YES;
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
        case 3:
        {
            DemoViewController *con = [[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
            con.shouldMoveRefreshViewWithTableView = NO;
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
