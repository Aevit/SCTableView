//
//  SCRefreshCircleView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-30.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRefreshCircleView : UIView

// the y value of offset which the circle begin to rotate (start to get data)
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

/**
 *  the y value of offset
 */
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  YES: refreshView is the subview of tableView (refreshView will move with tableview)
 *  NO: refreshView is the subview of tableView.superView (refreshView will NOT move with tableview)
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  the repeate ratate animation
 *
 *  @return animation
 */
+ (CABasicAnimation*)repeatRotateAnimation;

@end
