//
//  ViewController.m
//  ZMTabViewDemo
//
//  Created by francis zhuo on 2018/6/21.
//  Copyright © 2018 zoom. All rights reserved.
//

#import "ViewController.h"
#import "ZMTabBar.h"
@interface ViewController()
@property(weak)IBOutlet ZMTabBar* tabBar;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.window setAutorecalculatesKeyViewLoop:YES];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_tabBar.tabBarStyleName);
    self.tabBar.addItem.target = self;
    self.tabBar.addItem.action = @selector(onAddCliek:);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onAddCliek:(id)sender{
    ZMTabItem* theItem = [[ZMTabItem alloc] initWithIdentifier:@"hello"];
    [theItem setTitle:@"page"];
    [_tabBar addTabItem:theItem];
}
- (IBAction)onRemoveClick:(id)sender{
//    ZMTabItem* theItem = [_tabBar tabItemAtIndex:0];
//    [_tabBar removeTabItem:theItem];
    [_tabBar removeAllTabItem];
}
@end
