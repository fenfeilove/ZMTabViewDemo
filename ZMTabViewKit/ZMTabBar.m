//
//  ZMTabBar.m
//  ZMTabViewKit
//
//  Created by francis zhuo on 2018/6/21.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabBar.h"
#import "ZMTabItemCell.h"

@interface ZMTabItem()
@property(readwrite)ZMTabBar* tabBar;
@end

@implementation ZMTabItem
- (id)initWithIdentifier:(NSString *)identifier{
    self = [super init];
    if(self){
        _identifier = [identifier copy];
    }
    return self;
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

@end

@interface ZMTabBar()
{
    NSButton*       _addItem;
    NSMutableArray<ZMTabItemCell*>* _itemCells;
}
@property(strong)id<ZMTabBarStyle> style;
@property(nullable, readwrite, strong) ZMTabItemCell *selectedTabItemCell;
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
}

- (NSButton*)addItem{
    if(!_addItem){
        _addItem = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
        [_addItem setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
        [_addItem setImagePosition:NSImageOnly];
        [self addSubview:_addItem];
        [_addItem setHidden:!self.showAddItem];
    }
    return _addItem;
}
- (void)setShowAddItem:(BOOL)showAddItem{
    _showAddItem = showAddItem;
    [_addItem setHidden:!showAddItem];
}
- (void)addTabItem:(ZMTabItem *)item{
    [self insertTabItem:item atIndex:[_itemCells count]];
}
- (void)insertTabItem:(ZMTabItem*)item atIndex:(NSUInteger)index{
    if(!item)
        return;
    ZMTabItemCell* cell = [[ZMTabItemCell alloc] initWithFrame:self.bounds];
    [cell setTabBar:self];
    [cell setTabItem:item];
    [cell setTitle:item.title];
    [cell setTarget:self];
    [cell setAction:@selector(onTabItemCellClick:)];
    [self _insertTabItemCell:cell atIndex:index];
    [item setTabBar:self];
}
- (void)_insertTabItemCell:(ZMTabItemCell*)cell atIndex:(NSUInteger)index{
    if(!cell || index > _itemCells.count)
        return;
    [_itemCells insertObject:cell atIndex:index];
    [self addSubview:cell];
    if(self.tabBarStyle && [self.tabBarStyle respondsToSelector:@selector(tabBar:didAddItem:inRect:)]){
        [self.tabBarStyle tabBar:self didAddItem:cell.tabItem inRect:cell.frame];
    }
    [self.window recalculateKeyViewLoop];
    [self selectTabItemAtIndex:index];
    [self relayout];
    NSAccessibilityPostNotification(self, NSAccessibilityLayoutChangedNotification);
}

- (void)removeTabItem:(ZMTabItem*)item{
    ZMTabItemCell* theCell = nil;
    for(ZMTabItemCell* cell in _itemCells){
        if(cell.tabItem == item){
            theCell = cell;
            break;
        }
    }
    [self _removeTabItemCell:theCell];
}
- (void)removeAllTabItem{
    while(_itemCells.count){
        [self _removeTabItemCell:_itemCells.firstObject];
    }
}
- (void)_removeTabItemCell:(ZMTabItemCell*)cell{
    if(cell){
        cell.target = nil;
        cell.action = nil;
        if([self.tabBarStyle respondsToSelector:@selector(tabBar:willRemoveItem:)]){
            [self.tabBarStyle tabBar:self willRemoveItem:cell.tabItem];
        }
        [cell removeFromSuperview];
        [_itemCells removeObject:cell];
        [self.window recalculateKeyViewLoop];
        [self relayout];
        NSAccessibilityPostNotification(self, NSAccessibilityLayoutChangedNotification);
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
            NSRect theRect = NSMakeRect(xPos, 0, singleWidth, singleHeight);
            cell.frame = theRect;
            if(self.tabBarStyle && [self.tabBarStyle respondsToSelector:@selector(tabBar:itemFrameChange:inRect:)]){
                [self.tabBarStyle tabBar:self itemFrameChange:cell.tabItem inRect:theRect];
            }
            xPos += singleWidth;
        }
    } completionHandler:^{
        
    }];
    
}

#pragma mark - select
- (void)selectTabItem:(nullable ZMTabItem*)item{
    __block ZMTabItemCell *cell = nil;
    [_itemCells enumerateObjectsUsingBlock:^(ZMTabItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tabItem == item){
            cell = obj;
            *stop = YES;
        }
    }];
    [self _selectTabItemCell:cell];
}
- (void)selectTabItemAtIndex:(NSInteger)index{
    ZMTabItemCell* cell = nil;
    if(index>=0 && index<_itemCells.count)
        cell = [_itemCells objectAtIndex:index];
    [self _selectTabItemCell:cell];
}
- (void)selectTabItemWithIdentifier:(id)identifier{
    __block ZMTabItemCell* cell = nil;
    [_itemCells enumerateObjectsUsingBlock:^(ZMTabItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.tabItem.identifier isEqual:obj]){
            cell = obj;
            *stop = YES;
        }
    }];
    [self _selectTabItemCell:cell];
}

