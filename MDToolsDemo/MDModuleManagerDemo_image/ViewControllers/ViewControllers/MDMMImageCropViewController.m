//
//  MDMMImageCropViewController.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageCropViewController.h"

@interface MDMMImageCropViewController ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation MDMMImageCropViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, width, 400)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    UIView *mask1 = [[UIView alloc] initWithFrame:CGRectMake(width / 2.f, 0, width / 2.f, 400)];
    mask1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [imageView addSubview:mask1];
    
    UIView *mask2 = [[UIView alloc] initWithFrame:CGRectMake(0, 400 / 2.f, width / 2.f, 400 / 2.f)];
    mask2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [imageView addSubview:mask2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, width, 50)];
    label.numberOfLines = 0;
    label.text = @"此页面模拟图片剪切功能，剪切左上角四分之一的图片";
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 600, width, 44)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finish {
    if (self.didFinish) {
        self.didFinish([self cropImage:self.image]);
    }
}

- (UIImage *)cropImage:(UIImage *)image {
    CGImageRef sourceImageRef = [image CGImage];
    
    CGFloat _imageWidth = image.size.width * image.scale;
    CGFloat _imageHeight = image.size.height * image.scale;
    
    CGRect rect = CGRectMake(0, 0, _imageWidth / 2.f, _imageHeight / 2.f);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}

@end
