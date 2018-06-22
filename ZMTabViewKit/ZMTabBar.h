//
//  ZMTabBar.h
//  ZMTabViewKit
//
//  Created by francis zhuo on 2018/6/21.
//  Copyright © 2018 zoom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZMTabBarStyle.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZMTabItem : NSObject
@property(copy) NSString* identifier;
@property(copy) NSString* title;
@property(strong)id representedObject;
- (id)initWithIdentifier:(NSString*)identifier;
@end


IB_DESIGNABLE
@interface ZMTabBar : NSView
@property(assign)IBInspectable BOOL showAddItem;
@property(readonly)NSUInteger itemCount;
@property(readonly,strong)NSButton* addItem;

@property(weak)IBOutlet id<ZMTabBarStyle> tabBarStyle;
@property(copy)IBInspectable NSString* tabBarStyleName;

- (void)addTabItem:(ZMTabItem*)item;
- (void)insertTabItem:(ZMTabItem*)item atIndex:(NSUInteger)index;
- (void)removeTabItem:(ZMTabItem*)item;

- (ZMTabItem*)tabItemAtIndex:(NSInteger)index;
- (NSInteger)indexOfTabItemWithIdentifier:(id)identifier;

- (void)selectTabItem:(nullable ZMTabItem*)item;
- (void)selectTabItemAtIndex:(NSInteger)index;
- (void)selectTabItemWithIdentifier:(id)identifier;
@end
NS_ASSUME_NONNULL_END
