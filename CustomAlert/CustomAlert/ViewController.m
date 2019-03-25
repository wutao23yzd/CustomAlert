//
//  ViewController.m
//  CustomAlert
//
//  Created by wutao on 2019/3/25.
//  Copyright © 2019 wt. All rights reserved.
//

#import "ViewController.h"
#import "WTTableAlertView.h"
#import "WTAlertView.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSArray* dataSource;
}
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dataSource = @[
                   @[@"单选正常底部2个按钮",
                     @"单选隐藏顶部且底部2个按钮",
                     @"单选底部一个按钮",
                     @"单选隐藏顶部，且底部一个按钮"],
                   @[
                       @"多选",
                       @"多选选隐藏顶部"],
                   @[
                       @"普通弹窗-无内容",
                       @"普通弹窗-title",
                       @"普通弹窗-message",
                       @"普通弹窗-title&message",
                       @"3秒后自动消失的弹窗"
                       ]
                   
                   ];
    UIView* topBgView = [[UIView alloc]init];
    topBgView.backgroundColor = [UIColor orangeColor];
    topBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height + 40);
    [self.view addSubview:topBgView];
    
    CGRect frame = self.view.bounds;
    frame.origin.y += CGRectGetMaxY(topBgView.frame);
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray* arr = dataSource[section];
    return arr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"thecell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thecell"];
    }
    
    cell.textLabel.text = dataSource[indexPath.section][indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行", @"第五行", @"第六行",@"第七行", @"第八行", @"第九行",@"第十行", @"第十一行", @"第十二行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"单选" options:array singleSelection:YES selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"默认单选:%@", obj);
                    }
                    
                }];
                [alertview show];
            }
                break;
            case 1:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:nil options:array singleSelection:YES selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"单选，且隐藏顶部标题栏目:%@", obj);
                    }
                    
                }];
                [alertview show];
            }
                break;
            case 2:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"单选" options:array singleSelection:YES selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"单选，且隐藏确定按钮:%@", obj);
                    }
                    
                }];
                alertview.hiddenConfirBtn = YES;
                [alertview show];
            }
                break;
            case 3:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:nil options:array singleSelection:YES selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"单选，且隐藏顶部标题蓝和确定按钮:%@", obj);
                    }
                    
                }];
                alertview.hiddenConfirBtn = YES;
                [alertview show];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行", @"第五行", @"第六行",@"第七行", @"第八行", @"第九行",@"第十行", @"第十一行", @"第十二行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"多选" options:array singleSelection:NO selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"多选:%@", obj);
                    }
                }];
                [alertview show];
            }
                break;
            case 1:{
                NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行", @"第五行", @"第六行",@"第七行", @"第八行", @"第九行",@"第十行", @"第十一行", @"第十二行"];
                WTTableAlertView* alertview = [WTTableAlertView initWithTitle:nil options:array singleSelection:NO selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
                    for (id obj in options) {
                        NSLog(@"多选隐藏顶部:%@", obj);
                    }
                    
                }];
                [alertview show];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                WTAlertView* alertView = [[WTAlertView alloc] init];
                alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
                    [alertView close];
                };
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                [alertView show];
            }
                break;
            case 1:{
                WTAlertView* alertView = [[WTAlertView alloc] init];
                alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
                    [alertView close];
                };
                alertView.title = @"这个Alert只设置了title";
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                [alertView show];
            }
                break;
            case 2:{
                WTAlertView* alertView = [[WTAlertView alloc] init];
                alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
                    [alertView close];
                };
                alertView.message = @"这个Alert只设置了message";
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                [alertView show];
            }
                break;
            case 3:{
                WTAlertView* alertView = [[WTAlertView alloc] init];
                alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
                    [alertView close];
                };
                alertView.title = @"这个Alert只设置了title，并且这个标题是比较长的额。长创建阿里弹尽粮绝了四大皆空放辣椒绿色空间的历史阶段快来睡觉的快来睡觉了时间考虑的就是快乐的家了考试的";
                alertView.message = @"这个Alert只设置了message，并且这个消息是比较长的额。长创建阿里弹尽粮绝了四大皆空放辣椒绿色空间的历史阶段快来睡觉的快来睡觉了时间考虑的就是快乐的家了考试的";
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                [alertView show];
            }
                break;
            case 4:{
                WTAlertView* alertView = [[WTAlertView alloc] init];
                alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
                    [alertView close];
                };
                alertView.title = @"这个Alert在3秒后会自动消失";
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
                [alertView showAutoCloseTimeInterval:3 buttonIndex:0];
            }
                break;
            default:
                break;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    switch (section) {
        case 0:
            label.text = @"单选";
            break;
        case 1:
            label.text = @"多选";
            break;
        case 2:
            label.text = @"普通自定义Alert";
            break;
        default:
            break;
    }
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
