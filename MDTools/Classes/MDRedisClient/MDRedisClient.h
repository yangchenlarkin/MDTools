//
//  MDRedisClient.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/4.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDRedisClient : NSObject

+ (NSString *)rb;
+ (NSString *)nu;

+ (id)redis:(NSString *)ip on:(NSNumber *)port db:(NSNumber *)db timeout:(NSTimeInterval)timeout;
+ (id)redis:(NSString *)ip on:(NSNumber *)port db:(NSNumber *)db;
+ (id)redis:(NSString *)ip on:(NSNumber *)port;
+ (id)redis:(NSString *)ip on:(NSNumber *)port timeout:(NSTimeInterval)timeout;
+ (id)redis;
- (BOOL)connect:(NSString *)ip on:(NSNumber *)port timeout:(NSTimeInterval)timeout;
- (id)command:(NSData *)command;
- (id)stringCommand:(NSString *)command;
- (id)commandArgv:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;//支持NSNumber NSString NSData

- (NSArray *)getReply;//支持NSNumber NSString NSData NSArray
- (BOOL)timesOut;

- (void)close;

@end

NS_ASSUME_NONNULL_END
