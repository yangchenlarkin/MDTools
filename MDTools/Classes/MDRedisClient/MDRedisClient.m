//
//  MDRedisClient.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/4.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "MDRedisClient.h"
#import <hiredis/hiredis.h>

@interface MDRedisClient () {
    redisContext * _context;
    NSString * _hostIP;
    NSNumber * _hostPort;
    
    NSDate * _lastCommandDate;
}

- (NSArray*)arrayFromVector:(redisReply**)vec ofSize:(NSUInteger)size;
- (id)parseReply:(redisReply*)reply;

- (BOOL)connect;
- (BOOL)connected;

@end

@implementation MDRedisClient

- (id)init {
    self = [super init];
    if (self != nil) {
        _lastCommandDate = [NSDate date];
    }
    return self;
}

- (void)dealloc {
    if (_context != NULL) {
        redisFree(_context);
        _context = NULL;
    }
}

+ (id)redis:(NSString *)ip
         on:(NSNumber *)port
         db:(NSNumber *)db
    timeout:(NSTimeInterval)timeout {
    MDRedisClient *redis = [MDRedisClient redis:ip on:port timeout:timeout];
    if ([redis isKindOfClass:[MDRedisClient class]]) {
        [redis commandArgv:@"SELECT", [db stringValue], nil];
        return redis;
    }
    return nil;
}

+ (id)redis:(NSString*)ip on:(NSNumber*)port db:(NSNumber*)db {
    MDRedisClient *redis = [MDRedisClient redis:ip on:port];
    if ([redis isKindOfClass:[MDRedisClient class]]) {
        [redis commandArgv:@"SELECT", [db stringValue], nil];
        return redis;
    }
    return nil;
}

+ (id)redis:(NSString *)ip on:(NSNumber *)port timeout:(NSTimeInterval)timeout {
    MDRedisClient *redis = [[MDRedisClient alloc] init];
    
    if ([redis connect:ip on:port timeout:timeout]) {
        return redis;
    } else {
        return nil;
    }
}

+ (id)redis:(NSString*)ip on:(NSNumber*)port {
    MDRedisClient *redis = [[MDRedisClient alloc] init];
    
    if ([redis connect:ip on:port timeout:0]) {
        return redis;
    } else {
        return nil;
    }
}

+ (id)redis {
    return [MDRedisClient redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379]];
}

- (BOOL)connect:(NSString *)ip
             on:(NSNumber *)port
        timeout:(NSTimeInterval)timeout {
    _hostIP = ip;
    _hostPort = port;
    if (timeout == 0) {
        return [self connect];
    } else {
        return [self connectWithTimeOut:timeout];
    }
}

