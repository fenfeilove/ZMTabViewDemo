//
//  ZMTabItemCell.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabItemCell.h"

@interface ZMCloseButton : NSButton
@end

@implementation ZMCloseButton
- (id)init{
    self = [super initWithFrame:NSMakeRect(0, 0, 16, 16)];
    if(self){
        self.image = [NSImage imageNamed:NSImageNameAddTemplate];
        self.imagePosition = NSImageOnly;
    }
    return self;
}
- (NSImage*)image{
    if(self.window.firstResponder == self){
        return [super image];
    }
    return nil;
}
@end

@interface ZMTabItemCell()
@property(strong)ZMCloseButton* closeButton;
@end

@implementation ZMTabItemCell
- (id)init{
    self = [super init];
    if(self){
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    _closeButton = [[ZMCloseButton alloc] init];
    [_closeButton setTarget:self];
    [_closeButton setAction:@selector(onCloseButtonClick:)];
    [_closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_closeButton];

    NSArray* theArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_closeButton(16)]-10-|"
                                                                options:0
                                                                metrics:nil views:NSDictionaryOfVariableBindings(_closeButton)];
    [self addConstraints:theArray];
//    theArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_closeButton(16)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_closeButton)];
//    [self addConstraints:theArray];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
}
- (void)onCloseButtonClick:(id)sender{
    NSLog(@"%s",__func__);
}
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setNeedsDisplay:YES];
}
- (BOOL)becomeFirstResponder{
    BOOL result = [super becomeFirstResponder];
    [self setNeedsDisplay:YES];
    return result;
}
- (BOOL)resignFirstResponder{
    BOOL result = [super resignFirstResponder];
    [self setNeedsDisplay:YES];
    return result;
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
}
@end
