//
//  SCLoadMoreFooterView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCLoadMoreFooterViewDelegate;

@interface SCLoadMoreFooterView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;

@property (nonatomic, assign) id <SCLoadMoreFooterViewDelegate> delegate;


@property (nonatomic, assign) CGFloat bottomOffsetToBeginLoadMoreData;
@property (nonatomic, strong) UIButton *loadMoreBtn;



- (void)loadMoreViewDidScroll:(UIScrollView*)scrollView;
- (void)loadMoreViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)loadMoreViewDidFinishedLoading:(UIScrollView*)scrollView;
- (void)loadMoreViewDidEndDecelerating:(UIScrollView*)scrollView;

@end



@protocol SCLoadMoreFooterViewDelegate <NSObject>

@optional
- (void)loadMoreViewDidBeginToLoadMore:(SCLoadMoreFooterView *)loadMoreView;

@end
