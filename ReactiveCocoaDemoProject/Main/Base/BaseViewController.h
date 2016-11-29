//
//  BaseViewController.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/29.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface BaseViewController : UIViewController

- (void)loadDataWithSignal:(RACSignal *)signal withSuccess:(void (^)())success fail:(void (^)())fail complete:(void (^)())complete;

@end
