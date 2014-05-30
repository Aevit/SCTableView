//
//  SCRereshHeaderView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRefreshCircleView.h"

typedef enum {
    SCRefreshStatePulling    =   0,
    SCRefreshStateNormal     =   1,
    SCRefreshStateLoading    =   2
} SCRefreshState;

//开始画圆圈时的offset
#define HEIGHT_BEGIN_TO_DRAW_CIRCLE     20

//圆圈开始旋转时的offset （即开始刷新数据时）
#define HEIGHT_BEGIN_TO_REFRESH         (50 + HEIGHT_BEGIN_TO_DRAW_CIRCLE)


@protocol SCRereshHeaderViewDelegate;

@interface SCRereshHeaderView : UIView

@property (nonatomic, strong) SCRefreshCircleView *refreshCircleView;

@property (nonatomic, assign) SCRefreshState state;

@property (nonatomic, assign) id <SCRereshHeaderViewDelegate> delegate;

- (void)refreshViewDidScroll:(UIScrollView*)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)refreshViewDidFinishedLoading:(UIScrollView*)scrollView;
- (void)refreshViewDidEndDecelerating:(UIScrollView*)scrollView;

- (void)startRefreshAnimation:(UIScrollView*)scrollView;

@end



@protocol SCRereshHeaderViewDelegate <NSObject>

@optional
- (void)refreshViewDidBeginToRefresh:(SCRereshHeaderView *)refreshView;

@end