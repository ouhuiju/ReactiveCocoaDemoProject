//
//  HomeTableViewModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeTableViewModel.h"
#import "HomeTableViewCell.h"
#import "HomeCellViewModel.h"
#import "HomeModel.h"
#import "URLConfig.h"

@implementation HomeTableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
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
            NSURLSessionDataTask *task = [self.sessionManager GET:[URLConfig shareInstance].list parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSDictionary *responseDict = responseObject[@"data"];
                NSArray *listDataArr = responseDict[@"listData"];
                NSError *error = nil;
//                self.listData = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[HomeModel class] fromJSONArray:listDataArr error:&error]];
                NSMutableArray *viewModelArr = [NSMutableArray new];
                for (NSDictionary *data in listDataArr) {
                    HomeModel *homeModel = [MTLJSONAdapter modelOfClass:[HomeModel class] fromJSONDictionary:data error:&error];
                    HomeCellViewModel *homeCellViewModel = [[HomeCellViewModel alloc] initWithHomeModel:homeModel];
                    [viewModelArr addObject:homeCellViewModel];
                }
                self.listData = [viewModelArr copy];
                if (error) {
                    NSLog(@"%@", error);
                }
                [subscriber sendNext:self.listData];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"get list fail, error is %@", error);
                [subscriber sendNext:self.listData];
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
