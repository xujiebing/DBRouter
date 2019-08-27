//
//  NSArray+DBRouter.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DBRouter)

/**
 判断数组是否为空
 */
+ (BOOL (^)(NSArray *))dbIsEmpty;

/**
 获取数组中对象
 */
+ (id (^)(NSArray *array, NSUInteger index))dbObjectAtIndex;

@end

@interface NSMutableArray (DBRouter)

/**
 判断数组是否为空
 */
+ (BOOL (^)(NSMutableArray *))dbIsEmpty;

/**dbA
 可变数组中添加对象
 */
+ (void (^)(NSMutableArray *array, id object))dbAddObject;

@end

NS_ASSUME_NONNULL_END
