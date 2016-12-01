//
//  DetailViewModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "DetailViewModel.h"
#import "URLConfig.h"
#import "DetailModel.h"

@implementation DetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
    }
    return self;
}

- (instancetype)initWithDetailTitle:(NSString *)detailTitle {
    self = [self init];
    if (self) {
        self.detailTitle = detailTitle;
    }
    return self;
}

- (void)dealloc {
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

- (RACSignal *)requestSignal {
    if (!_requestSignal) {
        @weakify(self);
        _requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSDictionary *params = @{
                                     @"title":self.detailTitle
                                     };
            NSURLSessionDataTask *task = [self.sessionManager GET:[URLConfig shareInstance].detail parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSDictionary *responseDict = responseObject[@"data"];
                NSError *error = nil;
                //                self.listData = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[HomeModel class] fromJSONArray:listDataArr error:&error]];
                DetailModel *detailModel = [MTLJSONAdapter modelOfClass:[DetailModel class] fromJSONDictionary:responseDict error:&error];
                if (error) {
                    NSLog(@"%@", error);
                }
                [subscriber sendNext:detailModel];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"get detail fail, error is %@", error);
                [subscriber sendError:error];
            }];
            
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }
    return _requestSignal;
}

@end
