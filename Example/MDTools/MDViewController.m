//
//  MDViewController.m
//  MDTools
//
//  Created by Larkin on 01/21/2021.
//  Copyright (c) 2021 Larkin. All rights reserved.
//

#import "MDViewController.h"
#import "MDKeyValueGetter.h"

@interface MDViewController ()

@property (nonatomic, strong) MDKeyValueGetter *getter;

@end

@implementation MDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *rootPath = [cachesDir stringByAppendingString:@"/HMIIncarAsserts"];
    
    self.getter = [MDKeyValueGetter getterWithCacheRootPath:rootPath getterBlock:^(NSString * _Nullable key, MDKeyValueGetterResult getterResult) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            getterResult(key, key, nil);
        });
    }];
    self.getter.d2o = ^id _Nullable(NSData * _Nullable data) {
        return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    };
    self.getter.o2d = ^NSData * _Nullable(NSString *object) {
        return [[NSData alloc] initWithBase64EncodedString:object options:NSDataBase64DecodingIgnoreUnknownCharacters];
    };
    
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.getter getObjectForKey:[@(i) stringValue] callback:^(NSString * _Nullable key, id  _Nullable object, NSError * _Nullable error) {
                NSLog(@"1>>>>>%@", object);
            }];
        });
    }
    for (int i = 0; i < 100; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.getter getObjectForKey:[@(i) stringValue] callback:^(NSString * _Nullable key, id  _Nullable object, NSError * _Nullable error) {
                NSLog(@"2>>>>>%@", object);
            }];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
