### CustomAlert
-----
本功能均 **参考了github某一demo写出**，代码轻量，用法简单。
#### CustomTableViewAlert自定义tableAlert
-----
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/showDemo.gif)
#### 功能说明
- [x] 会根据数据源的多少显示table的行数和行高
- [x] 设置单选
- [x] 设置多选
- [x] 底部按钮和顶部标题可配置
#### 用法
```
NSArray* array = @[@"第一行", @"第二行", @"第三行",@"第四行", @"第五行", @"第六行",@"第七行", @"第八行", @"第九行",@"第十行", @"第十一行", @"第十二行"];
WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"单选" options:array singleSelection:YES selectedItems:@[@(3)] completionHandler:^(NSArray * _Nullable options) {
  for (id obj in options) {
       NSLog(@"默认单选:%@", obj);
    }
                    
}];
[alertview show];
```
- 导入头文件，按照demo做相关设置。
- 采用代码添加约束，可更改设置的值
-----
#### CustomAlert
iOS原生的**UIAlertController**由于是全局的并且是一个控制器，因此在多人开发多个模块时时，容易造成意想不到的结果，这在开发SDK时，其弊端展示的尤为明显。由于这个这个原因，本文参考了github上的某一个Demo,以UIView的形式展示弹窗。并附带了多个功能。
```
WTAlertView* alertView = [[WTAlertView alloc] init];
alertView.onButtonTouchUpInside = ^(WTAlertView * _Nonnull alertView, NSInteger buttonIndex) {
       NSLog(@"alertView点击了第%ld个按钮",(long)buttonIndex);
       [alertView close];
  };
[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
[alertView show];
```
#### 功能说明
- [x] 自定义Alert视图
- [x] 可设置标题和内容
- [x] 可设置按钮倒计时后自动移除Alert
- [x] 可设置触摸非Alert区域是否移除Alert
- [x] 在展示前，会先移除界面上之前的Alert
#### 仅展示标题
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/title.gif)
#### 仅展示内容
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/msg.gif)
#### 同时展示标题和内容
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/titleAndMsg.gif)
#### 展示倒计时
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/3scountdown.gif)
#### 自定义内容
![img](https://github.com/wutao23yzd/CustomAlert/blob/master/none.gif)
