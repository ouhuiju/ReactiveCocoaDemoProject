//
//  HomeTableViewModel.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "HomeTableViewModel.h"
#import "HomeTableViewCell.h"
#import "HomeCellViewModel.h"
#import "HomeModel.h"
#import "URLConfig.h"

@implementation HomeTableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
    }
    return self;
}

- (void)dealloc {
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

- (RACCommand *)editCommand {
    if (!_editCommand) {
        _editCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _editCommand;
}

- (RACSignal *)requestSignal {
    if (!_requestSignal) {
        @weakify(self);
        _requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSURLSessionDataTask *task = [self.sessionManager GET:[URLConfig shareInstance].list parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSDictionary *responseDict = responseObject[@"data"];
                NSArray *listDataArr = responseDict[@"listData"];
                
                NSError *error = nil;
                self.listData = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[HomeModel class] fromJSONArray:listDataArr error:&error]];
                if (error) {
                    NSLog(@"%@", error);
                }
                [subscriber sendNext:self.listData];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [subscriber sendNext:self.listData];
                [subscriber sendError:error];
            }];
            
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }
    return _requestSignal;
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCellIdentifider"];
    HomeModel *homeModel = self.listData[indexPath.row];
    if (!_imageData) {
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:homeModel.imageURL]];
    }
    cell.imageView.image = [UIImage imageWithData:_imageData];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text = homeModel.title;
    cell.detailTextLabel.text = homeModel.editor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row;
        [self.listData removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
