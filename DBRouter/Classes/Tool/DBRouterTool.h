//
//  DBRouterTool.h
//  DBRouter
//  工具类
//  Created by 徐结兵 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBRouterTool : NSObject

/**
 过滤url请求参数
 */
+ (NSString *(^)(NSString *))filterUrlParams;

/**
 过滤url请求参数和scheme://
 */
+ (NSString *(^)(NSString *))filterUrlParamsAndScheme;

/**
 切换tabbar
 */
+ (BOOL (^)(NSUInteger))switchTabbarIndex;

/**
 safari中打开url
 */
+ (BOOL (^)(NSString *))openUrlInSafari;

/**
 获取文件完整路径
 */
+ (NSString *(^)(NSString *))fullPathWithFileName;

/**
 获取本地文件内容
 */
+ (id (^)(NSString *))loadJSONFileWithPath;

/**
 获取对象类名
 */
+ (NSString * (^)(id))className;

@end

NS_ASSUME_NONNULL_END
