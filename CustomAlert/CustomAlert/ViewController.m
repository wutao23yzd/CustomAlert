//
//  ViewController.m
//  CustomAlert
//
//  Created by wutao on 2019/3/25.
//  Copyright © 2019 wt. All rights reserved.
//

#import "ViewController.h"
#import "WTTableAlertView.h"
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
                       @"多选选隐藏顶部"]
                   
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
    else{
        
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
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return  section == 0 ? 0 : 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
