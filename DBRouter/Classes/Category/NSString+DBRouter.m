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

+ (NSString * _Nonnull (^)(NSString * _Nonnull))dbUrlDecodeString {
    NSString *(^block)(NSString *) = ^(NSString *string) {
        NSString *decodeString = nil;
        if (NSString.dbIsEmpty(string)) {
            return decodeString;
        }
        decodeString = (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        return decodeString;
    };
    return block;
}

+ (id  _Nonnull (^)(NSString * _Nonnull))dbJsonObject {
    id (^block)(NSString *) = ^(NSString *string) {
        id complete = nil;
        if (NSString.dbIsEmpty(string)) {
            return complete;
        }
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        complete = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            DBRouterLog(@"dbJsonObject error:%@", error)
        }
        return complete;
    };
    return block;
}

@end
