//
//  HomeViewController.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTableViewModel.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeTableViewModel *homeViewModel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _homeViewModel = [[HomeTableViewModel alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadDataWithSignal:_homeViewModel.requestSignal withSuccess:^{
        [self.tableView reloadData];
    } fail:^{
        NSLog(@"load list data error.");
    } complete:^{}];
    
    @weakify(self);
    [RACObserve(self.homeViewModel, listData) subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%ld", (unsigned long)self.homeViewModel.listData.count);
        self.title = [NSString stringWithFormat:@"total: %lu", (unsigned long)self.homeViewModel.listData.count];
    }];
    
    [self initUI];
}

- (void)initUI {
    [self initEditButton];
}

- (void)initEditButton {
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] init];
    [editBarButtonItem setStyle:UIBarButtonItemStyleDone];
    [editBarButtonItem setTitle:@"Edit"];
    editBarButtonItem.rac_command = _homeViewModel.editCommand;
    [[[editBarButtonItem.rac_command executionSignals] switchToLatest] subscribeNext:^(id x) {
        self.tableView.editing = !self.tableView.editing;
    }];
    
    RAC(editBarButtonItem, title) = [[editBarButtonItem.rac_command.executionSignals switchToLatest] map:^id(id value) {
        if (self.tableView.editing) {
            return @"Done";
        } else {
            return @"Edit";
        }
    }];
    
    self.navigationItem.rightBarButtonItem = editBarButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeViewModel.listData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCellIdentifider"];
    cell.viewModel = self.homeViewModel.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __block NSInteger index = indexPath.row;
        [self.homeViewModel.removeListDataSignal subscribeNext:^(NSArray *listData) {
            NSMutableArray *listDataMuArr = [listData mutableCopy];
            [listDataMuArr removeObjectAtIndex:index];
            self.homeViewModel.listData = listDataMuArr;
        }];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
