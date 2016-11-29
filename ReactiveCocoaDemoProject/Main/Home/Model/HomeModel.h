//
//  HomeModel.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HomeModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *editor;
@property (nonatomic, copy) NSString *imageURL;

@end
