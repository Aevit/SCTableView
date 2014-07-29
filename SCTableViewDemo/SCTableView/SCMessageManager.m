//
//  SCMessageManager.m
//  SCTableView
//
//  Created by Aevitx on 14-5-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCMessageManager.h"

@implementation SCMessageManager

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([_middleBridge respondsToSelector:aSelector]) {
        return _middleBridge;
    }
    if ([_receiver respondsToSelector:aSelector]) {
        return _receiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([_middleBridge respondsToSelector:aSelector]) {
        return YES;
    }
    if ([_receiver respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end
