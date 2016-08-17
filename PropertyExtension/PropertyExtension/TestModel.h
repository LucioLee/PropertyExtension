//
//  TestModel.h
//  PropertyExtension
//
//  Created by 李新新 on 16/8/17.
//  Copyright © 2016年 LucioLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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