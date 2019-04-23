//
//  MDMMImageHomeViewController.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageHomeViewController.h"
#import "MDMMImageProcess1.h"
#import "MDMMImageProcess2.h"
#import "MDMMImageProcess3.h"

@interface MDMMImageHomeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

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
    
    self.button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 550, width, 50)];
    self.button1.backgroundColor = [UIColor grayColor];
    [self.button1 setTitle:@"处理照片(流程1)" forState:UIControlStateNormal];
    self.button1.enabled = NO;
    [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.button1 addTarget:self action:@selector(process1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    self.button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 600, width, 50)];
    self.button2.backgroundColor = [UIColor grayColor];
    [self.button2 setTitle:@"处理照片(流程2)" forState:UIControlStateNormal];
    self.button2.enabled = NO;
    [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.button2 addTarget:self action:@selector(process2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
    
    self.button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 650, width, 50)];
    self.button3.backgroundColor = [UIColor grayColor];
    [self.button3 setTitle:@"处理照片(流程3)" forState:UIControlStateNormal];
    self.button3.enabled = NO;
    [self.button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.button3 addTarget:self action:@selector(process3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
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
        self.button1.enabled = YES;
        self.button2.enabled = YES;
        self.button3.enabled = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)process1 {
    MDMMImageProcess1 *mm = [[MDMMImageProcess1 alloc] initWithImage:self.imageView.image navigationController:self.navigationController];
    [self.moduleManager pushSubModuleManager:mm animated:YES];
    __weak typeof(self) _w_self = self;
    __weak typeof(mm) _w_mm = mm;
    mm.didFinish = ^(UIImage * _Nonnull image) {
        _w_self.imageView.image = image;
        _w_self.button1.enabled = NO;
        _w_self.button2.enabled = NO;
        _w_self.button3.enabled = NO;
        [_w_mm popAllViewControllersAnimated:YES];
    };
}

- (void)process2 {
    MDMMImageProcess2 *mm = [[MDMMImageProcess2 alloc] initWithImage:self.imageView.image navigationController:self.navigationController];
    [self.moduleManager pushSubModuleManager:mm animated:YES];
    __weak typeof(self) _w_self = self;
    __weak typeof(mm) _w_mm = mm;
    mm.didFinish = ^(UIImage * _Nonnull image) {
        _w_self.imageView.image = image;
        _w_self.button1.enabled = NO;
        _w_self.button2.enabled = NO;
        _w_self.button3.enabled = NO;
        [_w_mm popAllViewControllersAnimated:YES];
    };
}

- (void)process3 {
    MDMMImageProcess3 *mm = [[MDMMImageProcess3 alloc] initWithImage:self.imageView.image navigationController:self.navigationController];
    [self.moduleManager pushSubModuleManager:mm animated:YES];
    __weak typeof(self) _w_self = self;
    __weak typeof(mm) _w_mm = mm;
    mm.didFinish = ^(UIImage * _Nonnull image) {
        _w_self.imageView.image = image;
        _w_self.button1.enabled = NO;
        _w_self.button2.enabled = NO;
        _w_self.button3.enabled = NO;
        [_w_mm popAllViewControllersAnimated:YES];
    };
}

@end
