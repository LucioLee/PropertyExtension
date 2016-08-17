//
//  ViewController.m
//  PropertyExtension
//
//  Created by 李新新 on 16/8/17.
//  Copyright © 2016年 LucioLee. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestModel *model = [[TestModel alloc] init];
    model.aPoint = CGPointMake(0, 10);
    model.aRect = CGRectMake(0, 0, 100, 100);
    model.aFloat = 10.2f;
    model.aInt = 100;
    model.name = @"LucioLee";
    model.aURL = [NSURL URLWithString:@"https://www.baidu.com"];
    model.aDate = [NSDate date];
    NSLog(@"model description :{\napoint: %@,\naRect: %@,\naFloat:%f,\naInt: %d\nname: %@,\naurl:%@\n,aDate: %@\n}",NSStringFromCGPoint(model.aPoint),NSStringFromCGRect(model.aRect),model.aFloat,model.aInt,model.name,model.aURL.absoluteString,model.aDate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
