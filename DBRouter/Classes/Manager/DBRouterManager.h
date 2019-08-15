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

+ (DBRouterManager *)shareInstance;

/**
 初始化路由
 */
- (void)initRouter;

/**
 根据路由名进行路由跳转
 
 @param name 路由名
 @param block 回调
 */
- (void)routerWithRouterName:(NSString *_Nonnull)name
                    complete:(DBRouterComplete _Nullable)block;


/**
// 根据路由名和参数进行路由跳转
// 
// @param name 路由名
// @param params 请求参数
// */
//- (void)routerWithRouterName:(NSString *_Nonnull)name
//                      params:(NSDictionary *_Nullable)params
//                    complete:(void(^_Nullable)(BOOL finished))block;
//
///**
// 根据路由url进行跳转
// 
// @param url 实际的跳转url
// */
//- (void)routerWithURL:(NSString *_Nonnull)url
//             complete:(void(^_Nullable)(BOOL finished))block;
//
//

/**
 根据路由url和参数进行跳转

 @param url 跳转url
 @param params 参数
 @param complete 回调
 */
- (void)routerWithURL:(NSString *_Nonnull)url
               params:(NSDictionary *_Nullable)params
             complete:(DBRouterComplete _Nullable)complete;


@end

NS_ASSUME_NONNULL_END
