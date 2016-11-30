//
//  HomeCellViewModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeCellViewModel.h"

@implementation HomeCellViewModel


- (instancetype)initWithHomeModel:(HomeModel *)homeModel {
    self = [super init];
    if (self) {
        self.homeModel = homeModel;
        [self setupData];
    }
    return self;
}

//do some data handling
- (void)setupData {
    self.title = self.homeModel.title;
    self.editor = [NSString stringWithFormat:@"Editor: %@", self.homeModel.editor];
    self.imageURL = self.homeModel.imageURL;
}

@end
