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

@end

@interface NSMutableArray (DBRouter)

/**
 判断数组是否为空
 */
+ (BOOL (^)(NSMutableArray *))dbIsEmpty;

@end

NS_ASSUME_NONNULL_END
