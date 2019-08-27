//
//  NSObject+DBRouterMethodSwizzling.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/27.
//

#import "NSObject+DBRouterMethodSwizzling.h"

@implementation NSObject (DBRouterMethodSwizzling)

+ (BOOL (^)(SEL _Nonnull, SEL _Nonnull))swizzleMethod {
    kDBWeakSelf
    BOOL (^block)(SEL, SEL) = ^(SEL origMethod, SEL withMethod){
        Method origMethodInstance = class_getInstanceMethod(weakSelf, origMethod);
        if (!origMethod) {
            DBRouterLog(@"original method %@ not found for class %@", NSStringFromSelector(origMethod), [self class]);
            return NO;
        }
        
        Method altMethodInstance = class_getInstanceMethod(self, withMethod);
        if (!withMethod) {
            DBRouterLog(@"original method %@ not found for class %@", NSStringFromSelector(withMethod), [self class]);
            return NO;
        }
        
        class_addMethod(weakSelf,
                        origMethod,
                        class_getMethodImplementation(weakSelf, origMethod),
                        method_getTypeEncoding(origMethodInstance));
        class_addMethod(weakSelf,
                        withMethod,
                        class_getMethodImplementation(weakSelf, withMethod),
                        method_getTypeEncoding(altMethodInstance));
        method_exchangeImplementations(class_getInstanceMethod(weakSelf, origMethod), class_getInstanceMethod(weakSelf, withMethod));
        return YES;
    };
    return block;
}

+ (BOOL (^)(SEL _Nonnull, SEL _Nonnull))swizzleClassMethod {
    kDBWeakSelf
    BOOL (^block)(SEL, SEL) = ^(SEL origClassMethod, SEL withClassMethod){
        Class c = object_getClass((id)weakSelf);
        return [c swizzleMethod](origClassMethod, withClassMethod);
    };
    return block;
}

+ (void (^)(SEL _Nonnull, NSString * _Nonnull, SEL _Nonnull))swizzleMethodWithClassName {
    kDBWeakSelf
    void (^block)(SEL, NSString *, SEL) = ^(SEL origMethod, NSString *withClassName, SEL withMethod){
        if (NSString.dbIsEmpty(withClassName)) {
            return ;
        }
        Class origClass = [weakSelf class];
        Class withClass = NSClassFromString(withClassName);
        [weakSelf swizzleMethodWithClass](origClass, origMethod, withClass, withMethod);
    };
    return block;
}

+ (void (^)(Class  _Nonnull __unsafe_unretained, SEL _Nonnull, Class  _Nonnull __unsafe_unretained, SEL _Nonnull))swizzleMethodWithClass {
    void (^block)(Class, SEL, Class, SEL) = ^(Class origClass, SEL origMethod, Class withClass, SEL withMethod){
        if (!origClass) {
            return;
        }
        if (!origMethod) {
            return;
        }
        if (!withClass) {
            return;
        }
        if (!withMethod) {
            return;
        }
        Method srcMethod = class_getInstanceMethod(origClass,origMethod);
        Method tarMethod = class_getInstanceMethod(withClass,withMethod);
        method_exchangeImplementations(srcMethod, tarMethod);
    };
    return block;
}


@end
