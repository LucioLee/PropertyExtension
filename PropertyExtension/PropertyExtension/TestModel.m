//
//  TestModel.m
//  PropertyExtension
//
//  Created by 李新新 on 16/8/17.
//  Copyright © 2016年 LucioLee. All rights reserved.
//

#import "TestModel.h"
#import "NSObject+PropertyExtension.h"

@implementation TestModel

+ (void)initialize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self invokeAllClassMethodWithSelector:@selector(categoryInitialize)];
#pragma clang diagnostic pop
}

@end

@implementation TestModel (BaseProperty)

@dynamic aPoint;
@dynamic aRect;
@dynamic aFloat;
@dynamic aInt;

+ (void)categoryInitialize {
    
    [self addBasicProperty:@"aPoint" encodingType:@encode(CGPoint)];
    [self addBasicProperty:@"aRect" encodingType:@encode(CGRect)];
    [self addBasicProperty:@"aFloat" encodingType:@encode(float)];
    [self addBasicProperty:@"aInt" encodingType:@encode(int)];
}

@end

@implementation TestModel (ObjectProperty)

@dynamic aURL;
@dynamic name;
@dynamic aDate;

+ (void)categoryInitialize {
    
    [self addObjectProperty:@"aURL"];
    [self addObjectProperty:@"aDate" encodingType:@encode(NSDate)];
    [self addObjectProperty:@"name" encodingType:@encode(NSString) associationPolicy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

@end