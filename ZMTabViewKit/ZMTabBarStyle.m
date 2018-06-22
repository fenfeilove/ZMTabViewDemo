//
//  ZMDefaultTabBarStyle.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabBarStyle.h"
#import "ZMTabBar.h"

@implementation ZMDefaultTabBarStyle
- (void)drawTabBarControl:(ZMTabBar *)tabBar inRect:(NSRect)dirtyRect{
    NSBezierPath *thePath = [NSBezierPath bezierPathWithRoundedRect:[tabBar bounds]
                                                            xRadius:4 yRadius:4];
    [[NSColor colorWithSRGBRed:0xF7/255.0 green:0xF7/255.0 blue:0xFA/255.0 alpha:1] set];
    [thePath fill];
}
@end
