//
//  DBRouterBaseModel.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/21.
//

#import "DBRouterBaseModel.h"
#import <objc/runtime.h>

@interface DBRouterBaseModel ()

+ (NSArray *(^)(Class))getProperties;
+ (NSString *(^)(NSString *))underlineFromCamele;

@end

@implementation DBRouterBaseModel

#pragma mark - 公共方法

+ (id  _Nonnull (^)(NSDictionary * _Nonnull))dbObjectWithKeyValues {
    kDBWeakSelf
    id (^block)(NSDictionary *) = ^(NSDictionary *dic) {
        id model = [weakSelf new];
        if (NSDictionary.dbIsEmpty(dic)) {
            return model;
        }
        //获取所有属性 ，遍历 给属性赋值
        NSArray *names = DBRouterBaseModel.getProperties([weakSelf class]);
        for (NSString *cameleName in names) {
            NSString *underLineName = DBRouterBaseModel.underlineFromCamele(cameleName);
            // 如果字典中的值为空，赋值可能会出问题
            NSString *value = NSDictionary.dbObjectForKey(dic, underLineName);
            if ([value isKindOfClass:[NSNull class]] || [value isEqual:[NSNull null]] || [value isEqual:@"(null)"] || [value isEqual:@"<null>"]) {
                value = nil;
            }
            if (value) {
                [model setValue:value forKey:cameleName];
            }
        }
        return model;
    };
    return block;
}

+ (NSDictionary * _Nonnull (^)(id _Nonnull))dbChangeModelToDic {
    NSDictionary *(^block)(id) = ^(id model) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSArray *namesArray = DBRouterBaseModel.getProperties([self class]);
        for (NSString *name in namesArray) {
            NSString *key = DBRouterBaseModel.underlineFromCamele(name);
            NSString *value = [model valueForKey:key];
            NSMutableDictionary.dbSetValueForKey(mDic, key, value);
        }
        return mDic;
    };
    return block;
}

+ (NSArray * _Nonnull (^)(NSArray * _Nonnull))dbModelArrayWithKeyValuesArray {
    kDBWeakSelf
    NSArray * (^block)(NSArray *) = ^(NSArray *array) {
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        if (NSArray.dbIsEmpty(array)) {
            return modelArray;
        }
        for (NSDictionary *dic in array) {
            id model = [weakSelf dbObjectWithKeyValues](dic);
            if (!model) {
                continue;
            }
            NSMutableArray.dbAddObject(modelArray, model);
        }
        return modelArray;
    };
    return block;
}

#pragma mark - 私有方法

/**
 获取当前类的所有属性
 */
+ (NSArray *(^)(Class))getProperties {
    NSArray *(^block)(Class) = ^(Class class) {
        // 记录属性个数
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        // 遍历
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            // objc_property_t 属性类型
            objc_property_t property = properties[i];
            // 获取属性的名称 C语言字符串
            const char *cName = property_getName(property);
            // 转换为Objective C 字符串
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            [mArray addObject:name];
        }
        return mArray.copy;
    };
    return block;
}

/**
 驼峰转下划线
 */
+ (NSString *(^)(NSString *))underlineFromCamele {
    NSString *(^block)(NSString *) = ^(NSString *name) {
        if (NSString.dbIsEmpty(name)) {
            return name;
        }
        NSMutableString *string = [NSMutableString string];
        for (NSUInteger i = 0; i < name.length; i++) {
            unichar c = [name characterAtIndex:i];
            NSString *cString = [NSString stringWithFormat:@"%c", c];
            NSString *cStringLower = [cString lowercaseString];
            if ([cString isEqualToString:cStringLower]) {
                [string appendString:cStringLower];
            } else {
                [string appendString:@"_"];
                [string appendString:cStringLower];
            }
        }
        return [NSString stringWithFormat:@"%@", string];
    };
    return block;
}

@end
