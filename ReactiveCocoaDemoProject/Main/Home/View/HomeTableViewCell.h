//
//  HomeTableViewCell.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>
#import "HomeCellViewModel.h"


@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) HomeCellViewModel *viewModel;

@end
