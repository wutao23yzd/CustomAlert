//
//  WTTableAlertView.h
//  CustomTableViewAlertView
//
//  Created by wutao on 2017/10/30.
//  Copyright © 2017年 ttw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompleteSelection)(NSArray* options);


@interface WTTableAlertView : UIView
// 是否隐藏确定按钮，应用场景在 单选情况下，点击了一个按钮后，界面消失的情况
@property (nonatomic, assign) BOOL hiddenConfirBtn;
@property (nonatomic, copy, nonnull) void (^completeSelection)(NSArray * options);


/**
 初始化view

 @param title 标题，可为空，为空时，顶部将不展示
 @param optionsArray 数据源
 @param selection 是否多选
 @param items 初始选择
 @param handler 点击确定，或取消后
 @return 返回view
 */
+ (WTTableAlertView *)initWithTitle:(NSString *)title options:(NSArray*)optionsArray
                                singleSelection:(BOOL)selection
                                 selectedItems:(NSArray*)items
                          completionHandler:(CompleteSelection)handler;

-(void)show;

@end
