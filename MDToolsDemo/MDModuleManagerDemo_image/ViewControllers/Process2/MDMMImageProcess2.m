//
//  MDMMImageProcess2.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageProcess2.h"
#import "MDMMImageCropViewController.h"
#import "MDMMImageGrayViewController.h"
#import "MDMMImageLogoViewController.h"

@interface MDMMImageProcess2()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation MDMMImageProcess2
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
        [_w_self grayImage:image];
    };
    return vc;
}

- (void)grayImage:(UIImage *)image {
    MDMMImageGrayViewController *vc = [[MDMMImageGrayViewController alloc] initWithImage:image];
    __weak typeof (self) _w_self = self;
    vc.didFinish = ^(UIImage * _Nonnull image) {
        [_w_self logoImage:image];
    };
    [self pushViewController:vc animated:YES];
}

- (void)logoImage:(UIImage *)image {
    MDMMImageLogoViewController *vc = [[MDMMImageLogoViewController alloc] initWithImage:image];
    __weak typeof (self) _w_self = self;
    vc.didFinish = ^(UIImage * _Nonnull image) {
        [_w_self finish:image];
    };
    [self pushViewController:vc animated:YES];
}

- (void)finish:(UIImage *)image {
    if (self.didFinish) {
        self.didFinish(image);
    }
}

@end
