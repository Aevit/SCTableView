//
//  SCRefreshBasicView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCRefreshBasicView.h"

@implementation SCRefreshBasicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - set state
- (void)setState:(SCRefreshState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    // to subclass
    [self setTheState:state];
}

#pragma mark - override these methods in subclass
- (void)refreshViewDidScroll:(UIScrollView*)scrollView {
    // to subclass
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // to subclass
}

- (void)refreshViewDidEndDecelerating:(UIScrollView*)scrollView {
    // to subclass
}

- (void)startRefreshAnimation:(UIScrollView*)scrollView {
    // to subclass
}

- (void)refreshViewDidFinishedLoading:(UIScrollView*)scrollView {
    // to subclass
}

- (void)setTheState:(SCRefreshState)state {
    // to subclass
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
