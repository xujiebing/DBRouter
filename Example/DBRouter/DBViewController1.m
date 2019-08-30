//
//  DBViewController1.m
//  DBRouter_Example
//
//  Created by 徐结兵 on 2019/8/27.
//  Copyright © 2019 xujiebing. All rights reserved.
//

#import "DBViewController1.h"
#import <DBRouter/DBRouter.h>

@interface DBViewController1 ()

@end

@implementation DBViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"page1";
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 60)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)p_clickBtn {
    DBRouterManager.routerManager.routerWithUrl(@"DBRouter://com.xujiebing.DBRouter/page1/index?jumptype=1");
}

- (void)dbSetParameter:(NSDictionary *)params {
    NSLog(@"log======%@", params);
}


@end
