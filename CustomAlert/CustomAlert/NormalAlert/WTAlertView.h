//
//  WTAlertView.h
//  CustomAlert
//
//  Created by wutao on 2019/3/25.
//  Copyright © 2019 wt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WTAlertView;
@protocol WTAlertViewDelegate <NSObject>
@optional

- (void)alertView:(WTAlertView*)alertView didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface WTAlertView : UIView

/**
 默认情况下，Alert添加到Window上的。设置该属性可主动设置Alert的父视图
 */
@property (nonatomic, strong) UIView* parentView;

/**
 WTAlertView；包含灰色背景和中间的内容，dialogView为中间的内容
 */
@property (nonatomic, strong) UIView* dialogView;

/**
 alert展示内容区域的视图，除开底部button外的区域。
 */
@property (nonatomic, strong) UIView* containerView;

/**
 如果不设置containerView的内容，且设置了title或message,则会自动创建用于展示内容的label
 */
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* message;

@property (nonatomic, strong) NSArray* buttonTitles;

/**
 触摸Alert以外的区域是否关闭alert;默认为NO
 */
@property (nonatomic, assign) BOOL closeOnTouchUpOutside;

@property (nonatomic, weak) id<WTAlertViewDelegate> delegate;

@property (nonatomic, copy) void(^onButtonTouchUpInside)(WTAlertView *alertView, NSInteger buttonIndex);

// 显示Alert
- (void)show;

/**
 在某个按钮上展示倒计时，在时间到后，自动移除Alert

 @param interval 倒计时时间
 @param buttonIndex 按钮的位置
 */
- (void)showAutoCloseTimeInterval:(NSTimeInterval)interval buttonIndex:(NSInteger)buttonIndex;
// 关闭Alert
- (void)close;

@end

NS_ASSUME_NONNULL_END
