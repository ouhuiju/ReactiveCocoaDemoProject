//
//  DetailViewModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import <AFNetworking.h>
#import <ReactiveCocoa.h>

@interface DetailViewModel : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) RACSignal *requestSignal;

@property (nonatomic, strong) NSString *detailTitle;

- (instancetype)initWithDetailTitle:(NSString *)detailTitle;

@end
