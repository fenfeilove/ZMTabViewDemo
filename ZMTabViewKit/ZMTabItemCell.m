//
//  ZMTabItemCell.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabItemCell.h"
#import "ZMTabBar.h"

@interface ZMTabItemCell()
@end

@implementation ZMTabItemCell
- (id)init{
    self = [super init];
    if(self){
    }
    return self;
}
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:4 yRadius:4];
    [[NSColor blueColor] set];
    [path fill];
    [[NSColor redColor] set];
    [path stroke];
    
    if(self.selected){
        [[NSColor grayColor] set];
        [path fill];
    }
    
    NSAttributedString* theStr = [[NSAttributedString alloc] initWithString:self.title?:@"" attributes:nil];
    NSRect theRect = NSZeroRect;
    theRect.size = theStr.size;
    theRect.origin.x = (NSWidth(self.bounds) - NSWidth(theRect))/2.0;
    theRect.origin.y = (NSHeight(self.bounds) - NSHeight(theRect))/2.0;
    [theStr drawInRect:theRect];
}

- (BOOL)becomeFirstResponder{
    BOOL result = [super becomeFirstResponder];
    [self setNeedsDisplay:YES];
    NSAccessibilityPostNotification(self,NSAccessibilityFocusedUIElementChangedNotification);
    return result;
}
- (BOOL)resignFirstResponder{
    BOOL result = [super resignFirstResponder];
    [self setNeedsDisplay:YES];
    return result;
}
#pragma mark - mouse/key action
- (void)mouseDown:(NSEvent *)event{
    [self.tabBar selectTabItem:self.tabItem];
    [self.window makeFirstResponder:self];
}
//- (void)keyDown:(NSEvent *)event{
//    if(event.keyCode == 0x31){//kVK_Space
//        [self.tabBar selectTabItem:self.tabItem];
//    }
//    else{
//        [super keyDown:event];
//    }
//}
#pragma mark - accessibility
- (BOOL)acceptsFirstResponder{
    return YES;
}
- (NSFocusRingType)focusRingType{
    return NSFocusRingTypeExterior;
}
- (void)drawFocusRingMask{
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:self.bounds];
    [path fill];
}
- (NSRect)focusRingMaskBounds{
    return self.bounds;
}
- (BOOL)isAccessibilityElement{
    return YES;
}
- (NSString *)accessibilityTitle{
    return self.title?:@"";
}
- (NSAccessibilityRole)accessibilityRole{
    NSLog(@"%s",__func__);
    return NSAccessibilityRadioButtonRole;
}
- (NSAccessibilitySubrole)accessibilitySubrole{
    NSLog(@"%s",__func__);
    return NSAccessibilityTabButtonSubrole;
}
- (id)accessibilityParent{
    return self.tabBar;
}
- (BOOL)accessibilityPerformPress{
    [self.tabBar selectTabItem:self.tabItem];
    return YES;
}
- (BOOL)accessibilityPerformShowMenu{
    return YES;
}
- (BOOL)isAccessibilitySelected{
    return self.selected;
}
@end

