//
//  DBRouterManager.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/12.
//

#import "DBRouterManager.h"

#define DBRouter_TRY_BODY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
NSLog(@"exception ===== %@", [exception description]);\
}\
@finally {\
\
}

@interface DBRouterManager ()

@property (nonatomic, strong, readwrite) NSDictionary *routerNameDic;

@property (nonatomic, strong, readwrite) NSDictionary *routerDic;

/**
 404页面
 */
@property (nonatomic, strong) UIViewController *notFoundViewController;

@end

@implementation DBRouterManager

#pragma mark - 外部方法

static DBRouterManager *sharedInstance = nil;

+ (DBRouterManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

- (void)setScheme:(NSArray *)array {
    
}

- (void)routerWithURL:(NSString *)url
               params:(NSDictionary *)params
             complete:(DBRouterComplete)complete {
    // 根据url转成routerModel
    DBRouterModel *routerModel = [self p_modelWithURL:url];
    NSDictionary *modelParams = routerModel.params;
    
    // 参数合并
    if(params && [params isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:modelParams];
        [dic addEntriesFromDictionary:params];
        routerModel.params = dic;
    }
    
    // 进行路由操作
    [self p_routerWithModule:routerModel complete:complete];
}



#pragma park - 内部方法

/**
 根据url获取router model
 
 @param targetUrl 实际跳转的url
 @return router model
 */
- (DBRouterModel *)p_modelWithURL:(NSString *)targetUrl {
    
    __block DBRouterModel *model = nil;
    NSParameterAssert(targetUrl.length != 0);
    if (NSString.dbIsEmpty(targetUrl)) {
        DBRouterLog(@"url为空...");
        return model;
    }
    
    // 解析获取模块名，根据模块名获取对应的路由组，然后根据url获取到对应的class
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:targetUrl];
    
    if([components.scheme hasPrefix:@"http"]) {
        return nil;
    }
    
    BOOL isValid = [self p_checkURL:components];
    if (!isValid) {
        return nil;
    }
    
    NSString *moduleName = [self p_moduleNameWithURLPath:components.path];
    NSParameterAssert(moduleName && moduleName.length != 0);
    
    if(NSString.dbIsEmpty(moduleName)) {
        DBRouterLog(@"[%@]模块名为空", targetUrl);
        return model;
    }
    
    NSDictionary *routers = self.routerDic;
    if (!routers) {
        DBRouterLog(@"路由配置文件为空, 请检查路由");
        return model;
    }
    
    NSArray *array = NSDictionary.dbObjectForKey(routers, moduleName);
    if(!array || array.count == 0) {
        DBRouterLog(@"获取 [%@] 下的对应路由配置信息为空", moduleName);
        return model;
    }
    
    kWeakSelf
    [array enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        DBRouterModel *tempModel = [[DBRouterModel alloc] initWithDic:item];
        tempModel.targetURLComponents = components;
        
        // 过滤过滤scheme和请求参数
        NSString *modelURL = [weakSelf p_filterUrlParamsAndScheme:tempModel.url];
        NSString *targetURL = [weakSelf p_filterUrlParamsAndScheme:targetUrl];
        
        if([modelURL isEqualToString:targetURL]) {
            // 具体url需要通过外部传入
            tempModel.targetURL = targetUrl;
            model = tempModel;
            
            // 参数处理
            NSDictionary *dic = [weakSelf p_handlerParams:components];
            if(dic && dic.count > 0) {
                tempModel.params = dic;
            }
            *stop = YES;
        }
    }];
    
    return model;
}

/**
 url参数获取
 
 @param components url转换后的对象
 @return 请求参数
 */
- (NSDictionary *)p_handlerParams:(NSURLComponents *)components {
    return [self.class getParamsByComponents:components];
}


+ (NSDictionary *)getParamsByComponents:(NSURLComponents *)components {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if(!components) {
        return dic;
    }
    
    NSArray<NSURLQueryItem *> *items = components.queryItems;
    
    [items enumerateObjectsUsingBlock:^(NSURLQueryItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = item.name;
        NSString *value = item.value;
        
        // 过滤页面跳转类型
        if([name isEqualToString:kDBRouterJumpType]) {
            return;
        }
        NSMutableDictionary.dbSetObjectForKey(dic, name, value);
    }];
    
    return dic;
}


/**
 根据model进行路由跳转
 
 @param model 路由实体类
 */
- (void)p_routerWithModule:(DBRouterModel *_Nonnull)model
                complete:(void(^_Nullable)(BOOL finished))block {
    
    // 校验参数是否合法
    BOOL isValid = [self p_checkParamsWithModel:model];
    if (!isValid) {
        // FIXME:待处理
//        [BWTSVProgressHUD showErrorWithStatus:@"哎呦, 服务器出了点差错"];
        return;
    }
    
    [self p_router:model complete:block];
}


