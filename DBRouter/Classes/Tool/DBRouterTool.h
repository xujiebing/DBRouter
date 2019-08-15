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
 URL编码

 @param str str
 @return 编码后的str
 */
+ (NSString *)URLDecodedString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
