//
//  ZMDefaultTabBarStyle.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabBarStyle.h"
#import "ZMTabBar.h"

@interface ZMDefaultTabBarStyle()
{
    NSMutableDictionary* _dic;
}
@end

@implementation ZMDefaultTabBarStyle
- (id)init{
    self = [super init];
    if(self){
        _dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)cleanUp{
    _dic = nil;
}
- (void)drawTabBar:(ZMTabBar *)tabBar inRect:(NSRect)dirtyRect{
    NSBezierPath *thePath = [NSBezierPath bezierPathWithRoundedRect:[tabBar bounds]
                                                            xRadius:4 yRadius:4];
    [[NSColor colorWithSRGBRed:0xF7/255.0 green:0xF7/255.0 blue:0xFA/255.0 alpha:1] set];
    [thePath fill];
}
- (void)tabBar:(ZMTabBar*)tabBar didAddItem:(ZMTabItem*)item inRect:(NSRect)rect{
    if(!item) return;
    NSButton* closeButton = [_dic objectForKey:item];
    if(!closeButton){
        closeButton = [[NSButton alloc] initWithFrame:[self rectForCloseButton:rect]];
        [closeButton setTarget:self];
        [closeButton setAction:@selector(onCloseButtonClick:)];
        [_dic setObject:closeButton forKey:item];
    }
    [tabBar addSubview:closeButton positioned:NSWindowAbove relativeTo:nil];
}
- (void)tabBar:(ZMTabBar*)tabBar itemFrameChange:(ZMTabItem*)item inRect:(NSRect)rect{
    if(!item) return;
    NSButton* closeButton = [_dic objectForKey:item];
    if(closeButton){
        [closeButton setFrame:[self rectForCloseButton:rect]];
    }
}
- (void)tabBar:(ZMTabBar*)tabBar willRemoveItem:(ZMTabItem *)item{
    if(!item) return;
    NSButton* closeButton = [_dic objectForKey:item];
    if(closeButton){
        [closeButton setTarget:nil];
        [closeButton setAction:nil];
        [closeButton removeFromSuperview];
        [_dic removeObjectForKey:item];
        closeButton = nil;
    }
}
- (NSRect)rectForCloseButton:(NSRect)inRect{
    NSRect outRect = NSZeroRect;
    outRect.size = NSMakeSize(16, 16);
    outRect.origin.x = ceil(NSMaxX(inRect) - NSWidth(outRect) - 10);
    outRect.origin.y = ceil(NSMidY(inRect) - NSHeight(outRect)/2);
    return outRect;
}
- (void)onCloseButtonClick:(id)sender{
    ZMTabItem* theItem = nil;
    for(ZMTabItem* item in _dic){
        if([_dic objectForKey:item] == sender){
            break;
        }
    }
    if(theItem){
        id<ZMCloseTabBarDelegate> delegate = (id<ZMCloseTabBarDelegate>)[theItem.tabBar delegate];
        if(delegate && [delegate respondsToSelector:@selector(tabBar:closeTabItem:)]){
            [delegate tabBar:theItem.tabBar closeTabItem:theItem];
        }
    }
}
@end
