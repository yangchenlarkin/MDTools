//
//  MDKeyValueDiskCache.m
//  MDTools
//
//  Created by 杨晨 on 2021/8/12.
//

#import "MDKeyValueDiskCache.h"
#import "MDGCDRWLock.h"
#import <YYCategories/NSString+YYAdd.h>

@interface MDKeyValueDiskCache ()

@property (nonatomic, strong) MDGCDRWLock *lock;

@end

@implementation MDKeyValueDiskCache

+ (MDKeyValueDiskCache *)cacheWithRootPath:(NSString *)rootPath; {
    if (!rootPath) {
        return nil;
    }
    MDKeyValueDiskCache *res = [[MDKeyValueDiskCache alloc] init];
    res->_rootPath = rootPath;
    res->_lock = [[MDGCDRWLock alloc] init];
    
    return res;
}

- (NSString *)cachePathForKey:(NSString *)key {
    if (self.rootPath.length == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", self.rootPath, key.md5String];
}

- (NSString *)_getOrCreatePathForKey:(NSString *)key {
    __block NSString *res = nil;
    [self.lock doWriteWithSync:YES task:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL existed = [fileManager fileExistsAtPath:self.rootPath isDirectory:&isDir];
        NSError *error = nil;
        if (!isDir || !existed) {
            [fileManager createDirectoryAtPath:self.rootPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!error) {
            res = [NSString stringWithFormat:@"%@%@", self.rootPath, key];
        }
    }];
    return res;
}

- (NSError *)cacheObject:(id)object forKey:(NSString *)key; {
    if (![object isKindOfClass:[NSData class]]) {
        if (self.o2d == NULL) {
            return [NSError errorWithDomain:@"MD.KVCache.Disk.CacheObjectForKey" code:-1 userInfo:@{
                NSLocalizedDescriptionKey: @"请传入NSData对象，或设置o2d将传入的对象转换成NSData",
            }];
        }
        object = self.o2d(object);
    }
    key = [@"/" stringByAppendingString:key.md5String];
    NSString *path = [self _getOrCreatePathForKey:key];
    [self.lock doWriteWithSync:YES task:^{
        [object writeToFile:path atomically:YES];
    }];
    return nil;
}

- (id)objectForKey:(NSString *)key; {
    key = [@"/" stringByAppendingString:key.md5String];
    __block NSData *res = nil;
    [self.lock doReadWithSync:YES task:^{
        res = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", self.rootPath, key]]];
    }];
    return res;
}

- (void)clear; {
    [self.lock doReadWithSync:YES task:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:self.rootPath error:NULL];
    }];
}

@end
