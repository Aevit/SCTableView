//
//  SCLoadMoreBasicView.m
//  SCTableView
//
//  Created by Aevitx on 14-8-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCLoadMoreBasicView.h"

@implementation SCLoadMoreBasicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Util
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView {
    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
    
    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight;
    
    CGFloat normalizedOffset = scrollAreaContenHeight - scrolledDistance;
    
    return normalizedOffset;
}

#pragma mark - set state
- (void)setState:(SCLoadMoreState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    // to subclass
    [self setTheState:state];
}

#pragma mark - override these methods in subclass
- (void)loadMoreViewDidScroll:(UIScrollView*)scrollView {
    
}

- (void)loadMoreViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)loadMoreViewDidEndDecelerating:(UIScrollView*)scrollView {
    
}

- (void)loadMoreViewDidFinishedLoading:(UIScrollView*)scrollView {
    
}

- (void)setTheState:(SCLoadMoreState)state {
    
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
