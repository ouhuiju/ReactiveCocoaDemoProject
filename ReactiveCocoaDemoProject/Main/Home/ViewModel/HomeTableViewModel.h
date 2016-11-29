//
//  HomeTableViewModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking.h>
#import <Mantle.h>

@interface HomeTableViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *listData;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) RACSignal *requestSignal;
@property (nonatomic, strong) RACCommand *editCommand;
@property (nonatomic, strong) NSData *imageData;

@end
