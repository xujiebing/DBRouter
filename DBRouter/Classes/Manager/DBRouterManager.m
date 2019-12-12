//
//  DBRouterManager.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/12.
//

#import "DBRouterManager.h"

@interface DBRouterManager ()

- (DBRouterModel *(^)(NSString *url, NSDictionary *param))modelWithURL;
- (BOOL (^)(DBRouterModel *))checkParams;
- (BOOL (^)(DBRouterModel *_Nullable))router;
- (UIViewController *(^)(DBRouterModel *))pageWithModel;
- (BOOL (^)(DBRouterJumpType, UIViewController *))jumpPageWithViewController;

@property (nonatomic, copy, readwrite) NSString *routerClassFilePath;
@property (nonatomic, copy, readwrite) NSString *routerWhiteFilePath;
@property (nonatomic, strong, readwrite) NSDictionary *routerClassDic;
@property (nonatomic, strong, readwrite) NSArray *routerWhiteArray;

@end

@implementation DBRouterManager

#pragma mark - 外部方法

static DBRouterManager *routerManager = nil;
+ (DBRouterManager *)routerManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerManager = [[super allocWithZone:NULL] init];
    });
    return routerManager;
}

- (void (^)(NSString * _Nullable, NSString * _Nullable))setRouterFilePath {
    kDBWeakSelf
    void (^block)(NSString *, NSString *) = ^(NSString *routerClassFilePath, NSString *routerWhiteFilePath) {
        if (!NSString.dbIsEmpty(routerClassFilePath)) {
            weakSelf.routerClassFilePath = routerClassFilePath;
        }
        if (NSString.dbIsEmpty(routerWhiteFilePath)) {
            weakSelf.routerWhiteFilePath = routerWhiteFilePath;
        }
    };
    return block;
}

- (void (^)(NSString * _Nullable, NSString * _Nullable))reloadRouterFilePath {
    kDBWeakSelf
    void (^block)(NSString *, NSString *) = ^(NSString *routerClassFilePath, NSString *routerWhiteFilePath) {
        if (!NSString.dbIsEmpty(routerClassFilePath)) {
            self->_routerClassDic = nil;
            weakSelf.routerClassFilePath = routerClassFilePath;
        }
        if (NSString.dbIsEmpty(routerWhiteFilePath)) {
            self->_routerWhiteArray = nil;
            weakSelf.routerWhiteFilePath = routerWhiteFilePath;
        }
    };
    return block;
}

- (BOOL (^)(NSString * _Nonnull))routerWithUrl {
    kDBWeakSelf
    BOOL (^block)(NSString *) = ^(NSString *url) {
        return weakSelf.routerWithUrlAndParams(url, nil);
    };
    return block;
}

- (BOOL (^)(NSString * _Nonnull, NSDictionary * _Nullable))routerWithUrlAndParams {
    kDBWeakSelf
    BOOL (^block)(NSString *, NSDictionary *) = ^(NSString *url, NSDictionary *params) {
        // 跳转safari
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            return DBRouterTool.openUrlInSafari(url);;
        }
        // 根据url转成routerModel
        DBRouterModel *routerModel = weakSelf.modelWithURL(url, params);
        if (!routerModel) {
            DBRouterPopTool.alert(@"路由异常，请检查路由");
            return NO;
        }
        // 校验参数是否合法
        BOOL isValid = weakSelf.checkParams(routerModel);
        if (!isValid) {
            DBRouterPopTool.alert(@"参数校验不合法");
            return NO;
        }
        // 进行路由操作
        return weakSelf.router(routerModel);
    };
    return block;
}

- (BOOL (^)(NSURL * _Nonnull))routerUrl {
    kDBWeakSelf
    BOOL (^block)(NSURL *) = ^(NSURL *url){
        BOOL complete = NO;
        if (!url) {
            return complete;
        }
        NSString *stringUrl = url.absoluteString;
        __block BOOL isValid = NO;
        NSString *targetUrl = DBRouterTool.filterUrlParams(stringUrl);
        [weakSelf.routerWhiteArray enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *tempUrl = DBRouterTool.filterUrlParams(item);
            if ([targetUrl isEqualToString:tempUrl]) {
                isValid = YES;
                *stop = YES;
            }
        }];
        if (!isValid) {
            return complete;
        }
        complete = weakSelf.routerWithUrl(stringUrl);
        return complete;
    };
    return block;
}

