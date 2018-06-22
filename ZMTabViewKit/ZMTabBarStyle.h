//
//  ZMDefaultTabBarStyle.h
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ZMTabBar;
@protocol ZMTabBarStyle<NSObject>
@optional
- (void)drawTabBarControl:(ZMTabBar*)tabBar inRect:(NSRect)dirtyRect;

@end

@interface ZMDefaultTabBarStyle : NSObject<ZMTabBarStyle>

@end
