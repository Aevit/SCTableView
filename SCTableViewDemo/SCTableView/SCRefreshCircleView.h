//
//  SCRefreshCircleView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-30.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRefreshCircleView : UIView

// 圆圈开始旋转时的offset （即开始刷新数据时）
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

// offset的Y值
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  isRefreshViewOnTableView
 *  YES: refreshView是tableView的子view
 *  NO: refreshView是tableView.superView的子view
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  旋转的animation
 *
 *  @return animation
 */
+ (CABasicAnimation*)repeatRotateAnimation;

@end