- (void)popRouter {
    UIViewController *lastVC = UIViewController.lastViewController;
    if(lastVC.presentingViewController && lastVC.navigationController.viewControllers.count == 1) {
        [lastVC dismissViewControllerAnimated:YES completion:nil];
    } else {
        [lastVC.navigationController popViewControllerAnimated:YES];
    }
}

- (void (^)(NSInteger))popRouterWithIndex {
    kDBWeakSelf
    void (^block)(NSInteger) = ^(NSInteger index){
        if (index <=0) {
            return;
        }
        UIViewController *lastVC = UIViewController.lastViewController;
        NSArray *vcArray = lastVC.navigationController.viewControllers;
        if (vcArray.count <= 1) {
            if(!lastVC.presentingViewController) {
                return;
            }
            [lastVC dismissViewControllerAnimated:YES completion:nil];
        }
        if (index+1 >= vcArray.count) {
            if(lastVC.presentingViewController) {
                [lastVC dismissViewControllerAnimated:YES completion:^{
                    weakSelf.popRouterWithIndex(index - vcArray.count);
                }];
                return;
            }
            [lastVC.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        index = vcArray.count - index - 1;
        id targetVC = NSArray.dbObjectAtIndex(vcArray, index);
        if (!targetVC) {
            return;
        }
        if (![targetVC isKindOfClass:[UIViewController class]]) {
            return;
        }
        [lastVC.navigationController popToViewController:targetVC animated:YES];
    };
    return block;
}

- (void (^)(NSString * _Nonnull, BOOL))popRouterWithUrlAndAnimated {
    kDBWeakSelf
    void (^block)(NSString *, BOOL) = ^(NSString *url, BOOL animated){
        if (NSString.dbIsEmpty(url)) {
            DBRouterLog(@"指定url为空，无法返回")
            DBRouterPopTool.alert(@"路由为空，无法返回");
            return ;
        }
        DBRouterModel *model = weakSelf.modelWithURL(url, nil);
        UIViewController *targerVC = weakSelf.pageWithModel(model);
        UIViewController *lastVC = UIViewController.lastViewController;
        NSArray *vcArray = lastVC.navigationController.viewControllers;
        for (UIViewController *itemVC in vcArray) {
            NSString *targetVCName = DBRouterTool.className(targerVC);
            NSString *itemVCName = DBRouterTool.className(itemVC);
            if (![itemVCName isEqualToString:targetVCName]) {
                continue;
            }
            [lastVC.navigationController popToViewController:itemVC animated:animated];
        }
    };
    return block;
}

- (UIViewController * _Nonnull (^)(NSString * _Nonnull))viewControllerWithUrl {
    kDBWeakSelf
    UIViewController * (^block)(NSString *) = ^(NSString *url){
        UIViewController *vc = nil;
        if (NSString.dbIsEmpty(url)) {
            return vc;
        }
        DBRouterModel *model = weakSelf.modelWithURL(url, nil);
        vc = weakSelf.pageWithModel(model);
        return vc;
    };
    return block;
}

#pragma mark - 私有方法

/**
 根据url获取router model
 */
- (DBRouterModel *(^)(NSString *url, NSDictionary *params))modelWithURL {
    kDBWeakSelf
    DBRouterModel *(^block)(NSString *, NSDictionary *) = ^(NSString *url, NSDictionary *params){
        __block DBRouterModel *model = nil;
        if (NSString.dbIsEmpty(url)) {
            DBRouterLog(@"url为空...");
            return model;
        }
        NSArray *urlArray = [url componentsSeparatedByString:@"://"];
        if (NSArray.dbIsEmpty(urlArray)) {
            DBRouterLog(@"url非法");
            return model;
        }
        NSString *urlScheme = NSArray.dbObjectAtIndex(urlArray,0);
        NSString *lowercaseUrlScheme = urlScheme.lowercaseString;
        urlScheme = [urlScheme stringByAppendingString:@"://"];
        lowercaseUrlScheme = [lowercaseUrlScheme stringByAppendingString:@"://"];
        url = [url stringByReplacingOccurrencesOfString:urlScheme withString:lowercaseUrlScheme];
        // 解析获取模块名，根据模块名获取对应的路由组，然后根据url获取到对应的class
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *host = components.host;
        if (NSString.dbIsEmpty(host)) {
            DBRouterLog(@"【%@】host为空",url)
            return model;
        }
        NSString *path = components.path;
        if (NSString.dbIsEmpty(path)) {
            DBRouterLog(@"【%@】path为空",url)
            return model;
        }
        NSArray *pathArray = [path componentsSeparatedByString:@"/"];
        NSString *moduleName = NSArray.dbObjectAtIndex(pathArray, 1);
        if(NSString.dbIsEmpty(moduleName)) {
            DBRouterLog(@"【%@】模块名为空", url);
            return model;
        }
        if (!weakSelf.routerClassDic) {
            DBRouterLog(@"路由配置文件为空, 请检查路由");
            return model;
        }
        NSArray *array = NSDictionary.dbObjectForKey(weakSelf.routerClassDic, moduleName);
        if (NSArray.dbIsEmpty(array)) {
            DBRouterLog(@"获取【%@】下的对应路由配置信息为空", moduleName);
            return model;
        }
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
            DBRouterModel *tempModel = DBRouterModel.dbObjectWithKeyValues(item);
            // 过滤请求参数
            NSString *modelURL = DBRouterTool.filterUrlParams(tempModel.url);
            NSString *targetUrl = DBRouterTool.filterUrlParams(url);
            if([modelURL isEqualToString:targetUrl]) {
                tempModel.addParameters(url, params);
                model = tempModel;
                *stop = YES;
            }
        }];
        return model;
    };
    return block;
}

