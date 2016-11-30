//
//  HomeTableViewModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle.h>
#import <AFNetworking.h>

@interface HomeTableViewModel : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSArray *listData;

@property (nonatomic, strong) RACSignal *requestSignal;

@end
