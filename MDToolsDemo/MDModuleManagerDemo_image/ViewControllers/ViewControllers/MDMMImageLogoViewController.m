//
//  MDMMImageLogoViewController.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageLogoViewController.h"

@interface MDMMImageLogoViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *logoImage;

@end

@implementation MDMMImageLogoViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
        self.logoImage = [self image:image withLogo:@"Logo"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, width, 400)];
    imageView.image = self.logoImage;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, width, 50)];
    label.numberOfLines = 0;
    label.text = @"此页面模拟图片添加logo功能";
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 600, width, 44)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finish {
    if (self.didFinish) {
        self.didFinish(self.logoImage);
    }
}

- (UIImage *)image:(UIImage *)image withLogo:(NSString *)text {
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGRect rect = CGRectMake(20, 20, 1000, 300);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:150],
                          NSObliquenessAttributeName:@1,
                          NSForegroundColorAttributeName:[UIColor redColor],
                          
                          };
    [text drawInRect:rect withAttributes:dic];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

@end
