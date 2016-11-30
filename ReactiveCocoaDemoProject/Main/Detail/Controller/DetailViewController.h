//
//  DetailViewController.h
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailViewModel.h"

@interface DetailViewController : BaseViewController

@property (nonatomic, strong) NSString *detailTitle;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) DetailViewModel *detailViewModel;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) RACSubject *deleteSubject;

@end
