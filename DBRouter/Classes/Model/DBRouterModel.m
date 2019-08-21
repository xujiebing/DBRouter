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
        _url = NSDictionary.dbObjectForKey(dic, @"url");
        _className = NSDictionary.dbObjectForKey(dic, @"iclass");
    }
    return self;
}

- (void)setTargetURL:(NSString *)targetURL {
    _targetURL = targetURL;
    [self p_handlerParams:_targetURL];
}

- (void)p_handlerParams:(NSString *)url {
    if (NSString.dbIsEmpty(url)) {
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
        if (!NSString.dbIsEmpty(name) && [name isEqualToString:kDBRouterJumpType]) {
            jumpType = value.integerValue;
        }
        NSMutableDictionary.dbSetObjectForKey(tempDic, name, value);
    }];
    // 处理跳转方式
    self.jumpType = jumpType;
    // 处理参数
    if(tempDic) {
        self.params = tempDic;
    }
}

@end
