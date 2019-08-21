//
//  NSDictionary+DBRouter.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (DBRouter)

/**
 判断字典是否为空
 */
+ (BOOL (^)(NSDictionary *))dbIsEmpty;

/**
 获取字典value，防止越界crash
 */
+ (id (^)(NSDictionary *dic, NSString *key))dbObjectForKey;

@end

@interface NSMutableDictionary (DBRouter)

/**
 判断字典是否为空
 */
+ (BOOL (^)(NSMutableDictionary *))dbIsEmpty;

/**
 字典设置key value
 */
+ (void (^)(NSMutableDictionary *dic, NSString *key, id value))dbSetValueForKey;

/**
 字典设置key object
 */
+ (void (^)(NSMutableDictionary *dic, NSString *key, id object))dbSetObjectForKey;

@end

NS_ASSUME_NONNULL_END
