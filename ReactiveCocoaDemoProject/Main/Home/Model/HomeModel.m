//
//  HomeModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title":@"title",
        @"editor":@"editor",
        @"imageURL":@"imageURL"
    };
}

@end
