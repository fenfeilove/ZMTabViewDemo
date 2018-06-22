//
//  ZMTabBar.m
//  ZMTabViewKit
//
//  Created by francis zhuo on 2018/6/21.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabBar.h"
#import "ZMTabItemCell.h"

@implementation ZMTabItem
- (id)initWithIdentifier:(NSString *)identifier{
    self = [super init];
    if(self){
        _identifier = [identifier copy];
    }
    return self;
}
@end

@interface ZMTabBar()
{
    NSButton*       _addItem;
    NSMutableArray<ZMTabItemCell*>* _itemCells;
}
@property(strong)id<ZMTabBarStyle> style;
@end

@implementation ZMTabBar

- (id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        _itemCells = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if(self){
        _itemCells = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)awakeFromNib{
    [self relayout];
}

- (NSString*)tabBarStyleName{
    return [self.style.class className];
}
- (void)setTabBarStyleName:(NSString *)tabBarStyleName{
    Class<ZMTabBarStyle> styleClass = NSClassFromString(tabBarStyleName);
    self.style = [[(Class)styleClass alloc] init];
    self.tabBarStyle = self.style;
    NSLog(@"%s %@",__func__,self.tabBarStyle);
}

- (NSButton*)addItem{
    if(!_addItem){
        _addItem = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
        [_addItem setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
        [_addItem setImagePosition:NSImageOnly];
        [self addSubview:_addItem];
    }
    return _addItem;
}

- (void)addTabItem:(ZMTabItem *)item{
    [self insertTabItem:item atIndex:[_itemCells count]];
}
- (void)insertTabItem:(ZMTabItem*)item atIndex:(NSUInteger)index{
    if(!item)
        return;
    ZMTabItemCell* cell = [[ZMTabItemCell alloc] init];
    [cell setTabBar:self];
    [cell setTabItem:item];
    [self insertTabItemCell:cell atIndex:index];
}
- (void)insertTabItemCell:(ZMTabItemCell*)cell atIndex:(NSUInteger)index{
    if(!cell || index > _itemCells.count)
        return;
    [_itemCells insertObject:cell atIndex:index];
    [self addSubview:cell];
    [self relayout];
}

- (void)removeTabItem:(ZMTabItem*)item{
    ZMTabItemCell* theCell = nil;
    for(ZMTabItemCell* cell in _itemCells){
        if(cell.tabItem == item){
            theCell = cell;
            break;
        }
    }
    [self removeTabItemCell:theCell];
}
- (void)removeTabItemCell:(ZMTabItemCell*)cell{
    if(cell){
        [cell removeFromSuperview];
        [_itemCells removeObject:cell];
        [self relayout];
    }
}

- (ZMTabItem*)tabItemAtIndex:(NSInteger)index{
    if(index>=0 && index<_itemCells.count)
        return [[_itemCells objectAtIndex:index] tabItem];
    return nil;
}
- (NSInteger)indexOfTabItemWithIdentifier:(id)identifier{
    return [_itemCells indexOfObjectPassingTest:^BOOL(ZMTabItemCell* cell, NSUInteger idx, BOOL *stop) {
        if([cell.tabItem.identifier isEqual:identifier]){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
}
- (void)layout{
    [self relayout];
}
- (void)relayout{
    [self relayout:YES];
}
- (void)relayout:(BOOL)animate{
    CGFloat width = NSWidth(self.bounds);
    if(self.showAddItem){
        width -= NSWidth(self.addItem.frame);
        self.addItem.frame = ({
            NSRect theRect = self.addItem.frame;
            theRect.origin.x = width;
            theRect;
        });
    }
    if(!_itemCells.count)
        return;
    CGFloat singleWidth = floor(width/_itemCells.count);
    CGFloat singleHeight = NSHeight(self.bounds);
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 0.5;
        CGFloat xPos = 0;
        for(ZMTabItemCell* cell in _itemCells){
            cell.frame = ({
                NSRect theRect = NSMakeRect(xPos, 0, singleWidth, singleHeight);
                theRect;
            });
            xPos += singleWidth;
        }
    } completionHandler:^{
        
    }];
    
}

#pragma mark - select
- (void)selectTabItem:(nullable ZMTabItem*)item{
    NSInteger index =  [_itemCells indexOfObjectPassingTest:^BOOL(ZMTabItemCell* cell, NSUInteger idx, BOOL *stop) {
        if(cell.tabItem == item){
            return YES;
        }
        return NO;
    }];
    [self selectTabItemAtIndex:index];
}
- (void)selectTabItemAtIndex:(NSInteger)index{
    
}
- (void)selectTabItemWithIdentifier:(id)identifier{
    NSInteger index =  [_itemCells indexOfObjectPassingTest:^BOOL(ZMTabItemCell* cell, NSUInteger idx, BOOL *stop) {
        if([cell.tabItem.identifier isEqual:identifier]){
            return YES;
        }
        return NO;
    }];
    [self selectTabItemAtIndex:index];
}

#pragma mark - drawRect
- (void)drawRect:(NSRect)dirtyRect {
    if([self.tabBarStyle respondsToSelector:@selector(drawTabBarControl:inRect:)]){
        [self.tabBarStyle drawTabBarControl:self inRect:dirtyRect];
    }
    else{
        NSRectFill(dirtyRect);
    }
}
@end
