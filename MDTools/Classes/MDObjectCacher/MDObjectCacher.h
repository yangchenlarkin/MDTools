//
//  MDObjectCacher.h
//  HMI
//
//  Created by 杨晨 on 2019/7/12.
//  Copyright © 2019 杨晨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    MDObjectCacherLevelLow = -1,
    MDObjectCacherLevelDefault = 0,
    MDObjectCacherLevelHigh = 1,
} MDObjectCacherLevel;

@interface MDObjectCacher : NSObject

+ (id)dequeueObjectForKey:(NSString *)key;
+ (void)cacheObject:(id)object forKey:(NSString *)key cacheLevel:(MDObjectCacherLevel)level;
+ (void)clearWithLevel:(MDObjectCacherLevel)level;//清楚level及level以下的缓存
+ (void)setCapacity:(NSUInteger)capacity;//default is 1024;

@end

NS_ASSUME_NONNULL_END
