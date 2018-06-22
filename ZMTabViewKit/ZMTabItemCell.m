//
//  ZMTabItemCell.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/22.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ZMTabItemCell.h"

@interface ZMTabItemCell()
@property(strong)NSButton* contentButton;
@end

@implementation ZMTabItemCell
- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:4 yRadius:4];
    [[NSColor blueColor] set];
    [path fill];
    [[NSColor redColor] set];
    [path stroke];
}

@end
