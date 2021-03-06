//
//  UIViewController+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/26.
//

#import "UIViewController+DBRouter.h"

@implementation UIViewController (DBRouter)


+ (UIViewController *)lastViewController {
    UIViewController *viewController = nil;
    
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if([vc isKindOfClass:[UITabBarController class]]) {
        viewController = ((UITabBarController *)vc).selectedViewController;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        viewController = ((UINavigationController *)vc).visibleViewController;
    } else {
        viewController = vc;
    }
    if (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = ((UINavigationController *)viewController).visibleViewController;
    }
    return viewController;
}

@end
