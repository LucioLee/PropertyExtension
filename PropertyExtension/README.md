一句话实现属性扩展
```
@interface TestModel : NSObject
@end

@interface TestModel (BaseProperty)

@property (nonatomic, assign) CGPoint aPoint;
@property (nonatomic, assign) CGRect aRect;

@property (nonatomic, assign) float aFloat;
@property (nonatomic, assign) int aInt;

@end

@interface TestModel (ObjectProperty)

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *aURL;
@property (nonatomic, strong)NSDate *aDate;

@end


@implementation TestModel

+ (void)initialize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self invokeAllClassMethodWithSelector:@selector(categoryInitialize)];
#pragma clang diagnostic pop
}

@end
```

```
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
```
