//
//  MDMMImageCutViewController.h
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDMMImageCutViewController : UIViewController

@property (nonatomic, copy) void (^didFinish)(UIImage *image);
- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
