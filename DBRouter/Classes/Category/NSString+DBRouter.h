//
//  NSString+DBRouter.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DBRouter)

/**
 判断字符串是否为空
 */
+ (BOOL (^)(NSString *))dbIsEmpty;

/**
 url编码
 */
+ (NSString * (^)(NSString *))dbUrlDecodeString;

/**
 字符串转对象
 */
+ (id (^)(NSString *))dbJsonObject;

@end

NS_ASSUME_NONNULL_END
