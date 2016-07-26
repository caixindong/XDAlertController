//
//  XDAlertController.m
//  XDAlertControllerDemo
//
//  Created by 蔡欣东 on 2016/7/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDAlertController.h"
#import <objc/runtime.h>

#define XDiOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)

@interface XDAlertAction ()

@property (nullable, nonatomic, readwrite) NSString *title;

@property (nonatomic, readwrite) XDAlertActionStyle style;

@property (nullable, nonatomic, copy, readwrite) void (^handler)(XDAlertAction *);

@end

@implementation XDAlertAction

+ (id)actionWithTitle:(NSString *)title style:(XDAlertActionStyle)style handler:(void (^)(XDAlertAction * _Nonnull))handler {
    if (XDiOS8Later) {
        UIAlertActionStyle actionStyle = (NSInteger) style;
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:actionStyle handler:(void (^ __nullable)(UIAlertAction *))handler];
        return action;
    }else {
        XDAlertAction *action = [[XDAlertAction alloc] init];
        action.title = title;
        action.style = style;
        action.handler = handler;
        return action;
    }
}

@end

@interface XDAlertController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, readwrite) NSMutableArray<XDAlertAction *> *mutableActions;

@property (nonatomic, readwrite) XDAlertControllerStyle preferredStyle;

@property (nonatomic, strong, readwrite) id alertView;

@end

@implementation XDAlertController

- (instancetype)init {
    if ([super init]) {
        if (XDiOS8Later) {
            _alertView = [[UIAlertController alloc] init];
        }else {
            _alertView = [[UIAlertView alloc] init];
            _mutableActions = [NSMutableArray array];
            _preferredStyle = XDAlertControllerStyleAlert;
            ((UIAlertView *)_alertView).delegate = self;
        }
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(XDAlertControllerStyle)preferredStyle {
    XDAlertController *alertController = [[XDAlertController alloc] init];
    alertController.preferredStyle = preferredStyle;
    if (XDiOS8Later) {
        alertController.alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)preferredStyle];
    }else {
        switch (preferredStyle) {
            case XDAlertControllerStyleAlert:{
                alertController.alertView = [[UIAlertView alloc]
                                             initWithTitle:title
                                             message:message
                                             delegate:alertController
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil, nil];
            }
                break;
            case XDAlertControllerStyleActionSheet:{
                alertController.alertView = [[UIActionSheet alloc] initWithTitle:title
                                                                            delegate:alertController
                                                                   cancelButtonTitle:nil
                                                              destructiveButtonTitle:nil
                                                                   otherButtonTitles:nil, nil];
            }
                break;
            default:
                break;
        }
    }
    return alertController;
}

- (void)addAction:(XDAlertAction *)action {
    if (XDiOS8Later) {
        [self.alertView addAction:(UIAlertAction *)action];
    }else {
        [self.mutableActions addObject:action];
        
        NSInteger actionIndex = [self.alertView addButtonWithTitle:action.title];
        switch (action.style) {
            case XDAlertActionStyleCancel:{
                [self.alertView setCancelButtonIndex:actionIndex];
            }
                break;
            case XDAlertActionStyleDefault:{

            }
                break;
            case XDAlertActionStyleDestructive:{
                if ([self.alertView isKindOfClass:[UIActionSheet class]]) {
                    [self.alertView setDestructiveButtonIndex:actionIndex];   
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak __typeof(XDAlertAction *) weakAction = self.mutableActions[buttonIndex];
    if (self.mutableActions[buttonIndex].handler) {
        self.mutableActions[buttonIndex].handler(weakAction);
    }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak __typeof(XDAlertAction *) weakAction = self.mutableActions[buttonIndex];
    if (self.mutableActions[buttonIndex].handler) {
        self.mutableActions[buttonIndex].handler(weakAction);
    }
}

#pragma Mmark - getter and setter
-(NSArray<XDAlertAction *> *)actions{
    return [self.mutableActions copy];
}

-(NSString *)title{
    return [self.alertView title];
}

-(void)setTitle:(NSString *)title{
    [self.alertView setTitle:title];
}

-(NSString *)message{
    return [self.alertView message];
}

-(void)setMessage:(NSString *)message{
    [self.alertView setMessage:message];
}

@end

#pragma mark - method swizzling

@interface UIViewController (XDAlertController)

@end

@implementation UIViewController (XDAlertController)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        
        SEL swizzlingSelector = @selector(xd_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
        
        BOOL didAddMethod = class_addMethod(class, swizzlingSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzlingSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
    });
}

- (void)xd_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[XDAlertController class]]) {
        XDAlertController *alert = (XDAlertController *) viewControllerToPresent;
        if (XDiOS8Later) {
            ((UIAlertController *)alert.alertView).view.tintColor = alert.tintColor;
            [self xd_presentViewController:((XDAlertController *)viewControllerToPresent).alertView animated:flag completion:completion];
        }else {
            if ([alert.alertView isKindOfClass:[UIAlertView class]]) {
                [alert.alertView show];
            }else if ([alert.alertView isKindOfClass:[UIActionSheet class]]) {
                [alert.alertView showInView:self.view];
            }
        }
    }else {
        [self xd_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end

