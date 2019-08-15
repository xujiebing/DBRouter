//
//  NSDictionary+DBRouter.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import "NSDictionary+DBRouter.h"

@implementation NSDictionary (DBRouter)

- (id)dbObjectForKey:(NSString *)key {
    if (![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *array = [self allKeys];
    if (![array containsObject:key]) {
        return nil;
    }
    id value = [self objectForKey:key];
    return value;
}

- (void)dbSetValue:(id)value forKey:(id)key {
    if (!value) {
        value = @"";
    }
    if (!key) {
        key = @"";
    }
    [self setValue:value forKey:key];
}

@end

@implementation NSMutableDictionary (DBRouter)

- (void)dbSetObject:(id)object forKey:(id)key {
    if (!object) {
        object = @"";
    }
    if (!key) {
        key = @"";
    }
    [self setObject:object forKey:key];
}

@end
