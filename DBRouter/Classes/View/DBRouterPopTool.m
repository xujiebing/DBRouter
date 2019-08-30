//
//  DBRouterPopTool.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/30.
//

#import "DBRouterPopTool.h"

@implementation DBRouterPopTool

+ (void (^)(NSString * _Nonnull))alert {
    void (^block)(NSString *) = ^(NSString *message){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        UIViewController *vc = UIViewController.lastViewController;
        [vc presentViewController:alert animated:YES completion:nil];
    };
    return block;
}

@end
