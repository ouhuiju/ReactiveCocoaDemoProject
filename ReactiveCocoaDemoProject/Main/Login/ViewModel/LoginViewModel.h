//
//  LoginViewModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/30.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <AFNetworking.h>

@interface LoginViewModel : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) RACSignal *loginSignal;

- (RACSignal *)loginSignalWithUserName:(NSString *)userName password:(NSString *)password;

@end
