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
#import "DetailViewController.h"
#import "LoginViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeTableViewModel *homeViewModel;

@property (nonatomic, assign) BOOL shouldPopupLoginView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeViewModel = [[HomeTableViewModel alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadDataWithSignal:_homeViewModel.requestSignal withSuccess:^(id x) {
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        _shouldPopupLoginView = ![(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] boolValue];
    } else {
        _shouldPopupLoginView = YES;
    }
    
    [RACObserve(self, shouldPopupLoginView) subscribeNext:^(id x) {
        BOOL shouldPopupLoginView = [(NSNumber *)x boolValue];
        if (shouldPopupLoginView) {
            
            LoginViewController *loginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginViewController"];
            [self.navigationController presentViewController:loginViewController animated:YES completion:^{
            }];
            _shouldPopupLoginView = NO;
        }
    }];
}

- (void)initUI {
    [self initEditButton];
    [self initLogoutButton];
}

- (void)initLogoutButton {
    UIBarButtonItem *logoutBarButtonItem = [UIBarButtonItem new];
    [logoutBarButtonItem setStyle:UIBarButtonItemStyleDone];
    [logoutBarButtonItem setTitle:@"Logout"];
    logoutBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"isLogin"];
        self.shouldPopupLoginView = YES;
        return [RACSignal empty];
    }];
    
    self.navigationItem.leftBarButtonItem = logoutBarButtonItem;

}

- (void)initEditButton {
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] init];
    [editBarButtonItem setStyle:UIBarButtonItemStyleDone];
    [editBarButtonItem setTitle:@"Edit"];
    
    editBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.tableView.editing = !self.tableView.editing;
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
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
    
    DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailViewController.detailTitle = ((HomeCellViewModel *)self.homeViewModel.listData[indexPath.row]).title;
    detailViewController.index = indexPath.row;
    detailViewController.deleteSubject = [RACSubject subject];
    [detailViewController.deleteSubject subscribeNext:^(NSNumber *index) {
        NSMutableArray *listDataMuArr = [self.homeViewModel.listData mutableCopy];
        [listDataMuArr removeObjectAtIndex:[index integerValue]];
        self.homeViewModel.listData = listDataMuArr;
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row;
        NSMutableArray *listDataMuArr = [self.homeViewModel.listData mutableCopy];
        [listDataMuArr removeObjectAtIndex:index];
        self.homeViewModel.listData = listDataMuArr;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
