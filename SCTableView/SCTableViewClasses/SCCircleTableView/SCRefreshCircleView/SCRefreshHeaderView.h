//
//  SCRefreshHeaderView.h
//  SCTableView
//
//  Created by Aevitx on 14-7-29.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRefreshBasicView.h"
#import "SCRefreshCircleView.h"


// the y value of offset that begin to draw circle
#define HEIGHT_BEGIN_TO_DRAW_CIRCLE     20

@interface SCRefreshHeaderView : SCRefreshBasicView

@property (nonatomic, strong) SCRefreshCircleView *refreshCircleView;

@end
