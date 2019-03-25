//
//  WTTableAlertView.m
//  CustomTableViewAlertView
//
//  Created by wutao on 2017/10/30.
//  Copyright © 2017年 ttw. All rights reserved.
//

#import "WTTableAlertView.h"
#import "AppDelegate.h"
#define WTKeyWindow ((AppDelegate*)([UIApplication sharedApplication].delegate)).window
#define WTMAINSCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define WTMAINSCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define kContentViewW (WTMAINSCREEN_WIDTH * 0.8)
#define kContentViewMaxH (WTMAINSCREEN_HEIGHT * 0.8)  //内容最大高度
#define kTopViewHeight 50
#define kWTRowHeight  50   //定义tableView行高
#define kBottomViewStyleNormalH 80   //底部只有，取消和确定按钮

@interface WTSelectionCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectionButton;
@property (nonatomic, strong) UILabel*  titleLabel;
@end

@implementation WTSelectionCell

- (UIButton *)selectionButton{
    
    if (!_selectionButton) {
        _selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectionButton setImage:[UIImage imageNamed:@"icon-xuanzhongzhuangtai"] forState:UIControlStateSelected];
        [_selectionButton setImage:[UIImage imageNamed:@"icon-morenxuanze"] forState:UIControlStateNormal];
        // 用代码添加约束时，该属性需要设置为no
        _selectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_selectionButton];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_selectionButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_selectionButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_selectionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:24];
        NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:_selectionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:24];
        [self addConstraint:trailing];
        [self addConstraint:centerY];
        [self addConstraint:width];
        [self addConstraint:height];
    }
    return _selectionButton;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0]];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15];
        // NSLayoutRelationGreaterThanOrEqual,如果titleLabel内容过长，则约束会向后延长
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-45];
        
        [self addConstraint:leading];
        [self addConstraint:trailing];
        [self addConstraint:centerY];
    }
    return _titleLabel;
}

@end

@interface WTTableAlertView() <UITableViewDelegate, UITableViewDataSource>
// Date
@property (nonatomic, strong) NSArray *optionsArray;  // 数据源
@property (nonatomic, strong) NSString *headTitle;    // 顶部title

@property (nonatomic, assign) BOOL isSingleSelection;//是否是单选状态
@property (nonatomic, strong) NSMutableArray *selectedArray;   //已选择的数组
// UI
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView; //背景半透明视图

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel  *titleLabel;


// constrant
@property (nonatomic, strong) NSLayoutConstraint *contentHConstraint; //内容总高度
@property (nonatomic, strong) NSLayoutConstraint *tableviewHConstraint; //tableview高度
@property (nonatomic, strong) NSLayoutConstraint *topViewHConstraint; //标题的高度
@property (nonatomic, strong) NSLayoutConstraint *cancelBtnWConstraint; //标题的高度
@property (nonatomic, assign) CGFloat kTableViewMaxHeight;

@end

@implementation WTTableAlertView

