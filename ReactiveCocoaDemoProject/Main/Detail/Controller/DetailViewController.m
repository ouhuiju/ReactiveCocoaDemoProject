//
//  DetailViewController.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "HomeTableViewModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _detailTitle;
    
    _detailViewModel = [[DetailViewModel alloc] initWithDetailTitle:_detailTitle];
    
    @weakify(self)
    [self loadDataWithSignal:_detailViewModel.requestSignal withSuccess:^(id x) {
        @strongify(self)
        DetailModel *detailModel = (DetailModel *)x;
        self.titleLabel.text = detailModel.title;
        self.contentLabel.text = detailModel.detailContent;
        self.iconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:detailModel.imageURL]]];
    } fail:^{
        
    } complete:^{
        
    }];
    
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] init];
    [deleteBarButtonItem setStyle:UIBarButtonItemStyleDone];
    [deleteBarButtonItem setTitle:@"delete"];
    deleteBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        [self.deleteSubject sendNext:[NSNumber numberWithInteger:self.index]];
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = deleteBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
