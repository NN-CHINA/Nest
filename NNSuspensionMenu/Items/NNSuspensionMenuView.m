//
//  NNSuspensionMenuView.m
//  NNSuspensionMenu
//
//  Created by zhiantech-007 on 2018/6/26.
//  Copyright © 2018年 NingBoYu. All rights reserved.
//

#import "NNSuspensionMenuView.h"
#import "NNMenuView.h"
#import "NNChildView.h"
#import <TYPagerController/TYPagerView.h>
#import <TYPagerController/TYTabPagerBar.h>
#import <TYPagerController/TYTabPagerBarCell.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NAVBAR_AND_STATUSBAR_HEIGHT \
([UIApplication sharedApplication].statusBarFrame.size.height + 44)

@interface NNScrollView: UIScrollView <UIGestureRecognizerDelegate>

@end

@implementation NNScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@interface NNSuspensionMenuView() <UIScrollViewDelegate, TYPagerViewDataSource, TYPagerViewDelegate, TYTabPagerBarDelegate, TYTabPagerBarDataSource>
@property (nonatomic, strong) NNScrollView      *mainScrollView;
@property (nonatomic, strong) TYTabPagerBar     *menuView;
@property (nonatomic, strong) TYPagerView       *pageView;
@property (nonatomic, weak  ) id<NNSuspensionMenuViewDataSource>    dataSource;
@property (nonatomic, strong) NSArray           *titles;
@property (nonatomic, strong) NSArray           *viewControllers;
@property (nonatomic, assign) BOOL               gestureToBottom;
@end

@implementation NNSuspensionMenuView

+ (instancetype)suspensionMenuViewWithHeaderView:(UIView *)headerView
                                      dataSource:(id<NNSuspensionMenuViewDataSource>)dataSource
                                        delegate:(id<NNSuspensionMenuViewDelegate>)delegate {
    NNSuspensionMenuView *menuView = [NNSuspensionMenuView new];
    menuView.headerView = headerView;
    menuView.dataSource = dataSource;
    [menuView refreshMenuView];
    return menuView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self refreshMenuView];
}

- (void)reloadData {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(suspensionMenuTitles)]) {
            NSArray *titles = [self.dataSource suspensionMenuTitles];
            self.titles = [NSArray arrayWithArray:titles];
        }
        if ([self.dataSource respondsToSelector:@selector(suspensionViewControllers)]) {
            NSArray *viewControllers = [self.dataSource suspensionViewControllers];
            self.viewControllers = viewControllers;
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<NNSuspensionScrollViewDelegate> *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIScrollView *childScrollView = [obj scrollView];
                [childScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            }];
        }
        [self.menuView reloadData];
        [self.pageView reloadData];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    UIScrollView *childScrollView = (UIScrollView *)object;
    CGFloat childScrollViewOffset = childScrollView.contentOffset.y + childScrollView.adjustedContentInset.top;
    
    CGFloat mainScrollViewAllOffset =  self.mainScrollView.contentOffset.y + self.mainScrollView.adjustedContentInset.top;
//    if (childScrollViewOffset > 0 && mainScrollViewAllOffset == CGRectGetMinY(self.menuView.frame)) {
////        self.mainScrollView.contentOffset = CGPointMake(0, self.mainScrollView.contentOffset.y);
//    } else {
//    }
    
    UIScrollView *scrollView = (UIScrollView *)object;
    CGFloat old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue].y;
    CGFloat new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    if (old > new) {
        self.gestureToBottom = YES;
    } else {
        if (mainScrollViewAllOffset < CGRectGetMinY(self.menuView.frame)) {
            self.gestureToBottom = NO;
        } else {
            self.gestureToBottom = YES;
            scrollView.bounces = YES;
        }
    }
