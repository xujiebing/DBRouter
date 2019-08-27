//
//  DBRouterTool.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/13.
//

#import "DBRouterTool.h"
#import <objc/message.h>

@implementation DBRouterTool

+ (NSString *(^)(NSString *))filterUrlParams {
    NSString *(^block)(NSString *) = ^(NSString *url) {
        NSString *targetUrl = nil;
        if(NSString.dbIsEmpty(url)) {
            return targetUrl;
        }
        // 过滤参数
        NSArray *array = [url componentsSeparatedByString:@"?"];
        targetUrl = [array firstObject];
        return targetUrl;
    };
    return block;
}

+ (NSString *(^)(NSString *))filterUrlParamsAndScheme {
    NSString *(^block)(NSString *) = ^(NSString *url) {
        NSString *targetUrl = nil;
        if(NSString.dbIsEmpty(url)) {
            return targetUrl;
        }
        // 过滤参数
        NSArray *array = [url componentsSeparatedByString:@"?"];
        targetUrl = [array firstObject];
        
        // 过滤scheme码
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:targetUrl];
        NSString *scheme = urlComponents.scheme;
        
        NSRange range = [targetUrl rangeOfString:scheme];
        if (range.location == NSNotFound) {
            return targetUrl;
        }
        // 这里+3是把 :// 一起加上了
        NSInteger index = range.location + range.length + 3;
        if (targetUrl.length > index) {
            targetUrl = [targetUrl substringFromIndex:index];
        }
        
        return targetUrl;
    };
    return block;
}

+ (BOOL (^)(NSUInteger))switchTabbarIndex {
    BOOL (^block)(NSUInteger) = ^(NSUInteger index) {
        UIViewController *lastViewController = UIViewController.lastViewController;
        UITabBarController *tabBar = lastViewController.tabBarController;
        if (index >= tabBar.childViewControllers.count) {
            return NO;
        }
        // FIXME:
        [lastViewController.navigationController popToRootViewControllerAnimated:YES];
        lastViewController.tabBarController.selectedIndex = index;
        return YES;
    };
    return block;
}

+ (BOOL (^)(NSString * _Nonnull))openUrlInSafari {
    BOOL (^block)(NSString *) = ^(NSString *url) {
        NSURL *nsurl = [NSURL URLWithString:url];
        // FIXME:
        if(![[UIApplication sharedApplication] canOpenURL:nsurl]) {
            DBRouterLog(@"打开系统自带浏览器时, URL格式传的不对, URL是:%@", url);
            return NO;
        }
        [[UIApplication sharedApplication] openURL:nsurl];
        return YES;
    };
    return block;
}

+ (NSString * _Nonnull (^)(NSString * _Nonnull))fullPathWithFileName {
    NSString *(^block)(NSString *) = ^(NSString *fileName) {
        NSString *fullPath = nil;
        if(NSString.dbIsEmpty(fileName)) {
            return fullPath;
        }
        NSBundle *bundle = [NSBundle mainBundle];
        fullPath = [bundle pathForResource:fileName ofType:@"json"];
        return fullPath;
    };
    return block;
}

+ (id  _Nonnull (^)(NSString * _Nonnull))loadJSONFileWithPath {
    id (^block)(NSString *) = ^(NSString *path) {
        id content = nil;
        if(NSString.dbIsEmpty(path)) {
            return content;
        }
        NSError *error = nil;
        NSString *result = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        // 如果读取不到说明未配置文件
        if(!result) {
            DBRouterLog(@"尚未配置[%@]文件, 或此文件格式不正确", path);
            return content;
        }
        content = NSString.dbJsonObject(result);
        return content;
    };
    return block;
}

+ (NSString * _Nonnull (^)(id _Nonnull))className {
    NSString * (^block)(id) = ^(id object){
        NSString *className = nil;
        if (!object) {
            return className;
        }
        className = [NSString stringWithUTF8String:class_getName([object class])];
        return className;
    };
    return block;
}

#pragma mark 私有方法

@end
