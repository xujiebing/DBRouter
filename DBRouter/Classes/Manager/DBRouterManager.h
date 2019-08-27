//
//  DBRouterManager.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DBRouterComplete)(BOOL complete);

@interface DBRouterManager : NSObject

/**
 初始化router
 */
+ (DBRouterManager *)routerManager;

/**
 设置合法scheme
 */
- (void (^)(NSArray *_Nonnull))setScheme;

/**
 设置路由文件路径
 routerNameFilePath:页面名与路由url关系配置文件
 routerClassFilePath:路由url与本地类名映射配置文件
 routerWhiteFilePath:白名单路由url配置文件,用于外部跳转
 */
- (void (^)(NSString *_Nullable routerNameFilePath, NSString *_Nullable routerClassFilePath, NSString *_Nullable routerWhiteFilePath))setRouterFilePath;

/**
 更新路由文件路径
 routerNameFilePath:页面名与路由url关系配置文件
 routerClassFilePath:路由url与本地类名映射配置文件
 routerWhiteFilePath:白名单路由url配置文件,用于外部跳转
 */
- (void (^)(NSString *_Nullable routerNameFilePath, NSString *_Nullable routerClassFilePath, NSString *_Nullable routerWhiteFilePath))reloadRouterFilePath;

/**
 根据路由名进行跳转
 */
- (BOOL (^)(NSString *_Nonnull))routerWithName;

/**
 根据路由名和参数进行跳转
 routerName:路由名
 routerName:路由名
 */
- (BOOL (^)(NSString *_Nonnull routerName, NSDictionary *_Nullable params))routerWithNameAndParams;

/**
 根据路由url进行跳转
 */
- (BOOL (^)(NSString *_Nonnull))routerWithUrl;

/**
 根据路由url和参数进行跳转
 */
- (BOOL (^)(NSString * _Nonnull url, NSDictionary * _Nullable params))routerWithUrlAndParams;

/**
 第三方应用跳转到app页面
 */
- (BOOL (^)(NSURL *_Nonnull))routerUrl;

/**
 设置自定义404页面
 当找不到本地类时, 路由会跳转到内置的404页面,想自定义404页面，可调用此方法
 */
- (void (^)(UIViewController *_Nonnull))setNontFoundPage;

/**
 返回上级页面
 */
- (void)popRouter;

/**
 返回上级页面并传参
 */
- (void (^)(NSDictionary *_Nullable))popRouterWithResult;

/**
 返回N级页面
 */
- (void (^)(NSInteger))popRouterWithIndex;

/**
 返回指定页面
 */
- (void (^)(NSString *_Nonnull routerName, BOOL animated))popRouterWithNameAndAnimated;

@end

NS_ASSUME_NONNULL_END
