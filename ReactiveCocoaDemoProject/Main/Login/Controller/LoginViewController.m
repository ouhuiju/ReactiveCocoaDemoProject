//
//  LoginViewController.m
//  ReactiveCocoaDemoProject
//
//  Created by OKAR OU on 16/11/28.
//  Copyright © 2016年 Okar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

//@property (nonatomic, copy) NSString *userName;
//@property (nonatomic, copy) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginViewModel = [[LoginViewModel alloc] init];
    @weakify(self)
    
    RACSignal *usernameSignal = [self.userNameTextField.rac_textSignal map:^id(NSString *usernameText) {
        NSUInteger length = usernameText.length;
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];
    
    
    RACSignal *passwordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *password) {
        NSUInteger length = password.length;
        if (length >= 1 && length <= 20) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[usernameSignal, passwordSignal] reduce:^(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect){
        return @(isUsernameCorrect.boolValue && isPasswordCorrect.boolValue);
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

            [[self.loginViewModel loginSignalWithUserName:_userNameTextField.text password:_passwordTextField.text] subscribeNext:^(NSNumber *success) {
                @strongify(self)
                if ([success boolValue]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isLogin"];
                } else {
                    [self errorAlert];
                    self.userNameTextField.text = @"";
                    self.passwordTextField.text = @"";
                }
            } error:^(NSError *error) {
                [self errorAlert];
                self.userNameTextField.text = @"";
                self.passwordTextField.text = @"";
            }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)errorAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Fail" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
