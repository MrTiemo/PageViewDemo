//
//  ViewController.m
//  PageViewDemo
//
//  Created by 爱尚家 on 2017/10/20.
//  Copyright © 2017年 Mr_Kong. All rights reserved.
//



#define DEVICE_W self.view.frame.size.width
#define DEVICE_H self.view.frame.size.height


#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
//滚动视图
@property (nonatomic ,strong)UIScrollView *scrollView;
//滚动的线
@property (nonatomic ,strong)UIView *lineScroll;
//选择按钮
@property (nonatomic ,strong)UIButton *selectBtn;
//页数
@property (nonatomic ,assign)NSInteger pageNumber;
//界面一
@property (nonatomic ,strong)OneViewController *oneVC;
//界面二
@property (nonatomic ,strong)TwoViewController *twoVC;


@end

@implementation ViewController


-(UIView *)lineScroll{
    if (_lineScroll == nil) {
        _lineScroll = [[UIView alloc] init];
        _lineScroll.backgroundColor = [UIColor orangeColor];
    }
    return _lineScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化滚动视图

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.contentSize = CGSizeMake(DEVICE_W * 2, DEVICE_H);
    [self.view addSubview:_scrollView];

    //设置控制器
    _oneVC = [[OneViewController alloc] init];
    _twoVC = [[TwoViewController alloc] init];
    
    [self addChildViewController:_oneVC];
    [self addChildViewController:_twoVC];
    
    [_scrollView addSubview:_oneVC.view];
    [_scrollView addSubview:_twoVC.view];
    
    _oneVC.view.frame = CGRectMake(0, 0, DEVICE_W, DEVICE_H);
    _twoVC.view.frame = CGRectMake(DEVICE_W, 0, DEVICE_W, DEVICE_H);
    
    //button的index值应当从0开始
    UIButton *btn = [self setupButtonWithTitle:@"本地超市" Index:0];
    self.selectBtn = btn;
    [self setupButtonWithTitle:@"全球精选" Index:1];
}
- (UIButton *)setupButtonWithTitle:(NSString *)title Index:(NSInteger)index{
    CGFloat y = 0;
    CGFloat w = DEVICE_W/2;
    CGFloat h = 100;
    CGFloat x = index * w;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(x, y, w, h);
    btn.tag = index + 100;
    [btn setTitleColor:[UIColor grayColor] forState:0];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(pageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    //按钮下方的红线
    self.lineScroll.frame = CGRectMake(10, CGRectGetMaxY(btn.frame), w, 4);
    //设置圆角边框
    self.lineScroll.layer.cornerRadius = 2;
    self.lineScroll.layer.masksToBounds = YES;
    [self.view addSubview:_lineScroll];
    return btn;
}
- (void)pageClick:(UIButton *)btn{
    self.pageNumber = btn.tag - 100;
    [self gotoCurrentPage];
}

/**
 *  设置选中button的样式
 */
- (void)setupSelectBtn{
    UIButton *btn = [self.view viewWithTag:self.pageNumber + 100];
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    self.selectBtn = btn;
    //简单的动画效果
    [UIView animateWithDuration:0.3 animations:^{
        self.lineScroll.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame));
    }];
}
/**
 *  进入当前的选定页面
 */
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageNumber;
    frame.origin.y = 0;
    frame.size = _scrollView.frame.size;
    [_scrollView scrollRectToVisible:frame animated:YES];
}


#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scrollView.frame.size.width;
    self.pageNumber = floor((_scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    [self setupSelectBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
