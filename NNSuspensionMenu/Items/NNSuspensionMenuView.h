//
//  NNSuspensionMenuView.h
//  NNSuspensionMenu
//
//  Created by zhiantech-007 on 2018/6/26.
//  Copyright © 2018年 NingBoYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NNSuspensionMenuViewDataSource, NNSuspensionMenuViewDelegate, NNSuspensionScrollViewDelegate;

@interface NNSuspensionMenuView : UIView

@property (nonatomic, strong) UIView    *headerView;

@property (nonatomic, strong, readonly) UIScrollView      *mainScrollView;

+ (instancetype)suspensionMenuViewWithHeaderView:(UIView *)headerView
                                      dataSource:(id<NNSuspensionMenuViewDataSource>)dataSource
                                        delegate:(id<NNSuspensionMenuViewDelegate>)delegate;

- (void)reloadData;

@end

@protocol NNSuspensionMenuViewDataSource<NSObject>

- (NSArray *)suspensionMenuTitles;

- (NSArray<UIViewController<NNSuspensionScrollViewDelegate> *> *)suspensionViewControllers;

@end

@protocol NNSuspensionMenuViewDelegate<NSObject>

@end

@protocol NNSuspensionScrollViewDelegate<NSObject>

- (UIScrollView *)scrollView;

@end