- (BOOL)connectWithTimeOut:(NSTimeInterval)timeout {
    struct timeval t;
    t.tv_sec = timeout;
    timeout -= t.tv_sec;
    t.tv_usec = timeout * 1000;
    _context = redisConnectWithTimeout([_hostIP UTF8String], [_hostPort intValue], t);
    if (_context->err != 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)connect {
    _context = redisConnect([_hostIP UTF8String], [_hostPort intValue]);
    if (_context->err != 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)connected {
    if (_context == NULL) {
        return [self connect];
    } else if (!(_context->flags & REDIS_CONNECTED)) {
        redisFree(_context);
        return [self connect];
    } else if (_context->err != 0) {
        redisFree(_context);
        return [self connect];
    }
    else if ([self timesOut]) {
        redisFree(_context);
        return [self connect];
    }
    
    return YES;
}

- (id)command:(NSData *)command {
    if (! [self connected]) { return nil; }
    redisReply *reply = redisCommand(_context, [command bytes]);
    id retVal = [self parseReply:reply];
    if (reply) {
        freeReplyObject(reply);
    }
    return retVal;
}

- (id)stringCommand:(NSString *)command {
    if (! [self connected]) { return nil; }
    redisReply *reply = redisCommand(_context, [command UTF8String]);
    id retVal = [self parseReply:reply];
    if (reply) {
        freeReplyObject(reply);
    }
    return retVal;
}

- (id)commandArgv:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    if (! [self connected]) { return nil; }
    
    int count = 0;
    const char **vector = malloc(sizeof(char *) * (int)100);
    size_t *length = malloc(sizeof(size_t) * (int)100);
    
    id cmd = firstObj;
    va_list args;
    va_start(args, firstObj);
    while (cmd) {
        if ([cmd isKindOfClass:[NSString class]]) {
            NSString *kmd = cmd;
            vector[count] = (char *)[kmd UTF8String];
            length[count] = [kmd lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        } else if ([cmd isKindOfClass:[NSNumber class]]) {
            vector[count] = (char *)[[cmd stringValue] UTF8String];
            length[count] = [[cmd stringValue] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        } else if ([cmd isKindOfClass:[NSData class]]) {
            NSData *kmd = cmd;
            vector[count] = (char *)[cmd bytes];
            length[count] = [kmd length];
        }
        
        count++;
        cmd = va_arg(args, id);
    }
    va_end(args);
    
    redisReply *reply = redisCommandArgv(_context, count, vector, length);
    id retVal = nil;
    if (reply) {
        retVal = [self parseReply:reply];
        freeReplyObject(reply);
    }
    free(vector);
    free(length);
    return retVal;
}

// used with SUBSCRIBE to receive data back when ready
- (id)getReply {
    [self timesOut];
    void * aux = NULL;
    NSMutableArray * replies = [NSMutableArray array];
    
    if (redisGetReply(_context, &aux) == REDIS_ERR) {
        return nil;
    }
    if (aux == NULL) {
        int wdone = 0;
        while (!wdone) { /* Write until done */
            if (redisBufferWrite(_context,&wdone) == REDIS_ERR) {
                return nil;
            }
        }
        
        while(redisGetReply(_context,&aux) == REDIS_OK) { // get reply
            redisReply * reply = (redisReply*)aux;
            id rep = [self parseReply:reply];
            if (rep) {
                [replies addObject:rep];
            }
            freeReplyObject(reply);
        }
    } else {
        redisReply * reply = (redisReply*)aux;
        id rep = [self parseReply:reply];
        if (rep) {
            [replies addObject:rep];
        }
        freeReplyObject(reply);
    }
    
    if ([replies count] > 1) {
        return [NSArray arrayWithArray:replies];
    } else if ([replies count] == 1) {
        return [replies objectAtIndex:0];
    } else {
        return nil;
    }
}

- (BOOL)timesOut {
    NSDate * now = [NSDate date];
    NSTimeInterval elapsed = [now timeIntervalSinceDate:_lastCommandDate];
    _lastCommandDate = now;
    
    if (elapsed > (NSTimeInterval)300.0) {
        return YES;
    }
    return NO;
}

- (void)close {
    redisFree(_context);
    _context = NULL;
}

// Private Methods
- (id)parseReply:(redisReply *)reply {
    id retVal;
    if (!reply) {
        return nil;
    }
    if (reply->type == REDIS_REPLY_ERROR) {
        retVal = [NSString stringWithUTF8String:reply->str];
    } else if (reply->type == REDIS_REPLY_STATUS) {
        retVal = [NSString stringWithUTF8String:reply->str];
    } else if (reply->type == REDIS_REPLY_STRING) {
        retVal = [NSData dataWithBytes:reply->str length:sizeof(char) * reply->len];
    } else if (reply->type == REDIS_REPLY_ARRAY) {
        retVal = [self arrayFromVector:reply->element ofSize:reply->elements];
    } else if (reply->type == REDIS_REPLY_INTEGER) {
        retVal = [NSNumber numberWithLongLong:reply->integer];
    } else if (reply->type == REDIS_REPLY_NIL) {
        retVal = nil;
    }
    else {
        retVal = [NSString stringWithFormat:@"unknown type for: %@", [NSString stringWithUTF8String:reply->str]];
    }
    return retVal;
}

- (NSArray *)arrayFromVector:(redisReply**)vec ofSize:(NSUInteger)size {
    NSMutableArray * buildArray = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++) {
        if (vec[i] != NULL) {
            [buildArray addObject:[self parseReply:vec[i]]];
        } else {
            [buildArray addObject:[NSNull null]];
        }
    }
    return [NSArray arrayWithArray:buildArray];
}

// ruby wrapper path, require ObjCHiredis.rb
+ (NSString *)rb {
    return [[NSBundle bundleForClass:[MDRedisClient class]] pathForResource:@"redis-objc" ofType:@"rb"];
}

// nu wrapper path, (load (ObjCHiredis nu))
+ (NSString *)nu {
    return [[NSBundle bundleForClass:[MDRedisClient class]] pathForResource:@"redis-objc" ofType:@"nu"];
}

@end