- (void)_selectTabItemCell:(ZMTabItemCell*)cell{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBar:shouldSelectTabItem:)]){
        if(![self.delegate tabBar:self shouldSelectTabItem:cell.tabItem])
            return;
    }
    [_itemCells enumerateObjectsUsingBlock:^(ZMTabItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj != cell){
            obj.selected = NO;
        }
    }];
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willSelectTabItem:)]){
        [self.delegate tabBar:self willSelectTabItem:cell.tabItem];
    }
    cell.selected = YES;
    self.selectedTabItemCell = cell;
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectTabItem:)]){
        [self.delegate tabBar:self didSelectTabItem:cell.tabItem];
    }
}

- (IBAction)selectFirstTabViewItem:(nullable id)sender{
    [self _selectTabItemCell:_itemCells.firstObject];
}
- (IBAction)selectLastTabViewItem:(nullable id)sender{
    [self _selectTabItemCell:_itemCells.lastObject];
}
- (IBAction)selectNextTabViewItem:(nullable id)sender{
    NSInteger index =  [_itemCells indexOfObjectPassingTest:^BOOL(ZMTabItemCell* cell, NSUInteger idx, BOOL *stop) {
        if(cell.tabItem == self.selectedTabItem){
            return YES;
        }
        return NO;
    }];
    if(index+1<_itemCells.count){
        [self selectTabItemAtIndex:index+1];
    }
}
- (IBAction)selectPreviousTabViewItem:(nullable id)sender{
    NSInteger index =  [_itemCells indexOfObjectPassingTest:^BOOL(ZMTabItemCell* cell, NSUInteger idx, BOOL *stop) {
        if(cell.tabItem == self.selectedTabItem){
            return YES;
        }
        return NO;
    }];
    if(index-1>=0){
        [self selectTabItemAtIndex:index-1];
    }
}
- (NSUInteger)numberOfTabItems{
    return _itemCells.count;
}
-(NSArray<ZMTabItem *> *)tabItems{
    NSMutableArray<ZMTabItem*> *tabItems = [NSMutableArray arrayWithCapacity:self.numberOfTabItems];
    [_itemCells enumerateObjectsUsingBlock:^(ZMTabItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tabItems addObject:obj.tabItem];
    }];
    return tabItems;
}
- (ZMTabItem*)selectedTabItem{
    return self.selectedTabItemCell.tabItem;
}
#pragma mark - action
- (void)onTabItemCellClick:(ZMTabItemCell*)sender{
    [self _selectTabItemCell:sender];
}
#pragma mark - key&mouse
- (void)moveLeft:(id)sender{
    NSLog(@"%s",__func__);
    if(self.window.firstResponder == self.addItem)
        return;
    [self selectPreviousTabViewItem:sender];
    [self.window makeFirstResponder:self.selectedTabItemCell];
}
- (void)moveRight:(id)sender{
    NSLog(@"%s",__func__);
    if(self.window.firstResponder == self.addItem)
        return;
    [self selectNextTabViewItem:sender];
    [self.window makeFirstResponder:self.selectedTabItemCell];
}
#pragma mark - drawRect
- (void)drawRect:(NSRect)dirtyRect {
    if([self.tabBarStyle respondsToSelector:@selector(drawTabBar:inRect:)]){
        [self.tabBarStyle drawTabBar:self inRect:dirtyRect];
    }
    else{
        NSRectFill(dirtyRect);
    }
}
#pragma mark - accessibility
//- (BOOL)acceptsFirstResponder{
//    return NO;
//}
- (BOOL)isAccessibilityElement{
    return YES;
}
//- (BOOL)accessibilityIsIgnored{
//    return NO;
//}
//- (NSArray*)accessibilityAttributeNames{
//    static NSArray *attributes = nil;
//    if(!attributes){
//        attributes = [@[NSAccessibilityRoleAttribute,
//                        NSAccessibilityRoleDescriptionAttribute,
//                        NSAccessibilityDescriptionAttribute,
//                        NSAccessibilityValueAttribute,
//                        NSAccessibilityChildrenAttribute,
//                        NSAccessibilityColumnCountAttribute] copy];
//    }
//    return attributes;
//}
//- (id)accessibilityAttributeValue:(NSString *)attribute{
//    if([attribute isEqualToString:NSAccessibilityRoleAttribute]){
//        return NSAccessibilityRoleAttribute;
//    }
//    else if([attribute isEqualToString:NSAccessibilityRoleDescriptionAttribute]){
//        return [NSString stringWithFormat:@"group"];
//    }
//    else if([attribute isEqualToString:NSAccessibilityDescriptionAttribute]){
//        return [NSString stringWithFormat:@"tab Bar, %ld tabs",_itemCells.count];
//    }
//    else if([attribute isEqualToString:NSAccessibilityValueAttribute]){
//        return self;
//    }
//    else if([attribute isEqualToString:NSAccessibilityChildrenAttribute]){
//        return NSAccessibilityUnignoredChildren(_itemCells);
//    }
//    else if([attribute isEqualToString:NSAccessibilityColumnCountAttribute]){
//        return @(_itemCells.count);
//    }
//    else {
//        NSLog(@"attribute = %@",attribute);
//        return [super accessibilityAttributeValue:attribute];
//    }
//}
- (NSAccessibilityRole)accessibilityRole{
    NSLog(@"%s",__func__);
    return NSAccessibilityTabGroupRole;
}

- (NSString *)accessibilityRoleDescription{
    return [NSString stringWithFormat:@"group"];
}
- (NSString *)accessibilityLabel{
    return [NSString stringWithFormat:@"tab Bar, %ld tabs",_itemCells.count];
}
- (NSArray*)accessibilityTabs{
    return _itemCells;
}
@end
