//
//  HomeTableViewCell.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSignal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupSignal {
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(HomeCellViewModel *viewModel) {
        @strongify(self);
        self.textLabel.text = viewModel.title;
        self.detailTextLabel.text = viewModel.editor;
        
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:viewModel.imageURL]]];
    }];
}


@end
