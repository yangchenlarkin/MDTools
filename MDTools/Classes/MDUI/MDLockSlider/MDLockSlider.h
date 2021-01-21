//
//  MDLockSlider.h
//  HMI
//
//  Created by 杨晨 on 2019/3/13.
//  Copyright © 2019 杨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MDLockSlider;

@protocol MDLockSliderDataSource <NSObject>

- (CGFloat)blockWidthForLockSlider:(MDLockSlider *)lockSlider;
- (UIEdgeInsets)contentInsetsForLockSlider:(MDLockSlider *)lockSlider;
- (__kindof UIView *)blockForLockSlider:(MDLockSlider *)lockSlider;
- (NSSet <__kindof UIView *> *)elementViewsForLockSlider:(MDLockSlider *)lockSlider;
- (void)updateElementView:(__kindof UIView *)elementView
                withValue:(float)value
             contentFrame:(CGRect)frame
            forLockSlider:(MDLockSlider *)lockSlider;

- (void)updateBlock:(__kindof UIView *)block
          withValue:(float)value
      forLockSlider:(MDLockSlider *)lockSlider;

@end


@interface MDLockSlider : UIControl

@property (nonatomic, weak) id <MDLockSliderDataSource> dataSource;
@property (nonatomic, assign) float valueForOpen;//default is 0.99;

@property (nonatomic, readonly) __kindof UIView *block;
@property (nonatomic, readonly) NSSet <__kindof UIView *> *elementViews;
@property (nonatomic, readonly) UIEdgeInsets contentInsets;

@property (nonatomic, readonly) BOOL shouldOpen;

- (void)reloadData;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
