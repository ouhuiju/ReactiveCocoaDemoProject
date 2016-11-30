//
//  HomeCellViewModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

@interface HomeCellViewModel : NSObject

@property (nonatomic, strong) HomeModel *homeModel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *editor;
@property (nonatomic, copy) NSString *imageURL;

- (instancetype)initWithHomeModel:(HomeModel *)homeModel;

@end
