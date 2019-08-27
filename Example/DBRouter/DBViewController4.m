//
//  DBViewController4.m
//  DBRouter_Example
//
//  Created by 徐结兵 on 2019/8/27.
//  Copyright © 2019 xujiebing. All rights reserved.
//

#import "DBViewController4.h"
#import <DBRouter/DBRouter.h>

@interface DBViewController4 ()

@end

@implementation DBViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"page4";
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 60)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)p_clickBtn {
    DBRouterManager.routerManager.popRouterWithIndex(2);
}

- (void)dbSetParameter:(NSDictionary *)params {
    
}

- (void)dbOnNextPopResult:(NSDictionary *)params {
    
}

@end
