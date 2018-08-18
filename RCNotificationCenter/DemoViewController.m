//
//  DemoViewController.m
//  RCNotificationCenter
//
//  Created by 孙承秀 on 2018/8/18.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "DemoViewController.h"
#import "RCNotificationCenter.h"
@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
   
        
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qwe) name:@"oo" object:nil];
}
- (void)qwe{
    NSLog(@"来了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [RCNotificationCenter postNotificationName:@"change" objectInfo:@{@"name":@"sunchegnxiu"} complement:^(id value) {
        NSLog(@"%@",value);
    }];
//    NSString *value = [RCNotificationCenter postNotificationName:@"change" objectInfo:@{@"name":@"sunchegnxiu"}];
//    NSLog(@"%@",value);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
