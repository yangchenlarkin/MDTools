//
//  MDLockSlider.m
//  HMI
//
//  Created by 杨晨 on 2019/3/13.
//  Copyright © 2019 杨晨. All rights reserved.
//

#import "MDLockSlider.h"

@interface MDLockSlider ()

@property (nonatomic, strong) UIView *block;
@property (nonatomic, assign) CGFloat blockWidth;
@property (nonatomic, strong) NSSet <__kindof UIView *> *elementViews;
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) CGPoint beginTouchPoint;

@end

@implementation MDLockSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.valueForOpen = 0.99;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateValue:self.value];
}

- (void)setDataSource:(id<MDLockSliderDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)reloadData {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    self.value = 0;
    self.blockWidth = [self _blockWidth];
    self.block = [self _block];
    self.block.userInteractionEnabled = YES;
    self.elementViews = [self _elements];
    self.contentInsets = [self _contentInsets];
    [self _updateSubview];
    
    for (UIView *e in self.elementViews) {
        [self addSubview:e];
    }
    [self addSubview:self.block];
    [self _updateValue:0];
}

- (void)reset {
    [self _updateValue:0];
}

#pragma mark - touch tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.beginTouchPoint = [touch locationInView:self];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [touch locationInView:self];
    [self _didSlideTo:p];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.beginTouchPoint = CGPointZero;
    [self _touchEnd];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    self.beginTouchPoint = CGPointZero;
    [self _touchEnd];
    [super cancelTrackingWithEvent:event];
}

#pragma mark - private method

- (void)_touchEnd {
    if (self.shouldOpen) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } else {
        [self _animatedToBegin];
    }
}

- (void)_animatedToBegin {
    [UIView beginAnimations:@"MDLockSlider_animation" context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self _updateValue:0];
    [UIView commitAnimations];
}

- (void)_didSlideTo:(CGPoint)point {
    float value = (point.x - self.beginTouchPoint.x) / ([self _contentSize].width - self.blockWidth);
    if (value < 0) {
        value = 0;
    } else if (value > 1) {
        value = 1;
    }
    [self _updateValue:value];
}

- (void)_updateValue:(float)value {
    self.value = value;
    CGFloat left = ([self _contentSize].width - self.blockWidth) * value + self.contentInsets.left;
    self.block.frame = CGRectMake(left,
                                  self.contentInsets.top,
                                  self.blockWidth,
                                  self.frame.size.height - self.contentInsets.top - self.contentInsets.bottom);
    [self _updateSubview];
}

#pragma mark data source

- (CGFloat)_blockWidth {
    if ([self.dataSource respondsToSelector:@selector(blockWidthForLockSlider:)]) {
        return [self.dataSource blockWidthForLockSlider:self];
    }
    return 0;
}

- (NSSet <__kindof UIView *> *)_elements {
    if ([self.dataSource respondsToSelector:@selector(elementViewsForLockSlider:)]) {
        return [self.dataSource elementViewsForLockSlider:self];
    }
    return nil;
}

- (__kindof UIView *)_block {
    if ([self.dataSource respondsToSelector:@selector(blockForLockSlider:)]) {
        return [self.dataSource blockForLockSlider:self];
    }
    return nil;
}

- (UIEdgeInsets)_contentInsets {
    if ([self.dataSource respondsToSelector:@selector(contentInsetsForLockSlider:)]) {
        return [self.dataSource contentInsetsForLockSlider:self];
    }
    return UIEdgeInsetsZero;
}

- (CGSize)_contentSize {
    return CGSizeMake(self.bounds.size.width - self.contentInsets.left - self.contentInsets.right,
                      self.bounds.size.height - self.contentInsets.top - self.contentInsets.bottom);
}

- (CGRect)_contentFrame {
    return CGRectMake(self.contentInsets.left, self.contentInsets.top, [self _contentSize].width, [self _contentSize].height);
}

- (void)_updateSubview {
    if ([self.dataSource respondsToSelector:@selector(updateElementView:withValue:contentFrame:forLockSlider:)]) {
        for (UIView *element in self.elementViews) {
            [self.dataSource updateElementView:element withValue:self.value contentFrame:[self _contentFrame] forLockSlider:self];
        }
    }
    if ([self.dataSource respondsToSelector:@selector(updateBlock:withValue:forLockSlider:)]) {
        [self.dataSource updateBlock:self.block withValue:self.value forLockSlider:self];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view ? self : nil;
}

- (BOOL)shouldOpen {
    return self.value >= self.valueForOpen;
}

@end