- (BOOL (^)(DBRouterModel *))checkParams {
    __block BOOL isValid = YES;
    BOOL (^block)(DBRouterModel *) = ^(DBRouterModel *model) {
        if (!model) {
            isValid = NO;
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
                if (NSString.dbIsEmpty(value)) {
                    DBRouterLog(@"【%@】为必填参数, 不能为空", tempName);
                    isValid = NO;
                    *stop = YES;
                }
                if ([value isEqualToString:@"*"]) {
                    DBRouterLog(@"【%@】为必填参数, 不能为*", tempName);
                    isValid = NO;
                    *stop = YES;
                }
            }
        }];
        return isValid;
    };
    return block;
}

/**
 获取页面控制器
 */
- (UIViewController *(^)(DBRouterModel *))pageWithModel {
    UIViewController *(^block)(DBRouterModel *) = ^(DBRouterModel *model) {
        UIViewController *vc = nil;
        if (!model) {
            return vc;
        }
        if (NSString.dbIsEmpty(model.url)) {
            DBRouterLog(@"路由实体类或者URL为空");
            return vc;
        }
        NSString *className = model.iclass;
        Class class = NSClassFromString(className);
        if (!class) {
            DBRouterLog(@"找不到【%@】需要跳转的原生类, 请检查是否有集成对应的模块", className);
            return vc;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:model.params];
        if (!NSDictionary.dbIsEmpty(model.params)) {
            NSString *url = NSDictionary.dbObjectForKey(model.params, @"url");
            if (!NSString.dbIsEmpty(url)) {
                NSString *targetURL = NSString.dbUrlDecodeString(url);
                NSMutableDictionary.dbSetObjectForKey(params, @"url", targetURL);
            }
        }
        vc = [[class alloc] init];
        
        SEL selector = NSSelectorFromString(@"dbSetParameter:");
        if (!NSDictionary.dbIsEmpty(params) && [vc respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [vc performSelector:selector withObject:params];
#pragma clang diagnostic pop
        }
        return vc;
    };
    return block;
}

/**
 进行路由跳转
 */
- (BOOL (^)(DBRouterModel *_Nullable))router {
    kDBWeakSelf
    BOOL (^block)(DBRouterModel *) = ^(DBRouterModel *model) {
        BOOL complete = NO;
        // tab切换
        if ([model.urlComponents.path isEqualToString:@"/tab"]) {
            NSUInteger index = 0;
            NSString *indexNum = NSDictionary.dbObjectForKey(model.params, @"index");
            if (indexNum) {
                index = [indexNum integerValue];
            }
            complete = DBRouterTool.switchTabbarIndex(index);
            return complete;
        }
        // 页面跳转
        UIViewController *vc = weakSelf.pageWithModel(model);
        if (!vc) {
            DBRouterLog(@"当前vc为空, 是否未集成当前vc所在的模块?")
            DBRouterPopTool.alert(@"无法获取到目标页面");
            return complete;
        }
        complete = weakSelf.jumpPageWithViewController(model.jumpType, vc);
        return complete;
    };
    return block;
}

/**
 跳转到指定页面
 */
- (BOOL (^)(DBRouterJumpType, UIViewController *))jumpPageWithViewController {
    BOOL (^block)(DBRouterJumpType, UIViewController *) = ^(DBRouterJumpType type, UIViewController *vc) {
        __block BOOL complete = NO;
        UIViewController *lastViewController = UIViewController.lastViewController;
        if (type == DBRouterPresent) {
            // 模态
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [lastViewController presentViewController:nav animated:YES completion:nil];
            complete = YES;
            return complete;
        } else {
            // push
            UINavigationController *nv = lastViewController.navigationController;
            if (!nv) {
                DBRouterLog(@"push到%@页时,调用页面必须要有导航栏", vc);
                return complete;
            }
            [nv pushViewController:vc animated:YES];
            complete = YES;
            return complete;
        }
    };
    return block;
}

#pragma park - 懒加载方法

- (NSDictionary *)routerClassDic {
    if (!_routerClassDic) {
        if (NSString.dbIsEmpty(self.routerClassFilePath)) {
            self.routerClassFilePath = DBRouterTool.fullPathWithFileName(kDBRouterClassFileName);
        }
        _routerClassDic = DBRouterTool.loadJSONFileWithPath(self.routerClassFilePath);
        if(NSDictionary.dbIsEmpty(_routerClassDic)) {
            DBRouterLog(@"尚未配置【%@.json】文件, 或此文件格式不正确", kDBRouterClassFileName);
        }
    }
    return _routerClassDic;
}

- (NSArray *)routerWhiteArray {
    if (!_routerWhiteArray) {
        if (NSString.dbIsEmpty(self.routerWhiteFilePath)) {
            self.routerWhiteFilePath = DBRouterTool.fullPathWithFileName(kDBRouterWhiteFileName);
        }
        _routerWhiteArray = DBRouterTool.loadJSONFileWithPath(self.routerWhiteFilePath);
        if(NSArray.dbIsEmpty(_routerWhiteArray)) {
            DBRouterLog(@"尚未配置【%@.json】文件, 或此文件格式不正确", kDBRouterWhiteFileName);
            return _routerWhiteArray;
        }
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        [_routerWhiteArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NSString.dbIsEmpty(obj)) {
                return ;
            }
            NSArray *objArray = [obj componentsSeparatedByString:@"://"];
            if (NSArray.dbIsEmpty(objArray)) {
                return ;
            }
            NSString *objScheme = NSArray.dbObjectAtIndex(objArray,0);
            NSString *lowercaseObjScheme = objScheme.lowercaseString;
            objScheme = [objScheme stringByAppendingString:@"://"];
            lowercaseObjScheme = [lowercaseObjScheme stringByAppendingString:@"://"];
            obj = [obj stringByReplacingOccurrencesOfString:objScheme withString:lowercaseObjScheme];
            NSMutableArray.dbAddObject(resultArray, obj);
        }];
        _routerWhiteArray = resultArray;
    }
    return _routerWhiteArray;
}

@end
