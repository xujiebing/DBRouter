//
//  NSArray+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/21.
//

#import "NSArray+DBRouter.h"

@implementation NSArray (DBRouter)

+ (BOOL (^)(NSArray * _Nonnull))dbIsEmpty {
    BOOL (^block)(NSArray *) = ^(NSArray *array) {
        if (![array isKindOfClass:[NSArray class]]) {
            return YES;
        }
        if (array.count == 0) {
            return YES;
        }
        return NO;
    };
    return block;
}

@end

@implementation NSMutableArray (DBRouter)

+ (BOOL (^)(NSMutableArray * _Nonnull))dbIsEmpty {
    BOOL (^block)(NSMutableArray *) = ^(NSMutableArray *array) {
        if (![array isKindOfClass:[NSMutableArray class]]) {
            return YES;
        }
        if (array.count == 0) {
            return YES;
        }
        return NO;
    };
    return block;
}

@end
