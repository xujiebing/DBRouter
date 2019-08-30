//
//  DBRouterPopTool.h
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBRouterPopTool : NSObject

+ (void (^)(NSString *message))alert;

@end

NS_ASSUME_NONNULL_END
