//
//  UIApplication+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/27.
//

#import "UIApplication+DBRouter.h"

@implementation UIApplication (DBRouter)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0) {
            [self swizzleMethod](@selector(application:openURL:options:), @selector(dbRouterApplication:openURL:options:));
        } else {
            [self swizzleMethod](@selector(application:openURL:sourceApplication:annotation:), @selector(dbRouterApplication:openURL:sourceApplication:annotation:));
        }
    });
}

// iOS9.0以下执行该方法
- (BOOL)dbRouterApplication:(UIApplication *)application
                    openURL:(NSURL *)url
          sourceApplication:(NSString *)sourceApplication
                 annotation:(id)annotation {
    DBRouterManager.routerManager routerUrl(url);
    return YES;
}

// iOS9.0及以上执行该方法
- (BOOL)dbRouterApplication:(UIApplication *)app
                    openURL:(NSURL *)url
                    options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DBRouterManager.routerManager routerUrl(url);
    return YES;
}

@end
