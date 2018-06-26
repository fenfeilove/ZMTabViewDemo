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
@class ZMTabBar;
@interface ZMTabItem : NSObject<NSCopying>
@property(copy) NSString* identifier;
@property(copy) NSString* title;
@property(strong)id representedObject;
@property(readonly) ZMTabBar* tabBar;
- (id)initWithIdentifier:(NSString*)identifier;
@end

@protocol ZMTabBarDelegate;
IB_DESIGNABLE
@interface ZMTabBar : NSView
@property(nonatomic,assign)IBInspectable BOOL showAddItem;
@property(readonly)NSUInteger numberOfTabItems;
@property(readonly,strong)NSButton* addItem;
@property(weak)IBOutlet id<ZMTabBarDelegate> delegate;
@property(weak)IBOutlet id<ZMTabBarStyle> tabBarStyle;
@property(copy)IBInspectable NSString* tabBarStyleName;

- (void)addTabItem:(ZMTabItem*)item;
- (void)insertTabItem:(ZMTabItem*)item atIndex:(NSUInteger)index;
- (void)removeTabItem:(ZMTabItem*)item;
- (void)removeAllTabItem;

- (ZMTabItem*)tabItemAtIndex:(NSInteger)index;
- (NSInteger)indexOfTabItemWithIdentifier:(id)identifier;

- (void)selectTabItem:(nullable ZMTabItem*)item;
- (void)selectTabItemAtIndex:(NSInteger)index;
- (void)selectTabItemWithIdentifier:(id)identifier;

- (IBAction)selectFirstTabViewItem:(nullable id)sender;
- (IBAction)selectLastTabViewItem:(nullable id)sender;
- (IBAction)selectNextTabViewItem:(nullable id)sender;
- (IBAction)selectPreviousTabViewItem:(nullable id)sender;
@property(nullable, readonly, strong) ZMTabItem *selectedTabItem;
@property(readonly, copy) NSArray<__kindof ZMTabItem *> *tabItems;
@end

@protocol ZMTabBarDelegate <NSObject>
@optional
- (BOOL)tabBar:(ZMTabBar *)tabView shouldSelectTabItem:(nullable ZMTabItem *)tabViewItem;
- (void)tabBar:(ZMTabBar *)tabView willSelectTabItem:(nullable ZMTabItem *)tabViewItem;
- (void)tabBar:(ZMTabBar *)tabView didSelectTabItem:(nullable ZMTabItem *)tabViewItem;
- (void)tabBarDidChangeNumberOfTabViewItems:(ZMTabBar *)tabView;
@end
NS_ASSUME_NONNULL_END
