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
    // Do any additional setup after loading the view.
    
    self.title = @"Home";
    
    _homeViewModel = [[HomeTableViewModel alloc] init];
//    self.tableView.delegate = self.homeViewModel;
//    self.tableView.dataSource = self.homeViewModel;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:) fromProtocol:@protocol(UITableViewDataSource)] subscribeNext:^(id x) {
    }];
    
    [[self rac_signalForSelector:@selector(numberOfSectionsInTableView:) fromProtocol:@protocol(UITableViewDataSource)] subscribeNext:^(id x) {
        
    }];
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(id x) {
    
    }];

    
    [self loadDataWithSignal:_homeViewModel.requestSignal withSuccess:^{
        [self.tableView reloadData];
    } fail:^{
        NSLog(@"load list data error.");
    } complete:^{}];
    
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

@end
