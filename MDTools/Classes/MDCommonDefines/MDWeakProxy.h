//
//  MDWeakProxy.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/5.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDWeakProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
