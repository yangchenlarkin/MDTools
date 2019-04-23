//
//  MDMMImageProcess3.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageProcess3.h"
#import "MDMMImageCropViewController.h"
#import "MDMMImageGrayViewController.h"
#import "MDMMImageLogoViewController.h"

@interface MDMMImageProcess3()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation MDMMImageProcess3
__ImplementationProtocol__

- (instancetype)initWithImage:(UIImage *)image navigationController:(UINavigationController *)navigationController {
    if (self = [self initWithNavigationController:navigationController]) {
        self.originImage = image;
    }
    return self;
}

- (UIViewController *)generateRootViewController {
    MDMMImageCropViewController *vc = [[MDMMImageCropViewController alloc] initWithImage:self.originImage];
    __weak typeof (self) _w_self = self;
    vc.didFinish = ^(UIImage * _Nonnull image) {
        [_w_self logoImage:image];
    };
    return vc;
}

- (void)logoImage:(UIImage *)image {
    MDMMImageLogoViewController *vc = [[MDMMImageLogoViewController alloc] initWithImage:image];
    __weak typeof (self) _w_self = self;
    vc.didFinish = ^(UIImage * _Nonnull image) {
        [_w_self grayImage:image];
    };
    [self pushViewController:vc animated:YES];
}

- (void)grayImage:(UIImage *)image {
    MDMMImageGrayViewController *vc = [[MDMMImageGrayViewController alloc] initWithImage:image];
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
