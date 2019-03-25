//
//  WTAlertView.m
//  CustomAlert
//
//  Created by wutao on 2019/3/25.
//  Copyright © 2019 wt. All rights reserved.
//

#import "WTAlertView.h"

#define kWTDefaultButtonHeight 50
#define kWTDefaultButtonSpacerHeight 1
#define kWTAlertViewCornerRadius 7

#define kWTMargin 16

@interface WTAlertView()<WTAlertViewDelegate> {
    CGFloat buttonSpacerHeight;
    CGFloat buttonHeight;
}
@property (nonatomic, strong) NSMutableArray* buttonArray;

@end

@implementation WTAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        // 默认设置代理为self,即当点击按钮时会关闭视图
        _delegate = self;
        // 触摸alert以外的区域是否关闭alert
        _closeOnTouchUpOutside = false;
        
        self.buttonTitles = @[@"关闭"];
        
        self.buttonArray = [NSMutableArray array];
        
        // 状态栏方向改变，代表界面旋转了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        // 键盘弹起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        // 键盘隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}
- (void)showAutoCloseTimeInterval:(NSTimeInterval)interval buttonIndex:(NSInteger)buttonIndex {
    [self.buttonArray removeAllObjects];
    self.dialogView = [self createContainerView];
    
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:_dialogView];
    
    if (self.parentView) {
        // 移除之前展示的Alert
        [WTAlertView removeCurrentAlert:self.parentView];
        [self.parentView addSubview:self];
    }
    else {
        [WTAlertView removeCurrentAlert:[[[UIApplication sharedApplication] windows] firstObject]];
        CGSize screenSize = [self countScreenSize];
        CGSize dialogSize = [self countDialogSize];
        CGSize keyboardSize = CGSizeMake(0, 0);
        
        self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    _dialogView.layer.opacity = 0.5f;
    _dialogView.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.dialogView.layer.opacity = 1.0f;
                         self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:^(BOOL finished) {
                         [self autoCloseAlertAfterInternal:interval buttonIndex:buttonIndex];
                     }];
}
- (void)show {
    [self showAutoCloseTimeInterval:0 buttonIndex:0];
}
+ (void)removeCurrentAlert:(UIView*)parentView {
    NSEnumerator *subviewsEnum = [parentView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            WTAlertView* alertV = (WTAlertView*)subview;
            [alertV removeFromSuperview];
        }
    }
}
- (void)setSubView:(UIView *)subView {
    _containerView = subView;
}
// 创建Title和message label
- (void)createTitleAndMessageLabel {
    // title和message 任意一个有值则创建
    if ((self.title && self.title.length > 0) || (self.message && self.message.length > 0)) {
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        CGSize containerMaxSize = CGSizeMake(_containerView.frame.size.width - 2 * kWTMargin, [UIScreen mainScreen].bounds.size.height - 3 * kWTDefaultButtonHeight - 2 * kWTMargin);
        // 如果title有内容，message没有内容;
        if ((self.title && self.title.length > 0) && (!self.message || self.message.length <= 0)) {
            // 计算展示宽度和高度
            CGSize strSize= [WTAlertView sizeForFont:titleLabel.font str:self.title size:containerMaxSize mode:NSLineBreakByWordWrapping];
            //
            titleLabel.text = self.title;
            
            titleLabel.frame = CGRectMake((_containerView.frame.size.width - strSize.width)/2.0, kWTMargin, strSize.width, strSize.height);
            
            [_containerView addSubview:titleLabel];
            // 重置containerview的frame
            _containerView.frame = CGRectMake(0, 0, _containerView.frame.size.width, CGRectGetMaxY(titleLabel.frame) + kWTMargin);
        }
        // 如果message有内容，title没有内容
        else if ((self.message && self.message.length > 0) && (!self.title || self.title.length <= 0)) {
            // 计算展示宽度和高度
            CGSize strSize= [WTAlertView sizeForFont:titleLabel.font str:self.message size:containerMaxSize mode:NSLineBreakByWordWrapping];
            titleLabel.text = self.message;
            
            titleLabel.frame = CGRectMake((_containerView.frame.size.width - strSize.width)/2.0, kWTMargin, strSize.width, strSize.height);
            [_containerView addSubview:titleLabel];
            // 重置containerview的frame
            _containerView.frame = CGRectMake(0, 0, _containerView.frame.size.width, CGRectGetMaxY(titleLabel.frame) + kWTMargin);
        }
        // title和message均有内容
        else {
            // titleLabel
            CGSize strSize= [WTAlertView sizeForFont:titleLabel.font str:self.title size:CGSizeMake(containerMaxSize.width, containerMaxSize.height/2) mode:NSLineBreakByWordWrapping];
            titleLabel.text = self.title;
            titleLabel.frame = CGRectMake((_containerView.frame.size.width - strSize.width)/2.0, kWTMargin, strSize.width, strSize.height);
            [_containerView addSubview:titleLabel];
            
            // messageLabel
            // 1.创建label
            UILabel* messageLabel = [[UILabel alloc] init];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.font = [UIFont systemFontOfSize:15];
            // 2.计算展示的宽高
            CGSize messageSize= [WTAlertView sizeForFont:titleLabel.font str:self.message size:CGSizeMake(containerMaxSize.width, containerMaxSize.height/2) mode:NSLineBreakByWordWrapping];
            messageLabel.text = self.message;
            messageLabel.frame = CGRectMake((_containerView.frame.size.width - messageSize.width)/2.0, CGRectGetMaxY(titleLabel.frame)+kWTMargin, messageSize.width, messageSize.height);
            [_containerView addSubview:messageLabel];
            // 3.重置containerview的frame
            _containerView.frame = CGRectMake(0, 0, _containerView.frame.size.width, CGRectGetMaxY(messageLabel.frame)+kWTMargin);
        }
    }
}
- (UIView*)createContainerView {
    if (!self.containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        [self createTitleAndMessageLabel];
    }
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    UIView* dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width)/2, (screenSize.height - dialogSize.height)/2, dialogSize.width, dialogSize.height)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];
    CGFloat cornerRadius = kWTAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [dialogContainer addSubview:lineView];
    
    [dialogContainer addSubview:_containerView];
    
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}
- (void)addButtonsToView:(UIView *)container {
    if (!self.buttonTitles) {
        return;
    }
    CGFloat buttonWidth = container.bounds.size.width / self.buttonTitles.count;
    
    for (int i=0; i<self.buttonTitles.count; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        
        [closeButton addTarget:self action:@selector(dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        
        [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [closeButton.layer setCornerRadius:kWTAlertViewCornerRadius];
        
        [container addSubview:closeButton];
        [self.buttonArray addObject:closeButton];
    }
}


- (CGSize)countScreenSize {
    if (self.buttonTitles && self.buttonTitles.count > 0) {
        buttonHeight = kWTDefaultButtonHeight;
        buttonSpacerHeight = kWTDefaultButtonSpacerHeight;
    }
    else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return CGSizeMake(screenWidth, screenHeight);
}
- (CGSize)countDialogSize {
    CGFloat dialogWidth = self.containerView.frame.size.width;
    CGFloat dialogHeight = self.containerView.frame.size.height  + buttonHeight + buttonSpacerHeight;
    return CGSizeMake(dialogWidth, dialogHeight);
}
- (void)dialogButtonTouchUpInside:(UIButton*)sender
{
    if (self.onButtonTouchUpInside) {
        self.onButtonTouchUpInside(self, sender.tag);
    }
    
    else if (_delegate && [_delegate respondsToSelector:@selector(alertView:didClickedButtonAtIndex:)]) {
        [self.delegate alertView:self didClickedButtonAtIndex:sender.tag];
    }
}
- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    if (self.parentView) {
        return;
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self countDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         self.dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}
- (void)close
{
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}
- (void)alertView:(WTAlertView*)alertView didClickedButtonAtIndex:(NSInteger)buttonIndex {
    [self close];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_closeOnTouchUpOutside) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[WTAlertView class]]) {
        [self close];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)autoCloseAlertAfterInternal:(NSTimeInterval)interval buttonIndex:(NSInteger)buttonIndex {
    if (interval > 0 && buttonIndex < self.buttonArray.count) {
        __block dispatch_source_t _source;
        __block NSInteger timeout = interval+1;
        UIButton* button = self.buttonArray[buttonIndex];
        NSString* currentTitle = button.currentTitle;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_source,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_source, ^{
            timeout--;
            if (timeout<=0) {
                dispatch_source_cancel(_source);
                _source = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setTitle:currentTitle forState:UIControlStateNormal];
                    [self close];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self || !self.superview) {
                        _source = nil;
                        return;
                    }
                    [button setTitle:[NSString stringWithFormat:@"%@(%ld)", currentTitle,timeout] forState:UIControlStateNormal];
                });
            }
        });
        dispatch_resume(_source);
    }
}
+ (CGSize)sizeForFont:(UIFont *)font str:(NSString*)str size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attr context:nil];
    result = rect.size;
    return result;
}
@end
