# XDAlertController
解决iOS8以下UIAlertController无法使用的问题

# More Infomation
在iOS7环境下调用UIAlertController会崩溃，所以通过判断系统的版本号来调用不同的API；        
通过Method Swizzling替换原生的presentViewController和提供近似于原生API接口，让开发者感觉不出与原生API有什么差别。       

# Usage

```ObjC
#import "XDAlertController.h"
...
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

```

