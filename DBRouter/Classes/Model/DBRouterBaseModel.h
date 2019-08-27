//
//  DBRouterBaseModel.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBRouterBaseModel : NSObject

/**
 字典转模型
 */
+ (id (^)(NSDictionary *))dbObjectWithKeyValues;

/**
 模型转字典
 */
+ (NSDictionary *(^)(id))dbChangeModelToDic;

/**
 字典数组转模型数组
 */
+ (NSArray *(^)(NSArray *))dbModelArrayWithKeyValuesArray;

@end

NS_ASSUME_NONNULL_END
