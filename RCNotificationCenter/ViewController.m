//
//  ViewController.m
//  RCNotificationCenter
//
//  Created by 孙承秀 on 2018/8/18.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "ViewController.h"
#import "RCNotificationCenter.h"
#import "DemoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    [RCNotificationCenter addObserver:self name:@"change" complement:^id(id observer, NSDictionary *objectInfo) {
//        NSLog(@"%@",objectInfo);
//        return @"haha";
//    }];
   
    [RCNotificationCenter addObserver:self name:@"change" complement:^id(id observer, NSDictionary *objectInfo) {
        NSLog(@"%@",objectInfo);
        return @"haha";
    }];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oo" object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DemoViewController *demo = [DemoViewController new];
    [self.navigationController pushViewController:demo animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
