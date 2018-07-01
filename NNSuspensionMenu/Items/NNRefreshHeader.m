//
//  NNRefreshHeader.m
//  NNSuspensionMenu
//
//  Created by 喵喵炭 on 2018/7/1.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "NNRefreshHeader.h"

@interface NNRefreshHeader()
@property (nonatomic, strong) UIImageView *imageView;
@end
//
@implementation NNRefreshHeader

- (void)prepare {
    [super prepare];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self addSubview:imageView];
    self.imageView = imageView;
    self.backgroundColor = [UIColor purpleColor];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.imageView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    [self.imageView sizeToFit];
}


@end
