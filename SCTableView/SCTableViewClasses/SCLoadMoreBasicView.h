//
//  SCLoadMoreBasicView.h
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCLoadMoreStateNormal       =   0,
    SCLoadMoretateLoading       =   1
} SCLoadMoreState;

@protocol SCLoadMoreBasicViewDelegate;

@interface SCLoadMoreBasicView : UIView

/**
 *  the offsetY from bottom begin to load more data
 */
@property (nonatomic, assign) CGFloat bottomOffsetToBeginLoadMoreData;

/**
 *  set the refresh state
 */
@property (nonatomic, assign) SCLoadMoreState state;

/**
 *  callback
 */
@property (nonatomic, assign) id <SCLoadMoreBasicViewDelegate> delegate;


/**
 *  get the offsetY from bottom
 *
 *  @param scrollView tableview or scrollview
 *
 *  @return the offsetY
 */
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView;

/**
 *  set the SCRefreshState here in the subclass of SCRefreshBasicView
 *
 *  @param state SCRefreshState
 */
- (void)setTheState:(SCLoadMoreState)state;

/**
 *  do what you want here when is scrolling in the subclass of SCLoadMoreBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)loadMoreViewDidScroll:(UIScrollView*)scrollView;

/**
 *  do what you want here when did end dragging in the subclass of SCLoadMoreBasicView
 *
 *  @param scrollView tableview or scrollview
 *  @param decelerate willDecelerate or not
 */
- (void)loadMoreViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 *  do what you want here when did decelerating int the subclass of SCLoadMoreBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)loadMoreViewDidEndDecelerating:(UIScrollView*)scrollView;

/**
 *  do what you want here when did finish loading in the subclass of SCLoadMoreBasicView
 *
 *  @param scrollView tableview or scrollview
 */
- (void)loadMoreViewDidFinishedLoading:(UIScrollView*)scrollView;

@end



@protocol SCLoadMoreBasicViewDelegate <NSObject>

@optional
- (void)loadMoreViewDidBeginToLoadMore:(SCLoadMoreBasicView *)loadMoreView;

@end