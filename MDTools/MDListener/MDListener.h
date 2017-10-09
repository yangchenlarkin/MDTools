//
//  MDListener.h
//  mobi-app
//
//  Created by Larkin Yang on 2017/5/25.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MDListener<T: __kindof NSObject *> : NSObject

typedef void (^MDListenerAction)(__nonnull T listener);

@property (nonatomic, readonly) NSUInteger listenerCount;

- (void)addListener:(__nonnull T)listener;
- (void)removeListener:(__nonnull T)listener;
- (void)performAction:(MDListenerAction __nonnull)action;

@end
