//
//  NSString+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/15.
//

#import "NSString+DBRouter.h"

@implementation NSString (DBRouter)

// FIXME:验证非NSString是否会执行该方法
- (BOOL)isEmpty {
    if (!self) {
        return YES;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (self.length == 0) {
        return YES;
    }
    return NO;
}

@end
