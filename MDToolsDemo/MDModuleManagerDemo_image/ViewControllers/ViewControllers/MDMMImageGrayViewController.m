//
//  MDMMImageGrayViewController.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageGrayViewController.h"

@interface MDMMImageGrayViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *grayImage;

@end

@implementation MDMMImageGrayViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
        self.grayImage = [self grayImage:image];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, width, 400)];
    imageView.image = self.grayImage;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, width, 50)];
    label.numberOfLines = 0;
    label.text = @"此页面模拟图片滤镜功能，将图片滤镜成灰色图片";
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 600, width, 44)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finish {
    if (self.didFinish) {
        self.didFinish(self.grayImage);
    }
}

- (UIImage*)grayImage:(UIImage*)sourceImage {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height,8,0, colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

@end
