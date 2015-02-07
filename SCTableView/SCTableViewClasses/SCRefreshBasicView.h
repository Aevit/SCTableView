//
//  SCRefreshBasicView.h
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCRefreshStatePulling    =   0,
    SCRefreshStateNormal     =   1,
    SCRefreshStateLoading    =   2
} SCRefreshState;

@protocol SCRefreshBasicViewDelegate;

@interface SCRefreshBasicView : UIView


/**
 *  the y value of offset which the circle begin to rotate (start to get data)
 */
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

/**
 *  set the refresh state
 */
@property (nonatomic, assign) SCRefreshState state;

/**
 *  callback
 */
@property (nonatomic, assign) id <SCRefreshBasicViewDelegate> delegate;

/**
 *  set the SCRefreshState here in the subclass of SCRefreshBasicView
 *
 *  @param state SCRefreshState
 */
- (void)setTheState:(SCRefreshState)state;

/**
 *  do what you want when is scrolling here in the subclass of SCRefreshBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)refreshViewDidScroll:(UIScrollView*)scrollView;

/**
 *  do what you want when did end dragging here in the subclass of SCRefreshBasicView
 *
 *  @param scrollView tableview or scrollview
 *  @param decelerate willDecelerate or not
 */
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 *  do what you want when did end decelerating here in the subclass of SCRefreshBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)refreshViewDidEndDecelerating:(UIScrollView*)scrollView;

/**
 *  do what you want when did finish loading here in the subclass of SCRefreshBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)refreshViewDidFinishedLoading:(UIScrollView*)scrollView;

/**
 *  start the refresh animation you want here in the subclass of SCRefreshBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)startRefreshAnimation:(UIScrollView*)scrollView;


@end


@protocol SCRefreshBasicViewDelegate <NSObject>

@optional
- (void)refreshViewDidBeginToRefresh:(SCRefreshBasicView *)refreshView;

@end