/**
 校验url是否合法
 校验规则:
 1、前缀必须msx开头
 2、必须要有host(可考虑只支持m.bwton.com)
 3、必须要有path
 
 @param urlComponents 路由url
 @return YES-合法 NO-非法
 */
- (BOOL)p_checkURL:(NSURLComponents *)urlComponents {
    
    // 非msx前缀开头不合法
    if (![urlComponents.scheme hasPrefix:@"msx"]) {
        DBRouterLog(@"前缀非msx开头, 非法路径");
        return NO;
    }
    
    if (!urlComponents.host || urlComponents.host.length == 0) {
        DBRouterLog(@"没有host, 非法路径");
        return NO;
    }
    
    if (urlComponents.path.length == 0) {
        DBRouterLog(@"没有一级、二级路径,非法路径");
        return NO;
    }
    
    return YES;
}


/**
 过滤URL请求参数
 
 @param url 当前URL
 @return 返回过滤掉参数的URL
 */
- (NSString *)p_filterUrlParamsAndScheme:(NSString *)url {
    if(!url || url.length == 0) {
        return nil;
    }
    
    // 过滤参数
    NSArray *array = [url componentsSeparatedByString:@"?"];
    NSString *targetURL = [array firstObject];
    
    // 过滤scheme码
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:targetURL];
    NSString *scheme = urlComponents.scheme;
    
    NSRange range = [targetURL rangeOfString:scheme];
    if (range.location == NSNotFound) {
        return targetURL;
    }
    
    NSInteger index = range.location + range.length + 3;    // 这里+3是把 :// 一起加上了
    if (targetURL.length > index) {
        targetURL = [targetURL substringFromIndex:index];
    }
    
    return targetURL;
}


- (BOOL)p_checkParamsWithModel:(DBRouterModel *)model {
    __block BOOL isValid = YES;
    
    // 如果model为空, 直接返回验证成功
    if(!model) {
        return isValid;
    }
    
    // 分解路由url规则
    NSString *url = model.url;
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
    NSArray *items = components.queryItems;
    
    [items enumerateObjectsUsingBlock:^(NSURLQueryItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = item.name;
        BOOL hasRequireParameter = [name hasPrefix:@"*"];
        // 如果是必填参数, 则需要校验参数是否为*或者为空
        if (hasRequireParameter) {
            NSString *tempName = [name stringByReplacingOccurrencesOfString:@"*" withString:@""];
            NSString *value = NSDictionary.dbObjectForKey(model.params, tempName);
            
            if (!value || value.length == 0 || [value isEqualToString:@"*"]) {
                DBRouterLog(@"[%@]未必填参数, 不能为空或*", value);
                isValid = NO;
                *stop = YES;
            }
        }
    }];
    
    return isValid;
}


/**
 内部进行路由跳转
 
 @param model 路由实体类
 */
- (void)p_router:(DBRouterModel *)model complete:(void (^)(BOOL))block {
    
    if ([model.targetURLComponents.path isEqualToString:@"/tab"]) {
        NSUInteger index = 0;
        if (model.params) {
            NSString *indexNum = NSDictionary.dbObjectForKey(model.params, @"index");
            if (indexNum) {
                index = [indexNum integerValue];
            }
        }
        [self bwt_switchTab:index];
        return;
    }
    
    // 1. 得到vc类
    UIViewController *vc = [self bwt_pageWithModule:model];
    
    // 1.1 跳转原生浏览器
    if (!vc) {
        if ([model.url hasPrefix:@"http"]) {
            [self toBroswer:model.url];
        } else {
            DBRouterLog(@"当前vc为空, 是否未集成当前vc所在的模块?")
        }
        return;
    }
    
    // 2. 进行跳转
    [self bwt_jumpPage:model.jumpType viewController:vc complete:block];
}

/**
 跳转至safari
 
 @param urlStr url地址
 */
- (void)toBroswer:(NSString *)urlStr {
    // FIXME:待开发
//    [BWTTools openUrlInThirdParty:urlStr];
}


/**
 跳转到指定页面
 
 @param type 跳转类型
 @param vc ViewController
 */
