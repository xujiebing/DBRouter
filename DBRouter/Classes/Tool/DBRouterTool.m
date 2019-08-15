//
//  DBRouterTool.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/13.
//

#import "DBRouterTool.h"

@implementation DBRouterTool

+ (NSString *)URLDecodedString:(NSString *)str {
    if (str.isEmpty) {
        return nil;
    }
    NSString *decodedString = (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
