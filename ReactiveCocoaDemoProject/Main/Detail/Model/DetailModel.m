//
//  DetailModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"detailContent":@"detailContent",
             @"imageURL":@"imageURL"
             };
}

@end
