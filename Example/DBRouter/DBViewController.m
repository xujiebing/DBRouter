//
//  DBViewController.m
//  DBRouter
//
//  Created by xujiebing on 08/06/2019.
//  Copyright (c) 2019 xujiebing. All rights reserved.
//

#import "DBViewController.h"
#import "DBRouterManager.h"
#import "NSDictionary+DBRouter.h"
#import "NSString+DBRouter.h"
#import "NSArray+DBRouter.h"
#import "DBRouterModel.h"

@interface DBViewController ()
@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"page0";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 60)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    DBRouterManager.routerManager.setScheme(@[@"DB"]);
}

- (void)p_clickBtn {
    DBRouterManager.routerManager.routerWithUrl(@"DB://m.bwton.com/page2/findpage1u?jumptype=1");
}

- (void)dbSetParameter:(NSDictionary *)params {
    
}

- (void)dbOnNextPopResult:(NSDictionary *)params {
    
}


@end
