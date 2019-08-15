//
//  DBRouterModel.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/14.
//

#import "DBRouterModel.h"

@implementation DBRouterModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _url = [dic dbObjectForKey:@"url"];
        _className = [dic dbObjectForKey:@"iclass"];
    }
    return self;
}

- (void)setTargetURL:(NSString *)targetURL {
    _targetURL = targetURL;
    [self p_handlerParams:_targetURL];
}

- (void)p_handlerParams:(NSString *)url {
    if (url.isEmpty) {
        DBRouterLog(@"url 为空")
        return;
    }
    
    NSURLComponents *components = self.targetURLComponents;
    if (!components) {
        components = [[NSURLComponents alloc] initWithString:url];
    }
    
    NSArray *items = components.queryItems;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    __block NSInteger jumpType = 1;
    [items enumerateObjectsUsingBlock:^(NSURLQueryItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = item.name;
        NSString *value = item.value;
        if (!name.isEmpty && [name isEqualToString:kDBRouterJumpType]) {
            jumpType = value.integerValue;
        }
        [tempDic dbSetObject:value forKey:name];
    }];
    // 处理跳转方式
    self.jumpType = jumpType;
    // 处理参数
    if(tempDic) {
        self.params = tempDic;
    }
}

@end
