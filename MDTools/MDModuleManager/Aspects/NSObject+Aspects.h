//
//  NSObject+Aspects.h
//  Mobi
//
//  Created by Larkin Yang on 2017/8/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSObjectAspectInfo <NSObject>

- (id)instance;
- (NSArray *)arguments;

@end

@interface NSObject (MAspect)

- (NSString *)aspect_insertBeforeSelector:(SEL)sel block:(void (^)(id<NSObjectAspectInfo> info))block;
- (NSString *)aspect_insertAfterSelector:(SEL)sel block:(void (^)(id<NSObjectAspectInfo> info))block;
- (void)aspect_removeBlock:(NSString *)blockId;

@end
