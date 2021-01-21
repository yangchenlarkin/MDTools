//
//  UIScreen+MDUtils.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "UIScreen+MDUtils.h"

CGFloat STATUS_BAR_HEIGHT;
CGFloat NAVIGATION_BAR_HEIGHT;
CGFloat NAVIGATION_STATUS_BAR_HEIGHT;

CGFloat SCREEN_WIDTH;
CGFloat SCREEN_HEIGHT;

CGFloat DESIGNED_WIDTH;
CGFloat SCREEN_SCALE;

BOOL isKindOfX;
CGFloat BOTTOM_SAFE_HEIGHT;

CGFloat ScreenScale(CGFloat v) {
    return v * SCREEN_SCALE;
}

void UIScreenSizeInit(CGFloat designedWidth) {
    STATUS_BAR_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    isKindOfX = STATUS_BAR_HEIGHT > 20.f;
    NAVIGATION_BAR_HEIGHT = 44.f;
    NAVIGATION_STATUS_BAR_HEIGHT = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT;
    
    SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    SCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    
    DESIGNED_WIDTH = designedWidth;
    
    SCREEN_SCALE = SCREEN_WIDTH / DESIGNED_WIDTH;
    
    BOTTOM_SAFE_HEIGHT = isKindOfX ? 34.f : 0.f;
}
