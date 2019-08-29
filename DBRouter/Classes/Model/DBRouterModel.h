//
//  DBRouterModel.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import <Foundation/Foundation.h>
#import "DBRouterBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DBRouterPush = 1,
    DBRouterPresent = 2,
} DBRouterJumpType;

@interface DBRouterModel : DBRouterBaseModel

/**
 设置model参数
 */
- (DBRouterModel *(^)(NSString *url, NSDictionary *params))addParameters;

/**
 路由url
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull url;

/**
 url转换后的对象
 */
@property (nonatomic, strong, readonly) NSURLComponents *_Nonnull urlComponents;

/**
 页面名称
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull iclass;

/**
 跳转到原生的参数
 */
@property (nonatomic, strong, readonly) NSDictionary * _Nullable params;

/**
 跳转方式：1-push 2-present
 */
@property (nonatomic, assign, readonly) DBRouterJumpType jumpType;

@end

NS_ASSUME_NONNULL_END
