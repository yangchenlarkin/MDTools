//
//  UIImage+MDUtils.h
//  RideSharing
//
//  Created by 杨晨 on 2019/5/16.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (utils)

+ (UIImage *)clearImage;
- (UIImage *)compressWithMaxLength:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
