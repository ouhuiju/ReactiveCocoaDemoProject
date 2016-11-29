//
//  BaseViewController.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/29.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithSignal:(RACSignal *)signal withSuccess:(void (^)())success fail:(void (^)())fail complete:(void (^)())complete  {
//    @weakify(self);
    [signal subscribeNext:^(id x) {
//        @strongify(self);
        success();
    } error:^(NSError *error) {
        fail();
    } completed:^{
        complete();
    }];
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
