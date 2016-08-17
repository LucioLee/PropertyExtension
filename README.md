一句话实现属性扩展

感谢[lianchengjiang](https://github.com/lianchengjiang)的[LcCategoryProperty](https://github.com/lianchengjiang/LcCategoryProperty),自己写了一遍，加深一下印象并做了一些修改。
##interface code
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
@property (nonatomic, strong) NSDate *aDate;

@end

```
##implementation code
```
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
```
##test code
```
TestModel *model = [[TestModel alloc] init];
model.aPoint = CGPointMake(0, 10);
model.aRect = CGRectMake(0, 0, 100, 100);
model.aFloat = 10.2f;
model.aInt = 100;
model.name = @"LucioLee";
model.aURL = [NSURL URLWithString:@"https://www.baidu.com"];
model.aDate = [NSDate date];
NSLog(@"model description :{\napoint: %@,\naRect: %@,\naFloat:%f,\naInt: %d\nname: %@,\naurl:%@\n,aDate: %@\n}",NSStringFromCGPoint(model.aPoint),NSStringFromCGRect(model.aRect),model.aFloat,model.aInt,model.name,model.aURL.absoluteString,model.aDate);
```
