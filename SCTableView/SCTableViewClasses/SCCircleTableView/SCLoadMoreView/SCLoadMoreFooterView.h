//
//  SCLoadMoreFooterView.h
//  SCTableView
//
//  Created by Aevitx on 14-5-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLoadMoreBasicView.h"

@interface SCLoadMoreFooterView : SCLoadMoreBasicView

@property (nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;

/**
 *  the load more data button. will call the load more data method after click this button
 *  set hidden to YES: will NOT show the load more data button
 *  set hidden to NO:  will show the load more data button
 */
@property (nonatomic, strong) UIButton *loadMoreBtn;

@end