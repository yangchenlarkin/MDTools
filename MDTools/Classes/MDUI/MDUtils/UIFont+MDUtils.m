//
//  UIFont+MDUtils.m
//  RideSharing
//
//  Created by 杨晨 on 2019/5/16.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "UIFont+MDUtils.h"
#import "UIScreen+MDUtils.h"

@implementation UIFont (utils)

+ (nullable UIFont *)fontWithName:(NSString *)fontName scaledSize:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:ScreenScale(fontSize)];
}

+ (UIFont *)systemFontOfScaledSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:ScreenScale(fontSize)];
}

+ (UIFont *)boldSystemFontOfScaledSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:ScreenScale(fontSize)];
}

+ (UIFont *)italicSystemFontOfScaledSize:(CGFloat)fontSize {
    return [UIFont italicSystemFontOfSize:ScreenScale(fontSize)];
}

@end
