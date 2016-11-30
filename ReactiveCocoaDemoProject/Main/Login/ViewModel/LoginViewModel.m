//
//  LoginViewModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/30.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "LoginViewModel.h"
#import "URLConfig.h"

@implementation LoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
    }
    return self;
}

- (void)dealloc {
    [_sessionManager invalidateSessionCancelingTasks:YES];
}

- (RACSignal *)loginSignalWithUserName:(NSString *)userName password:(NSString *)password {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.sessionManager POST:[URLConfig shareInstance].login parameters:@{@"userName":userName,@"password":password} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            BOOL success = [(NSNumber *)responseDict[@"success"] boolValue];
            [subscriber sendNext:success?@YES:@NO];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"login fail, error is %@", error);
            [subscriber sendNext:@NO];
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
