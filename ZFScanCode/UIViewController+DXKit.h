//
//  UIViewController+DXTabTitle.h
//  Fujitsu LifeCam
//
//  Created by news365-macpro on 2017/3/22.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DXKit)

-(NSString *)getTabBarControllerTitle;

/**
 从 Main.storyboard 中获取 控制器
 */
+ (UIViewController *)viewControllerFromMainStoryboardWithIdentifier:(NSString *)identifier;

/**
 弹出 AlertController
 actionTitle    : 确定按钮的title
 actionHandler  : 确定按钮点击事件
 自带取消按钮
 */
- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                        actionTitle:(NSString *)actionTitle
                                        actionStyle:(UIAlertActionStyle)actionStyle
                                      actionHandler:(void (^)(UIAlertAction *action))handler;

/**
 显示 AlertControllerStyleAction 自带取消按钮
 */
- (UIAlertController *)showAlertControllerStyleActionSheetWithTitle:(NSString *)title
                                                            message:(NSString *)message
                                                        actionTitle:(NSString *)actionTitle
                                                        actionStyle:(UIAlertActionStyle)actionStyle
                                                      actionHandler:(void (^)(UIAlertAction *action))handler;

/**
 AlertControllerStyleAlert 自带取消按钮
 */
- (UIAlertController *)showAlertControllerStyleAlertWithTitle:(NSString *)title
                                                      message:(NSString *)message
                                                  actionTitle:(NSString *)actionTitle
                                                  actionStyle:(UIAlertActionStyle)actionStyle
                                                actionHandler:(void (^)(UIAlertAction *action))handler;


/**
 弹出可输入内容的 AlertController
 actionTitle    : 确定按钮的title
 actionHandler  : 确定按钮点击事件
 */
-(UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                       actionTitle:(NSString *)actionTitle
                                     actionHandler:(void (^)(UIAlertAction *action, UITextField *textField))handler
                 textFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;


/**
 显示 AlertController 自定义action;
 */
- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            actions:(NSArray<UIAlertAction *> *)actions;

@end
