//
//  NSString+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/15.
//

#import "NSString+DBRouter.h"

@implementation NSString (DBRouter)

+ (BOOL (^)(NSString * _Nonnull))dbIsEmpty {
    BOOL (^block)(NSString *) = ^(NSString *string) {
        if (![string isKindOfClass:[NSString class]]) {
            return YES;
        }
        if (string.length == 0) {
            return YES;
        }
        return NO;
    };
    return block;
}

@end
