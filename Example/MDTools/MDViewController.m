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


- (NSString *)_rootPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return [cachesDir stringByAppendingString:@"/HMIIncarAsserts"];
}

- (NSString *)_getOrCreatePathForKey:(NSString *)package {
    NSString *path = [[self _rootPath] stringByAppendingFormat:@"/%@", package];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    NSError *error = nil;
    if (!isDir || !existed) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error) {
        return nil;
    }
    return path;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MDKeyValueDiskCache *c = [MDKeyValueDiskCache cacheWithRootPath:[self _getOrCreatePathForKey:@"test"]];
    
    [c cacheObject:[@"1" dataUsingEncoding:kCFStringEncodingUTF8] forKey:@"1"];
    NSString * res = [c cachePathForKey:@"1"];
    NSLog(res);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
