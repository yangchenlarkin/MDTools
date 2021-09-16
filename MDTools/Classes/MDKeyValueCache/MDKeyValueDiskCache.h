//
//  MDKeyValueDiskCache.h
//  MDTools
//
//  Created by 杨晨 on 2021/8/12.
//

#import <Foundation/Foundation.h>

typedef NSData *_Nullable(^MDKeyValueDiskCache_o2d)(id _Nullable object);
typedef id _Nullable (^MDKeyValueDiskCache_d2o)(NSData * _Nullable data);

NS_ASSUME_NONNULL_BEGIN

@interface MDKeyValueDiskCache <O> : NSObject

@property (nonatomic, readonly) NSString *rootPath;
@property (nonatomic, copy) MDKeyValueDiskCache_o2d o2d;
@property (nonatomic, copy) MDKeyValueDiskCache_d2o d2o;

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));
- (instancetype)init __attribute__((unavailable("init not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));

+ (MDKeyValueDiskCache *)cacheWithRootPath:(NSString *)rootPath;

//如果传入的Object不是NSData，或者没有设置o2d将其转换成NSData，这里将返回报错；
- (NSError *)cacheObject:(O)object forKey:(NSString *)key;

//如果没有设置d2o将NSData转成Object，这里将直接返回NSData
- (O)objectForKey:(NSString *)key;

//清空rootPath
- (void)clear;

- (NSString *)cachePathForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
