//
//  MDMMImageProcess1.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageProcess1.h"
#import "MDMMImageCropViewController.h"

@interface MDMMImageProcess1()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation MDMMImageProcess1
__ImplementationProtocol__

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.originImage = image;
    }
    return self;
}

- (UIViewController *)generateRootViewController {
    MDMMImageCropViewController *vc = [[MDMMImageCropViewController alloc] initWithImage:self.originImage];
    __weak typeof (self) _w_self = self;
    vc.didFinish = ^(UIImage * _Nonnull image) {
        if (_w_self.didFinish) {
            _w_self.didFinish(image);
        }
    };
    return vc;
}

@end
