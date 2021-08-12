//
//  MDKeyValueGetter.h
//  MDTools
//
//  Created by 杨晨 on 2021/8/12.
//

#import <Foundation/Foundation.h>
#import "MDKeyValueMemoryCache.h"
#import "MDKeyValueDiskCache.h"

typedef void(^MDKeyValueGetterResult)(NSString * _Nullable key, id _Nullable object, NSError * _Nullable error);
typedef void(^MDKeyValueGetterBlock)(NSString * _Nullable key, MDKeyValueGetterResult getterResult);

NS_ASSUME_NONNULL_BEGIN

@interface MDKeyValueGetter <O> : NSObject

//在本地磁盘存储object的时候，需要将object转成NSObject。如果object本身就是NSData类型的，可以不用给o2d和d2o赋值；
@property (nonatomic, copy) MDKeyValueDiskCache_o2d o2d;
@property (nonatomic, copy) MDKeyValueDiskCache_d2o d2o;

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));
- (instancetype)init __attribute__((unavailable("init not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call [MDKeyValueDiskCache cacheWithRootPath:] instead")));

+ (MDKeyValueGetter *)getterWithCacheRootPath:(NSString *)rootPath getterBlock:(MDKeyValueGetterBlock)getter;

- (void)getObjectForKey:(NSString *)key callback:(MDKeyValueGetterResult)callback;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
