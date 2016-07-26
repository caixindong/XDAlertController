//
//  XDAlertController.h
//  XDAlertControllerDemo
//
//  Created by 蔡欣东 on 2016/7/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDAlertAction;

typedef NS_ENUM(NSInteger, XDAlertActionStyle) {
    XDAlertActionStyleDefault = 0,
    XDAlertActionStyleCancel,
    XDAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, XDAlertControllerStyle) {
    XDAlertControllerStyleActionSheet = 0,
    XDAlertControllerStyleAlert
};

@interface XDAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) XDAlertActionStyle style;

@property (nonatomic, assign) BOOL enabled;

@property (nullable, nonatomic, copy ,readonly) void(^handler)(XDAlertAction *_Nonnull);

+ (nullable id)actionWithTitle:(nullable NSString *)title style:(XDAlertActionStyle)style handler:(void (^ __nullable)( XDAlertAction * _Nonnull action))handler;

@end

@interface XDAlertController : UIViewController

+ (nullable instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XDAlertControllerStyle)preferredStyle;

- (void)addAction:(XDAlertAction * _Nonnull)action;

@property (nonnull, nonatomic, readonly) NSArray<XDAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *message;

@property (nullable, nonatomic, strong) UIColor *tintColor;

@property (nonatomic, readonly) XDAlertControllerStyle preferredStyle;

@end
