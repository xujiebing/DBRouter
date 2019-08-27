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
    __block NSInteger dd = 3;
    dispatch_async(dispatch_get_main_queue(), ^{
        dd = 99;
    });
    NSLog(@"");
}

@end
