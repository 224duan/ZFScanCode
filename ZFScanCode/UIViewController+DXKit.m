//
//  UIViewController+DXTabTitle.m
//  Fujitsu LifeCam
//
//  Created by news365-macpro on 2017/3/22.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import "UIViewController+DXKit.h"

@implementation UIViewController (DXKit)


-(NSString *)getTabBarControllerTitle
{
    return self.tabBarItem.title;
}

+ (UIViewController *)viewControllerFromMainStoryboardWithIdentifier:(NSString *)identifier
{
    UIStoryboard *mainStroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStroy instantiateViewControllerWithIdentifier:identifier];
}

- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                        actionTitle:(NSString *)actionTitle
                                        actionStyle:(UIAlertActionStyle)actionStyle
                                      actionHandler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:handler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:saveAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    return alertVC;
}

- (UIAlertController *)showAlertControllerStyleActionSheetWithTitle:(NSString *)title
                                                            message:(NSString *)message
                                                        actionTitle:(NSString *)actionTitle
                                                        actionStyle:(UIAlertActionStyle)actionStyle
                                                      actionHandler:(void (^)(UIAlertAction *action))handler
{
    return [self showAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet actionTitle:actionTitle actionStyle:actionStyle actionHandler:handler];
}

- (UIAlertController *)showAlertControllerStyleAlertWithTitle:(NSString *)title
                                                      message:(NSString *)message
                                                  actionTitle:(NSString *)actionTitle
                                                  actionStyle:(UIAlertActionStyle)actionStyle
                                                actionHandler:(void (^)(UIAlertAction *action))handler
{
    return [self showAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert actionTitle:actionTitle actionStyle:actionStyle actionHandler:handler];
}

-(UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                       actionTitle:(NSString *)actionTitle
                                     actionHandler:(void (^)(UIAlertAction *action, UITextField *textField))handler
                 textFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common.cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (handler) {
            UITextField *textField = [alertController.textFields firstObject];
            handler(action,textField);
        }
    }];
    [alertController addTextFieldWithConfigurationHandler:configurationHandler];
    [alertController addAction:CancelAction];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            actions:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    for (UIAlertAction *action in actions) {
        [alertVC addAction:action];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
    return alertVC;
}

@end
