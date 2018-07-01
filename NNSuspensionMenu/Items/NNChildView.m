//
//  NNChildView.m
//  NNSuspensionMenu
//
//  Created by zhiantech-007 on 2018/6/26.
//  Copyright © 2018年 NingBoYu. All rights reserved.
//

#import "NNChildView.h"

@interface NNChildView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation NNChildView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = frame.size;
    [self.collectionView reloadData];
}

- (void)setupSubViews {
    if (_collectionView) {
        return;
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:layout];
    [self addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    layout.itemSize = self.bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    _collectionView = collectionView;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([UICollectionViewCell class]);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                           forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1];
    return cell;
}

@end
