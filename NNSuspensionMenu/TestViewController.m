//
//  TestViewController.m
//  NNSuspensionMenu
//
//  Created by zhiantech-007 on 2018/6/29.
//  Copyright © 2018年 NingBoYu. All rights reserved.
//

#import "TestViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 /255.0) green:(arc4random() % 255 /255.0) blue:(arc4random() % 255 /255.0) alpha:1];
    cell.textLabel.text = (@(indexPath.row)).stringValue;
    return cell;
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableview = [UITableView new];
        tableview.delegate = self;
        tableview.dataSource = self;
        [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView = tableview;
    }
    return _tableView;
}

@end
