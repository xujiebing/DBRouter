//
//  NSDictionary+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import "NSDictionary+DBRouter.h"

@implementation NSDictionary (DBRouter)

+ (BOOL (^)(NSDictionary * _Nonnull))dbIsEmpty {
    BOOL (^block)(NSDictionary *) = ^(NSDictionary *dic) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return YES;
        }
        NSArray *array = [dic allKeys];
        if (array.count == 0) {
            return YES;
        }
        return NO;
    };
    return block;
}

+ (id  _Nonnull (^)(NSDictionary * _Nonnull, NSString * _Nonnull))dbObjectForKey {
    id (^block)(NSDictionary *, NSString *) = ^(NSDictionary *dic, NSString *key) {
        id value = nil;
        if (NSDictionary.dbIsEmpty(dic)) {
            return value;
        }
        if (NSString.dbIsEmpty(key)) {
            return value;
        }
        NSArray *array = [dic allKeys];
        if (![array containsObject:key]) {
            return value;
        }
        value = [dic objectForKey:key];
        return value;
    };
    return block;
}

@end

@implementation NSMutableDictionary (DBRouter)

+ (BOOL (^)(NSMutableDictionary * _Nonnull))dbIsEmpty {
    BOOL (^block)(NSMutableDictionary *) = ^(NSMutableDictionary *dic) {
        if (![dic isKindOfClass:[NSMutableDictionary class]]) {
            return YES;
        }
        NSArray *array = [dic allKeys];
        if (array.count == 0) {
            return YES;
        }
        return NO;
    };
    return block;
}

+ (void (^)(NSMutableDictionary * _Nonnull, NSString * _Nonnull, id _Nonnull))dbSetValueForKey {
    void (^block)(NSMutableDictionary *, NSString *, id) = ^(NSMutableDictionary *dic, NSString *key, id value) {
        if (![dic isKindOfClass:[NSMutableDictionary class]]) {
            return ;
        }
        if (NSString.dbIsEmpty(key)) {
            return ;
        }
        if (!value) {
            return ;
        }
        [dic setValue:value forKey:key];
    };
    return block;
}

+ (void (^)(NSMutableDictionary * _Nonnull, NSString * _Nonnull, id _Nonnull))dbSetObjectForKey {
    void (^block)(NSMutableDictionary *, NSString *, id) = ^(NSMutableDictionary *dic, NSString *key, id object) {
        if (![dic isKindOfClass:[NSMutableDictionary class]]) {
            return ;
        }
        if (NSString.dbIsEmpty(key)) {
            return ;
        }
        if (!object) {
            return ;
        }
        [dic setObject:object forKey:key];
    };
    return block;
}

@end
