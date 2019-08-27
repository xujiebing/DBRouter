//
//  DBRouterModel.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import "DBRouterModel.h"

@interface DBRouterModel ()

@property (nonatomic, strong, readwrite) NSURLComponents *_Nonnull urlComponents;
@property (nonatomic, strong, readwrite) NSDictionary * _Nullable params;
@property (nonatomic, assign, readwrite) DBRouterJumpType jumpType;
@property (nonatomic, copy, readwrite) NSString * _Nonnull targetURL;

@end

@implementation DBRouterModel

- (DBRouterModel * _Nonnull (^)(NSString * _Nonnull, NSDictionary * _Nonnull))addParameters {
    kDBWeakSelf
    DBRouterModel *(^block)(NSString *, NSDictionary *) = ^(NSString *url, NSDictionary *params) {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        if (!components) {
            return weakSelf;
        }
        weakSelf.urlComponents = components;
        NSArray *items = components.queryItems;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        __block NSInteger jumpType = 1;
        [items enumerateObjectsUsingBlock:^(NSURLQueryItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = item.name;
            NSString *value = item.value;
            if (!NSString.dbIsEmpty(name) && [name isEqualToString:kDBRouterJumpType]) {
                // 处理跳转方式
                jumpType = value.integerValue;
                weakSelf.jumpType = jumpType;
                return ;
            }
            NSMutableDictionary.dbSetObjectForKey(tempDic, name, value);
        }];
        // 参数合并
        NSMutableDictionary *dic = nil;
        if (NSDictionary.dbIsEmpty(params)) {
            dic = [[NSMutableDictionary alloc] init];
        } else {
            dic = [NSMutableDictionary dictionaryWithDictionary:params];
        }
        if (!NSDictionary.dbIsEmpty(tempDic)) {
            [dic addEntriesFromDictionary:tempDic];
        }
        weakSelf.params = dic;
        weakSelf.targetURL = DBRouterTool.filterUrlParamsAndScheme(url);
        return weakSelf;
    };
    return block;
}

@end
