//
//  NSObject+PropertyExtension.h
//  PropertyExtension
//
//  Created by 李新新 on 16/8/17.
//  Copyright © 2016年 LucioLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString *LucioLeeAddPropertyException;

@interface NSObject (PropertyExtension)

/**
 *  通过selector调用所有实例的方法，包括被category覆盖的方法
 *  @param selector 要调用方法的selector
 */
- (void)invokeAllInstanceMethodWithSelector:(SEL)selector;

/**
 *  通过selector调用所有类的方法，包括被category覆盖的方法
 *  @param selector 方法的selector
 */
+ (void)invokeAllClassMethodWithSelector:(SEL)selector;

/**
 *  为类添加id类型的属性，objc_AssociationPolicy类型为OBJC_ASSOCIATION_RETAIN_NONATOMIC
 *  @param name 属性的name
 */
+ (void)addObjectProperty:(NSString *)name;

/**
 *  为类添加给定类型的属性，objc_AssociationPolicy类型为OBJC_ASSOCIATION_RETAIN_NONATOMIC
 *  @param name 属性的name
 *  @param type 属性的encodingType，如NSString类型的属性，type为@encode(NSString)
 */
+ (void)addObjectProperty:(NSString *)name encodingType:(char *)type;

/**
 *  为类添加给定类型的属性
 *  @param name   属性的name
 *  @param type 属性的encodingType，如NSString类型的属性，type为@encode(NSString)
 *  @param policy 属性的policy
 */
+ (void)addObjectProperty:(NSString *)name encodingType:(char *)type associationPolicy:(objc_AssociationPolicy)policy;
/**
 *  为类添加id类型的属性
 *  @param name   属性的name
 *  @param policy 属性的policy
 */
+ (void)addObjectProperty:(NSString *)name associationPolicy:(objc_AssociationPolicy)policy;

/**
 *  为类添加基础类型的属性，如：int,float,CGPoint,CGRect等
 *  @param name 属性的name
 *  @param type 属性的encodingType，如int类型的属性，type为@encode(int)
 */
+ (void)addBasicProperty:(NSString *)name encodingType:(char *)type;

@end
