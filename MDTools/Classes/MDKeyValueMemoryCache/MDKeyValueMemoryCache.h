//
//  MDKeyValueMemoryCache.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2020/7/16.
//  Copyright © 2020 allride.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDKeyValueMemoryCacheNode : NSObject

@end

@interface MDKeyValueMemoryCache <K, O> : NSObject

- (void)cacheObject:(O)object forKey:(K)key;
- (O)getObjectForKey:(K)key;
- (void)releaseWithPercent:(float)percent;

@end

NS_ASSUME_NONNULL_END
