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
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"返回2级" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 60)];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitle:@"返回指定页面" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(p_clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)p_clickBtn {
    DBRouterManager.routerManager.popRouterWithIndex(2);
}

- (void)p_clickBtn1 {
    DBRouterManager.routerManager.popRouterWithUrlAndAnimated(@"DBRouter://com.xujiebing.DBRouter/page2/findpage", YES);
}

- (void)dbSetParameter:(NSDictionary *)params {
    
}


@end
