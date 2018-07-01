//
//  ViewController.m
//  NNSuspensionMenu
//
//  Created by zhiantech-007 on 2018/6/26.
//  Copyright © 2018年 NingBoYu. All rights reserved.
//

#import "ViewController.h"
#import "NNSuspensionMenuView.h"
#import <MJRefresh/MJRefresh.h>
#import "TestViewController.h"
#import "NNRefreshHeader.h"

@interface ViewController () <NNSuspensionMenuViewDataSource, NNSuspensionMenuViewDelegate>
@property (nonatomic, strong) NNSuspensionMenuView      *menuView;
@property (nonatomic, strong) NSArray                   *titles;
@property (nonatomic, strong) NSArray                   *vcs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    headerView.backgroundColor = [UIColor purpleColor];
    
    self.menuView = [NNSuspensionMenuView suspensionMenuViewWithHeaderView:headerView dataSource:self delegate:self];
    [self.view addSubview:self.menuView];
    self.menuView.frame = self.view.bounds;
    
    __weak typeof(self)weakSelf = self;
    self.menuView.mainScrollView.mj_header = [NNRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshUI];
    }];
    
    self.titles = @[@"NN", @"BB"];
    self.vcs = @[
                 [TestViewController new],
                 [TestViewController new],
                 ];
    [self.menuView reloadData];
}

- (void)refreshUI {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuView.mainScrollView.mj_header endRefreshing];
    });
}

#pragma mark NNSuspensionMenuViewDataSource

- (NSArray *)suspensionMenuTitles {
    return self.titles;
}

- (NSArray *)suspensionViewControllers {
    return self.vcs;
}

@end
