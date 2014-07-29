//
//  SCRefreshHeaderView.h
//  SCTableView
//
//  Created by Aevitx on 14-7-29.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCRefreshCircleView.h"

typedef enum {
    SCRefreshStatePulling    =   0,
    SCRefreshStateNormal     =   1,
    SCRefreshStateLoading    =   2
} SCRefreshState;

// the y value of offset that begin to draw circle
#define HEIGHT_BEGIN_TO_DRAW_CIRCLE     20

// the y value of offset which the circle begin to rotate (start to get data)
#define HEIGHT_BEGIN_TO_REFRESH         (50 + HEIGHT_BEGIN_TO_DRAW_CIRCLE)


@protocol SCRefreshHeaderViewDelegate;

@interface SCRefreshHeaderView : UIView


@property (nonatomic, strong) SCRefreshCircleView *refreshCircleView;

@property (nonatomic, assign) SCRefreshState state;

@property (nonatomic, assign) id <SCRefreshHeaderViewDelegate> delegate;

- (void)refreshViewDidScroll:(UIScrollView*)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)refreshViewDidFinishedLoading:(UIScrollView*)scrollView;
- (void)refreshViewDidEndDecelerating:(UIScrollView*)scrollView;

- (void)startRefreshAnimation:(UIScrollView*)scrollView;

@end



@protocol SCRefreshHeaderViewDelegate <NSObject>

@optional
- (void)refreshViewDidBeginToRefresh:(SCRefreshHeaderView *)refreshView;

@end
