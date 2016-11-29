//
//  URLConfig.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConfig : NSObject

+ (instancetype)shareInstance;

- (NSString *)login;
- (NSString *)list;
- (NSString *)detail;


@end
