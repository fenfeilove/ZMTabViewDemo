//
//  ZMDefaultTabBarStyle.h
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ZMTabBar;
@class ZMTabItem;
@protocol ZMTabBarStyle<NSObject>
- (void)cleanUp;
@optional
- (void)drawTabBar:(ZMTabBar*)tabBar inRect:(NSRect)dirtyRect;
- (void)tabBar:(ZMTabBar*)tabBar didAddItem:(ZMTabItem*)item inRect:(NSRect)rect;
- (void)tabBar:(ZMTabBar*)tabBar itemFrameChange:(ZMTabItem*)item inRect:(NSRect)rect;
- (void)tabBar:(ZMTabBar*)tabBar willRemoveItem:(ZMTabItem *)item;
@end

@protocol ZMTabBarDelegate;
@protocol ZMCloseTabBarDelegate <ZMTabBarDelegate>
- (void)tabBar:(ZMTabBar *)tabView closeTabItem:(ZMTabItem *)tabViewItem;
@end

@interface ZMDefaultTabBarStyle : NSObject<ZMTabBarStyle>

@end