- (void)bwt_jumpPage:(DBRouterJumpType)type
      viewController:(UIViewController *)vc
            complete:(void (^)(BOOL))block {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // FIXME:待修改
//        UIViewController *lastViewController = [UIViewController lastViewController];
        UIViewController *lastViewController = nil;
        // 模态
        if (type == DBRouterPresent) {
            Class class = NSClassFromString(@"BWTRootNavigationController");
            if (!class) {
                DBRouterLog(@"初始化BWTRootNavigationController失败");
                return;
            }
            
            UINavigationController *nav = [[class alloc] initWithRootViewController:vc];
            [lastViewController presentViewController:nav animated:YES completion:^{
                if (block) {
                    block(YES);
                }
            }];
            return;
        } else if (type == DBRouterPush) { // 普通push
            UINavigationController *nv = lastViewController.navigationController;
            if (!nv) {
                DBRouterLog(@"push到%@页时,调用页面必须要有导航栏", vc);
                return;
            }
            
            id nvc = nv.navigationController;
            [nv pushViewController:vc animated:YES];
            return;
        } else { // 自定义动画push
            UINavigationController *nv = lastViewController.navigationController;
            if (!nv) {
                DBRouterLog(@"push到%@页时,调用页面必须要有导航栏", vc);
                return;
            }
            id nvc = nv.navigationController;
            // FIXME:待修改
//            UIImageView *lastView = [[UIImageView alloc] initWithImage:[self p_snapshotSingleView:nv.view]];
//            NSString *animationType = [self.animationArr objectOrNilAtIndex:type];
//            [nvc pushViewController:vc animated:NO complete:^(BOOL finished) {
//                UIViewController *targetVC = [UIViewController lastViewController];
//                [targetVC.navigationController.view addSubview:lastView];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [BWTAnimationTools transitionWithType:animationType subtype:kCATransitionFromRight duration:0.3 forView:targetVC.navigationController.view];
//                    [lastView removeFromSuperview];
//                });
//            }];
            return;
        }
    });
    
}

/**
 获取页面控制器
 
 @param model 路由实体类
 @return 页面控制器
 */
- (UIViewController *)bwt_pageWithModule:(DBRouterModel *)model {
    
    UIViewController *vc = nil;
    
    // 1. 为空处理
    if (NSString.dbIsEmpty(model.url)) {
        DBRouterLog(@"路由实体类或者URL为空");
        return self.notFoundViewController;
    }
    
    // 2. 判断原生类是否已集成
    NSString *className = model.className;
    Class class = NSClassFromString(className);
    if (!class) {
        DBRouterLog(@"找不到[%@]需要跳转的原生类, 请检查是否有集成对应的模块", className);
        return nil;
    }
    
    // 3.根据请求参数判断是否有url进行不同页面处理
    NSString *url = NSDictionary.dbObjectForKey(model.params, @"url");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:model.params];
    if (url) {
        NSString *targetURL = [DBRouterTool URLDecodedString:url];
        NSMutableDictionary.dbSetObjectForKey(params, @"url", targetURL);
    }
    
    vc = [[class alloc] init];
    
    SEL sel = NSSelectorFromString(@"setParameter:");
    BOOL isConforms = [vc respondsToSelector:sel];
    
    if (params.count && isConforms) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        DBRouter_TRY_BODY([vc performSelector:sel withObject:params];)
#pragma clang diagnostic pop
    }
    
    //
    //    Protocol *protocol = NSProtocolFromString(@"BWTRACBaseViewProtocol");
    //    BOOL isConforms = [vc conformsToProtocol:protocol];
    //    if(isConforms && params.count) {
    //        SEL sel = NSSelectorFromString(@"setParameter:");
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    //        BWT_TRY_BODY([vc performSelector:sel withObject:params];)
    //#pragma clang diagnostic pop
    //    }
    
    return vc;
}



/**
 切换tab
 
 @param index 切换到第几个tab
 */
- (void)bwt_switchTab:(NSUInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        // FIXME:待开发
//        UIViewController *lastViewController = [UIViewController lastViewController];
        UIViewController *lastViewController = nil;
        UITabBarController *tabBar = lastViewController.tabBarController;
        
        if (index >= tabBar.childViewControllers.count) {
            return;
        }
        // FIXME:待开发
//        [lastViewController.navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
//            lastViewController.tabBarController.selectedIndex = index;
//        }];
    });
}

/**
 根据url path 获取一级目录, 也就是模块名
 
 @param path url path
 @return 模块名
 */
- (NSString *)p_moduleNameWithURLPath:(NSString *)path {
    
    NSString *moduleName = nil;
    if (NSString.dbIsEmpty(path)) {
        DBRouterLog(@"url路径为空");
        return moduleName;
    }
    
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if(pathArray.count > 1) {
        // FIXME:待开发
//        moduleName = [pathArray objectOrNilAtIndex:1];
    }
    
    return moduleName;
}


#pragma park - 懒加载方法


@end
