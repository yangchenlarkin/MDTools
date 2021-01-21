//
//  UIFont+MDUtils.h
//  RideSharing
//
//  Created by 杨晨 on 2019/5/16.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (utils)

+ (nullable UIFont *)fontWithName:(NSString *)fontName scaledSize:(CGFloat)fontSize;
+ (UIFont *)systemFontOfScaledSize:(CGFloat)fontSize;
+ (UIFont *)boldSystemFontOfScaledSize:(CGFloat)fontSize;
+ (UIFont *)italicSystemFontOfScaledSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