+ (WTTableAlertView *_Nonnull)initWithTitle:(NSString *)title options:(NSArray *)optionsArray
                            singleSelection:(BOOL)selection
                               selectedItems:(NSArray *)items
                          completionHandler:(CompleteSelection)handler{
    
    WTTableAlertView* view = [[WTTableAlertView alloc]initWithFrame:WTKeyWindow.bounds];
    [WTKeyWindow addSubview:view];
    
    view.kTableViewMaxHeight = (kContentViewMaxH -  kBottomViewStyleNormalH); //tableview最大高度
    view.selectedArray = [NSMutableArray array];
    if (items) {
        [view.selectedArray addObjectsFromArray:items];
    }
    else{
        if (optionsArray && optionsArray.count > 0) {
            [view.selectedArray addObject:@(0)]; // 默认选中第1行
        }
    }
    view.isSingleSelection = selection;
    view.completeSelection = handler;
    view.optionsArray = optionsArray?[optionsArray copy] : [NSArray array];
  
    view.headTitle = title;
    
    [view.tableView registerClass:[WTSelectionCell class] forCellReuseIdentifier:@"Cell"];
    [view.tableView reloadData];
    
    view.tableviewHConstraint.constant = view.tableView.contentSize.height > view.kTableViewMaxHeight ? view.kTableViewMaxHeight :  view.tableView.contentSize.height;
    view.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    view.tableView.bounces = view.tableviewHConstraint.constant == view.kTableViewMaxHeight;
    view.contentHConstraint.constant = view.tableviewHConstraint.constant + view.topViewHConstraint.constant + kBottomViewStyleNormalH;
    
    [view layoutIfNeeded];  //让布局立刻生效
    
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.backgroundColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView:)];
        [bgView addGestureRecognizer:tap];
        self.bgView = bgView;
        [self addSubview:bgView];
        [self triggerInitialize];
    }
    return self;
}
#pragma mark - Initlating UI
- (void)triggerInitialize{
    self.contentView.alpha = 1;
    self.topView.alpha = 1;
    self.bottomView.alpha = 1;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.titleLabel.alpha = 1;
    self.cancelBtn.userInteractionEnabled = YES;
    self.confirmBtn.userInteractionEnabled = YES;
    
}
- (void)setHeadTitle:(NSString *)headTitle{
    
    _headTitle = headTitle;
    self.titleLabel.text = headTitle;
    CGFloat topViewH = headTitle ? kTopViewHeight : 0;
    self.topViewHConstraint.constant = topViewH;
    [self updateConstraintsIfNeeded];   //告知立刻更新约束
    
    for (NSLayoutConstraint* cons in self.topView.constraints) {
        
        if (cons.firstAttribute == NSLayoutAttributeHeight) {
            cons.constant = topViewH;
        }
    }
}
- (void)setHiddenConfirBtn:(BOOL)hiddenConfirBtn{
    _hiddenConfirBtn = hiddenConfirBtn;
    self.confirmBtn.hidden = hiddenConfirBtn;
    if (self.confirmBtn.hidden) {
        self.cancelBtnWConstraint.constant = kContentViewW - 80;
        [self updateConstraintsIfNeeded]; 
    }
}
- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.masksToBounds = YES;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:kContentViewW];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:kContentViewMaxH];
        self.contentHConstraint = height;
        
        NSArray *constantArr = @[centerX, centerY, width, height];
        [self addConstraints:constantArr];
        
    }
    return _contentView;
}
- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:_bottomView];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:kBottomViewStyleNormalH];
        NSArray *constantArr = @[bottom, left, right, height];
        [_contentView addConstraints:constantArr];
        
    }
    return _bottomView;
}
- (UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_topView];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem: _topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem: _topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        self.topViewHConstraint = height;
        NSArray *constantArr = @[top, left, right, height];
        [_contentView addConstraints:constantArr];
    }
    return _topView;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = self.headTitle;
        _titleLabel.textColor = [UIColor orangeColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        
        [_topView addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem: _titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.topViewHConstraint.constant];
        NSArray *constantArr = @[top, left, right, height];
        [_topView addConstraints:constantArr];
        
    }
    return _titleLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:_tableView];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.topViewHConstraint?self.topViewHConstraint.constant : 0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:kWTRowHeight * 4];  // 这个高度 仅仅起到占位的作用
        self.tableviewHConstraint = height;
        self.topViewHConstraint = top;
        NSArray *constantArr = @[top, left, right, height];
        [_contentView addConstraints:constantArr];
    }
    return _tableView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor orangeColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelBtn.layer.cornerRadius = 2;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tapCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_cancelBtn];
        _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        // btn 间隔40
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeLeft multiplier:1 constant:40];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:(kContentViewW - 120 ) / 2.0];
        self.cancelBtnWConstraint = width;
        
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40];
        
        NSArray *constantArr = @[left, bottom,width,height];
        [_bottomView addConstraints:constantArr];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.backgroundColor = [UIColor orangeColor];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 2;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn setTitleColor: [UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(tapConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_confirmBtn];
        _confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
        // btn间隔40，距离底部20
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_confirmBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1 constant:-40];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_confirmBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_confirmBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:(kContentViewW - 120 ) / 2.0];
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_confirmBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40];
        
        NSArray *constantArr = @[right, bottom,width,height];
        [_bottomView addConstraints:constantArr];
    }
    return _confirmBtn;
}
#pragma mark - Initlating Event
- (void)tapCancleBtn:(UIButton *)sender {
    self.completeSelection(nil);
    [self closeView:self];
}

- (void)tapConfirmBtn:(UIButton *)sender {
    if (self.selectedArray.count == 0) {
        self.titleLabel.text = @"请选择选项";
        return;
    }
    self.completeSelection([self.selectedArray copy]);
    [self closeView:self];
}

- (void)tapBgView:(UITapGestureRecognizer *)sender {
    self.completeSelection(nil);
    [self closeView:self];
}

- (void)show{
    self.bgView.alpha = 0;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.7;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeView:(WTTableAlertView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        //view.bgView.alpha = 0;
        view.alpha = 0;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}
#pragma mark - TableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLabel.text = self.optionsArray[indexPath.row];
    cell.selectionButton.selected = NO;
    if ([self.selectedArray containsObject:@(indexPath.row)]) {
        cell.selectionButton.selected = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WTSelectionCell *cell = (WTSelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.isSingleSelection) {
        if (self.hiddenConfirBtn) {
            [self.selectedArray removeAllObjects];
            [self.selectedArray addObject:@(indexPath.row)];
            self.completeSelection(self.selectedArray);
            [self closeView:self];
            return;
        }
        
        if (self.selectedArray && self.selectedArray.count > 0) {
            id lastRow = self.selectedArray.lastObject;
            if ([lastRow integerValue] == indexPath.row) {
                // 已经选择
                return;
            }
            WTSelectionCell *cell = (WTSelectionCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[lastRow integerValue] inSection:0]];
            cell.selectionButton.selected = NO;
        }
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:@(indexPath.row)];
        cell.selectionButton.selected = YES;
        
    } else {
        cell.selectionButton.selected = !cell.selectionButton.isSelected;
        if (cell.selectionButton.isSelected) {
            [self.selectedArray addObject:@(indexPath.row)];
        } else {
            [self.selectedArray removeObject:@(indexPath.row)];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWTRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
@end
