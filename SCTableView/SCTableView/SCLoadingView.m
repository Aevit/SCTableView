//
//  SCLoadingView.m
//  SCTableView
//
//  Created by Aevitx on 14-5-28.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCLoadingView.h"

@implementation SCLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self  commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self  commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    
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
