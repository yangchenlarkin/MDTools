//
//  UIScreen+MDUtils.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat STATUS_BAR_HEIGHT;
extern CGFloat NAVIGATION_BAR_HEIGHT;
extern CGFloat NAVIGATION_STATUS_BAR_HEIGHT;

extern CGFloat SCREEN_WIDTH;
extern CGFloat SCREEN_HEIGHT;

extern CGFloat DESIGNED_WIDTH;
extern CGFloat SCREEN_SCALE;

extern BOOL isKindOfX;
extern CGFloat BOTTOM_SAFE_HEIGHT;

CGFloat ScreenScale(CGFloat v);

void UIScreenSizeInit(CGFloat designedWidth);

NS_ASSUME_NONNULL_END
