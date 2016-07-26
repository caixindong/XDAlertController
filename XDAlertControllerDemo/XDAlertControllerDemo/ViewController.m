//
//  ViewController.m
//  XDAlertControllerDemo
//
//  Created by 蔡欣东 on 2016/7/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "ViewController.h"
#import "XDAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionsheet:(id)sender {
    XDAlertController *alert = [XDAlertController alertControllerWithTitle:@"我是actionsheet" message:@"123" preferredStyle:XDAlertControllerStyleActionSheet];
    XDAlertAction *action1 = [XDAlertAction actionWithTitle:@"default" style: XDAlertActionStyleDefault handler:^( XDAlertAction * _Nonnull action) {
        
    }];
    
    XDAlertAction *action2 = [XDAlertAction actionWithTitle:@"取消" style:XDAlertActionStyleCancel handler:^(XDAlertAction * _Nonnull action) {
        
    }];
    
    XDAlertAction *action3 = [XDAlertAction actionWithTitle:@"destructive" style:XDAlertActionStyleDestructive handler:^(XDAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)showAlert:(id)sender {
    XDAlertController *alert = [XDAlertController alertControllerWithTitle:@"我是alertview" message:@"123" preferredStyle:XDAlertControllerStyleAlert];
    XDAlertAction *action1 = [XDAlertAction actionWithTitle:@"default" style: XDAlertActionStyleDefault handler:^( XDAlertAction * _Nonnull action) {
        
    }];
    
    XDAlertAction *action2 = [XDAlertAction actionWithTitle:@"取消" style:XDAlertActionStyleCancel handler:^(XDAlertAction * _Nonnull action) {
        
    }];
    
    XDAlertAction *action3 = [XDAlertAction actionWithTitle:@"destructive " style:XDAlertActionStyleDestructive handler:^(XDAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
