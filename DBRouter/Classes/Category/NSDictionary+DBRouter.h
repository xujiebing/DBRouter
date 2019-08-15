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
 获取字段value，防止越界crash

 @param key key
 @return value
 */
- (id)dbObjectForKey:(NSString *)key;

/**
 字典设置key value
 
 @param value value
 @param key key
 */
- (void)dbSetValue:(id)value forKey:(id)key;

@end

@interface NSMutableDictionary (DBRouter)

/**
 字典设置key object
 
 @param object object
 @param key key
 */
- (void)dbSetObject:(id)object forKey:(id)key;

@end

NS_ASSUME_NONNULL_END
