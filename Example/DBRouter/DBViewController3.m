//
//  DBViewController3.m
//  DBRouter_Example
//
//  Created by 徐结兵 on 2019/8/27.
//  Copyright © 2019 xujiebing. All rights reserved.
//

#import "DBViewController3.h"
#import <DBRouter/DBRouter.h>

@interface DBViewController3 ()

@end

@implementation DBViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"page3";
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 60)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)p_clickBtn {
    DBRouterManager.routerManager.routerWithUrl(@"DB://m.bwton.com/page2/findpage1?jumptype=1");
}

- (void)dbSetParameter:(NSDictionary *)params {
    
}

- (void)dbOnNextPopResult:(NSDictionary *)params {
    
}

@end
