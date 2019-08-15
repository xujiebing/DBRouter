//
//  DBRouterModel.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DBRouterPush = 1,
    DBRouterPresent = 2,
    DBCube = 3,//立方体
    DBSuckEffect = 4,//吮吸
    DBOglFlip = 5,//翻转
    DBRippleEffect = 6,//波纹
    DBPageCurl = 7,//翻页
    DBCameraIrisHollowOpen = 8,//开镜头
    DBFlipFromRight = 9//右翻转
} DBRouterJumpType;

@interface DBRouterModel : NSObject

/**
 路由url规则, schema DB-原生跳转 http-外部浏览器
 */
@property (nonatomic, copy) NSString * _Nonnull url;

/**
 实际跳转的URL
 */
@property (nonatomic, copy) NSString * _Nonnull targetURL;

/**
 URL转换后的对象
 */
@property (nonatomic, strong) NSURLComponents *_Nonnull targetURLComponents;

/**
 控制器类名
 */
@property (nonatomic, copy) NSString * _Nullable className;

/**
 跳转到原生的参数
 */
@property (nonatomic, strong) NSDictionary * _Nullable params;

/**
 跳转方式：1-push 2-present
 */
@property (nonatomic, assign) DBRouterJumpType jumpType;

- (instancetype _Nullable)initWithDic:(NSDictionary *_Nonnull)dic;

@end

NS_ASSUME_NONNULL_END
