//
//  SCFootballTableView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCFootballTableView.h"

@implementation SCFootballTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
    self.scDelegate = nil;
    self.refreshView = nil;
    self.loadMoreView = nil;
    self.refreshBasicView = nil;
    self.loadMoreBasicView = nil;
}

- (void)commonInit {
    
    self.preOffsetY = 0;
    
    //refreshView
    static const CGFloat refreshViewHeight = 110;
    SCFootballRefreshView *aView = [[SCFootballRefreshView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, refreshViewHeight)];
    aView.delegate = self;
    self.refreshView = aView;
    self.refreshBasicView = aView;
    
    
    //loadMoreView
    static CGFloat loadMoreViewHeight = 50;
    self.contentInset = UIEdgeInsetsMake(0, 0, loadMoreViewHeight, 0);
    SCLoadMoreFooterView *bView = [[SCLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - loadMoreViewHeight, self.frame.size.width, loadMoreViewHeight)];
    bView.delegate = self;
    [self addSubview:bView];
    self.loadMoreView = bView;
    self.loadMoreBasicView = bView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = [UIColor clearColor];
    [newSuperview insertSubview:_refreshView belowSubview:self];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_refreshView) {
        CGRect refreshFrame = _refreshView.frame;
        refreshFrame.origin.y = frame.origin.y;
        _refreshView.frame = refreshFrame;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
