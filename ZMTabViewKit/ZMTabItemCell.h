//
//  ZMTabItemCell.h
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ZMTabBar;
@class ZMTabItem;
@interface ZMTabItemCell : NSView
@property(weak)ZMTabBar* tabBar;
@property(strong) ZMTabItem* tabItem;
@end
