//
//  DBViewController.m
//  DBRouter
//
//  Created by xujiebing on 08/06/2019.
//  Copyright (c) 2019 xujiebing. All rights reserved.
//

#import "DBViewController.h"
#import "NSDictionary+DBRouter.h"
#import "NSString+DBRouter.h"
#import "NSArray+DBRouter.h"

@interface DBViewController ()

@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"de":@"s"}];
    NSString *d = NSMutableDictionary.dbObjectForKey(dic, @"de");
    BOOL empty = NSDictionary.dbIsEmpty(dic);
    if (empty) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
