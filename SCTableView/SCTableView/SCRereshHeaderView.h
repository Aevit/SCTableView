//
//  SCRereshHeaderView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCRereshHeaderViewDelegate;

@interface SCRereshHeaderView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *refreshIndicatorView;

@property (nonatomic, assign) id <SCRereshHeaderViewDelegate> delegate;

- (void)refreshViewDidScroll:(UIScrollView*)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)refreshViewDidFinishedLoading:(UIScrollView*)scrollView;

@end



@protocol SCRereshHeaderViewDelegate <NSObject>

@optional
- (void)refreshViewDidBeginToRefresh:(SCRereshHeaderView *)refreshView;

@end