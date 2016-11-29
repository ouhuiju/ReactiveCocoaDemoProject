//
//  URLConfig.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "URLConfig.h"

@implementation URLConfig

+ (instancetype)shareInstance {
    static URLConfig *urlConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlConfig = [[URLConfig alloc] init];
    });
    return urlConfig;
}

- (NSString *)host {
    return @"http://ouok-w7.corp.oocl.com:8888";
}

- (NSString *)login {
    NSString *loginURL = [NSString stringWithFormat:@"%@/rest/login", [self host]];
    return loginURL;
}

- (NSString *)list {
    NSString *loginURL = [NSString stringWithFormat:@"%@/rest/list", [self host]];
    return loginURL;
}

- (NSString *)detail {
    NSString *detailURL = [NSString stringWithFormat:@"%@/rest/detail", [self host]];
    return detailURL;
}

@end
