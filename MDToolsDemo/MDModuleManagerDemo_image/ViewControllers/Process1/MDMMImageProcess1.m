//
//  MDMMImageProcess1.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageProcess1.h"
#import "MDMMImageCutViewController.h"

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
    MDMMImageCutViewController *vc = [[MDMMImageCutViewController alloc] initWithImage:self.originImage];
    vc.didFinish = ^(UIImage * _Nonnull image) {
        
    };
    return vc;
}

@end
