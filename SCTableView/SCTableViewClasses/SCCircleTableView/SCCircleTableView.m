//
//  SCCircleTableView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCircleTableView.h"

@implementation SCCircleTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self commonInit];
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
    _isRefreshViewOnTableView = YES;
    
    static CGFloat refreshViewHeight = 50;
    SCRefreshHeaderView *aView = [[SCRefreshHeaderView alloc] initWithFrame:(_isRefreshViewOnTableView ? CGRectMake(0, -refreshViewHeight, self.frame.size.width, refreshViewHeight) : CGRectMake(0, self.frame.origin.y, self.frame.size.width, refreshViewHeight))];
    aView.delegate = self;
    if (_isRefreshViewOnTableView) {
        [self addSubview:aView];
    }
    aView.refreshCircleView.isRefreshViewOnTableView = _isRefreshViewOnTableView;
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
    if (_isRefreshViewOnTableView == NO) {
        self.backgroundColor = [UIColor clearColor];
        [newSuperview insertSubview:_refreshView belowSubview:self];
    }
}

- (void)setIsRefreshViewOnTableView:(BOOL)isRefreshViewOnTableView {
    if (_isRefreshViewOnTableView != isRefreshViewOnTableView) {
        
        _isRefreshViewOnTableView = isRefreshViewOnTableView;
        if ([_refreshView isKindOfClass:[SCRefreshHeaderView class]]) {
            ((SCRefreshHeaderView*)_refreshView).refreshCircleView.isRefreshViewOnTableView = isRefreshViewOnTableView;
        }
        
        [_refreshView removeFromSuperview];
        
        _refreshView.frame = (_isRefreshViewOnTableView ?
                              CGRectMake(0, -_refreshView.frame.size.height, self.frame.size.width, _refreshView.frame.size.height) :
                              CGRectMake(0, self.frame.origin.y, self.frame.size.width, _refreshView.frame.size.height)
                              );
        
        if (_isRefreshViewOnTableView) {
            [self addSubview:_refreshView];
        } else {
            self.backgroundColor = [UIColor clearColor];
            [self.superview insertSubview:_refreshView belowSubview:self];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_refreshView) {
        CGRect refreshFrame = _refreshView.frame;
        refreshFrame.origin.y = (_isRefreshViewOnTableView ? -refreshFrame.size.height : frame.origin.y);
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
