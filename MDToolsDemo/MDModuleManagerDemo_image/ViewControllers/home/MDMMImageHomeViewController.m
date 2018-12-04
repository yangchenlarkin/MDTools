//
//  MDMMImageHomeViewController.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageHomeViewController.h"
#import "MDMMImageProcess1.h"

@interface MDMMImageHomeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MDMMImageHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, width, 50)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"选取照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 550, width, 50)];
    button1.backgroundColor = [UIColor grayColor];
    [button1 setTitle:@"处理照片1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(process1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 600, width, 50)];
    button2.backgroundColor = [UIColor grayColor];
    [button2 setTitle:@"处理照片2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(process2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    [self.view addSubview:self.imageView];
}

- (void)pickPhoto {
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)process1 {
    MDMMImageProcess1 *mm = [[MDMMImageProcess1 alloc] initWithImage:self.imageView.image];
    mm.navigationController = self.navigationController;
    [self.moduleManager pushSubModuleManager:mm animated:YES];
}

- (void)process2 {
    
}

@end
