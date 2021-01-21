//
//  UITextField+MDUtils.h
//  RideSharing
//
//  Created by 杨晨 on 2019/5/17.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (utils)

@property (nonatomic, copy) UIColor *placeholderColor;
@property (nonatomic, copy) UIFont *placeholderFont;
@property (nonatomic, assign) NSUnderlineStyle placeholderUnderlineStyle;

@end

NS_ASSUME_NONNULL_END
