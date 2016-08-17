//
//  NSObject+PropertyExtension.m
//  PropertyExtension
//
//  Created by 李新新 on 16/8/17.
//  Copyright © 2016年 LucioLee. All rights reserved.
//

#import "NSObject+PropertyExtension.h"
#import <UIKit/UIKit.h>

NSString *LucioLeeAddPropertyException = @"LucioLeeAddPropertyException";

@implementation NSObject (PropertyExtension)

static inline void __invoke_all_method(id self, SEL selecotr) {
    //1. 根据self，获取class
    Class class = object_getClass(self);
    
    //2. 获取方法列表
    uint count;
    Method *methodList = class_copyMethodList(class, &count);
    
    //3. 遍历方法列表
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        //4. 根据SEL查找方法
        if (!sel_isEqual(selecotr, method_getName(method))) {
            continue;
        }
        
        //5. 获取方法的实现
        IMP implement = method_getImplementation(method);
        
        //6. 直接调用方法的实现
        ((void(*)(id,SEL))implement)(self, selecotr);
    }
}

- (void)invokeAllInstanceMethodWithSelector:(SEL)selector {
    __invoke_all_method(self, selector);
}

+ (void)invokeAllClassMethodWithSelector:(SEL)selector {
    __invoke_all_method(self, selector);
}

static inline NSString *__setter_selector_name_of_property(NSString *property) {
    NSString *headCharacter = [[property substringToIndex:1] uppercaseString];
    NSString *OtherString = [property substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@:",headCharacter,OtherString];
}

+ (void)addObjectProperty:(NSString *)name {
    [self addObjectProperty:name encodingType:@encode(id) associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

+ (void)addObjectProperty:(NSString *)name encodingType:(char *)type {
    [self addObjectProperty:name encodingType:type associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

+ (void)addObjectProperty:(NSString *)name encodingType:(char *)type associationPolicy:(objc_AssociationPolicy)policy {
    if (!name.length) {
        [[NSException exceptionWithName:LucioLeeAddPropertyException
                                 reason:@"property must not be empty in +addObjectProperty:associationPolicy:"
                               userInfo:@{@"name":name,@"policy":@(policy)}]
         raise];
    }
    
    //1. 通过class的指针和property的name，创建一个唯一的key
    NSString *key = [NSString stringWithFormat:@"%p_%@",self,name];
    
    //2. 用block实现setter方法
    id setblock = ^(id self,id value){
        objc_setAssociatedObject(self, (__bridge void *)key, value, policy);
    };
    
    //3. 将block的实现转化为IMP
    IMP imp = imp_implementationWithBlock(setblock);
    
    //4. 用name拼接出setter方法
    NSString *selString = __setter_selector_name_of_property(name);
    
    //5. 将setter方法加入到class中
    NSString *setType = [NSString stringWithFormat:@"v@:%@",@(type)];
    BOOL result = class_addMethod([self class], NSSelectorFromString(selString), imp, [setType UTF8String]);
    assert(result);
    
    //6. getter
    id getBlock = ^id(id self){
        return objc_getAssociatedObject(self, (__bridge void*)key);
    };
    IMP getImp = imp_implementationWithBlock(getBlock);
    NSString *getType = [NSString stringWithFormat:@"%@@:",@(type)];
    result = class_addMethod([self class], NSSelectorFromString(name), getImp, [getType UTF8String]);
    assert(result);
}

+ (void)addObjectProperty:(NSString *)name associationPolicy:(objc_AssociationPolicy)policy {
    [self addObjectProperty:name encodingType:@encode(id) associationPolicy:policy];
}


+ (void)addBasicProperty:(NSString *)name encodingType:(char *)type {
    if (!name.length) {
        [[NSException exceptionWithName:LucioLeeAddPropertyException
                                 reason:@"property must not be empty in +addBasicProperty:encodingType:"
                               userInfo:@{@"name":name,@"type":@(type)}]
         raise];
    }
    
    if (strcmp(type, @encode(id)) == 0) {
        [self addObjectProperty:name];
    }
    NSString *key = [NSString stringWithFormat:@"%p_%@",self,name];
    id setblock;
    id getBlock;
#define blockWithCaseType(C_TYPE)                               \
    if (strcmp(type, @encode(C_TYPE)) == 0) {                   \
        setblock = ^(id self,C_TYPE var) {                       \
            NSValue *value = [NSValue value:&var withObjCType:type];\
            objc_setAssociatedObject(self, (__bridge void *)key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);  \
        };                                                          \
        getBlock = ^C_TYPE (id self){                               \
            NSValue *value = objc_getAssociatedObject(self, (__bridge void*)key);   \
            C_TYPE var;                                             \
            [value getValue:&var];                                  \
            return var;                                             \
        };                                                          \
    }
    blockWithCaseType(char);
    blockWithCaseType(unsigned char);
    blockWithCaseType(short);
    blockWithCaseType(int);
    blockWithCaseType(unsigned int);
    blockWithCaseType(long);
    blockWithCaseType(unsigned long);
    blockWithCaseType(long long);
    blockWithCaseType(float);
    blockWithCaseType(double);
    blockWithCaseType(BOOL);
    
    blockWithCaseType(CGPoint);
    blockWithCaseType(CGSize);
    blockWithCaseType(CGVector);
    blockWithCaseType(CGRect);
    blockWithCaseType(NSRange);
    blockWithCaseType(CFRange);
    blockWithCaseType(CGAffineTransform);
    blockWithCaseType(CATransform3D);
    blockWithCaseType(UIOffset);
    blockWithCaseType(UIEdgeInsets);
    
    if (!setblock || !getBlock) {
        [[NSException exceptionWithName:LucioLeeAddPropertyException
                                 reason:@"type is an unknown type in +addBasicProperty:encodingType:"
                               userInfo:@{@"name":name,@"type":@(type)}]
         raise];
    }
    
    IMP setImp = imp_implementationWithBlock(setblock);
    NSString *selString = __setter_selector_name_of_property(name);
    NSString *setType = [NSString stringWithFormat:@"v@:%@",@(type)];
    BOOL result = class_addMethod([self class], NSSelectorFromString(selString), setImp, [setType UTF8String]);
    assert(result);
    
    IMP getImp = imp_implementationWithBlock(getBlock);
    NSString *getType = [NSString stringWithFormat:@"%@@:",@(type)];
    result = class_addMethod([self class], NSSelectorFromString(name), getImp, [getType UTF8String]);
    assert(result);
}


@end
