//
//  UIControl+MDUtils.h
//  RideSharing
//
//  Created by 杨晨 on 2019/5/16.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIControlStateDidChange <NSObject>

- (void)controlStateDidChange:(UIControl *)control;

@end

@interface UIControl (utils)

- (void)addControlStateListener:(id<UIControlStateDidChange>)listener;

@end

NS_ASSUME_NONNULL_END