//    NSLog(@"%@", @(self.gestureToBottom));
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIViewController
    <NNSuspensionScrollViewDelegate> *vc = [self.viewControllers objectAtIndex:self.menuView.curIndex];
    UIScrollView *childScrollView = [vc scrollView];
    CGFloat mainScrollViewAllOffset =  self.mainScrollView.contentOffset.y + self.mainScrollView.adjustedContentInset.top;
    CGFloat delyH = CGRectGetMinY(self.menuView.frame);//悬浮的minY
    if (scrollView == self.mainScrollView) {
        if (mainScrollViewAllOffset >= delyH) {
            //悬浮
            scrollView.bounces = NO;
            scrollView.contentOffset = CGPointMake(0, delyH - scrollView.adjustedContentInset.top);
        } else {
            scrollView.bounces = YES;
            if (childScrollView.contentOffset.y > 1 && self.gestureToBottom) {
                scrollView.contentOffset = CGPointMake(0, delyH - scrollView.adjustedContentInset.top);
                            childScrollView.bounces = YES;
            } else {
                childScrollView.contentOffset = CGPointZero;
                
                            childScrollView.bounces = NO;
            }
        }
    }
    
    
//    if (!childScrollView) return;
//    if (childScrollView.contentOffset.y > 0 && mainScrollViewAllOffset < delyH) {
//        //悬浮下滑
//        scrollView.contentOffset = CGPointMake(0, delyH - scrollView.adjustedContentInset.top);
//    }
    
//    [childScrollView setContentOffset:CGPointZero animated:NO];
    
}


#pragma mark RefreshUI

- (void)refreshMenuView {
    self.menuView.frame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), SCREEN_WIDTH, 44);
    CGRect menuViewRect = self.menuView.frame;
    self.pageView.frame = CGRectMake(CGRectGetMinX(menuViewRect),
                                     CGRectGetMaxY(menuViewRect),
                                     CGRectGetWidth(menuViewRect),
                                     SCREEN_HEIGHT - NAVBAR_AND_STATUSBAR_HEIGHT - self.menuView.frame.size.height);
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,
                                                 CGRectGetMaxY(self.pageView.frame));
}

#pragma mark setter
//更新菜单
- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    [self refreshMenuView];
}

#pragma mark lazyload

- (NNScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [NNScrollView new];
        [self addSubview:_mainScrollView];
        _mainScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (TYTabPagerBar *)menuView {
    if (!_menuView) {
        _menuView = [TYTabPagerBar new];
        [self.mainScrollView addSubview:_menuView];
        _menuView.dataSource = self;
        _menuView.delegate = self;
        [_menuView registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:NSStringFromClass([TYTabPagerBarCell class])];
    }
    return _menuView;
}

- (TYPagerView *)pageView {
    if (!_pageView) {
        _pageView = [TYPagerView new];
        [self.mainScrollView addSubview:_pageView];
        _pageView.dataSource = self;
        _pageView.delegate = self;
    }
    return _pageView;
}

#pragma mark TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titles.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar
                                              cellForItemAtIndex:(NSInteger)index {
    TYTabPagerBarCell *cell =
    [pagerTabBar.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TYTabPagerBarCell class])
                                                          forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    NSString *title = [self.titles objectAtIndex:index];
    cell.titleLabel.text = title;
    return cell;
}

#pragma mark TYTabPagerBarDelegate,

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = [self.titles objectAtIndex:index];
    return title.length * 25;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:YES];
    [self.pageView scrollToViewAtIndex:index animate:YES];
    self.gestureToBottom = NO;
}

#pragma mark TYPagerViewDataSource

- (NSInteger)numberOfViewsInPagerView {
    return self.viewControllers.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView
         viewForIndex:(NSInteger)index
          prefetching:(BOOL)prefetching {
    UIViewController<NNSuspensionScrollViewDelegate> *controller = [self.viewControllers objectAtIndex:index];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - self.menuView.frame.size.height);
    controller.view.bounds = rect;
//    controller.automaticallyAdjustsScrollViewInsets = NO;
    [controller scrollView].frame = rect;
    [controller scrollView].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    return controller.view;
}

#pragma mark TYPagerViewDelegate

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.menuView scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.menuView scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)pagerViewDidEndScrolling:(TYPagerView *)pageView animate:(BOOL)animate {
}

@end
