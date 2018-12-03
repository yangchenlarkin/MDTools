//
//  Aspects.h
//  MDTools
//
//  Created by Larkin Yang on 2017/8/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AspectOptions) {
    AspectPositionAfter   = 0,
    AspectPositionInstead = 1,
    AspectPositionBefore  = 2,
    
    AspectOptionAutomaticRemoval = 1 << 3
};

@protocol AspectToken <NSObject>

- (BOOL)remove;

@end

@protocol AspectInfo <NSObject>

- (id)instance;

- (NSInvocation *)originalInvocation;

- (NSArray *)arguments;

@end

@interface NSObject (Aspects)
+ (id<AspectToken>)aspect_hookSelector:(SEL)selector
                           withOptions:(AspectOptions)options
                            usingBlock:(id)block
                                 error:(NSError **)error;

- (id<AspectToken>)aspect_hookSelector:(SEL)selector
                           withOptions:(AspectOptions)options
                            usingBlock:(id)block
                                 error:(NSError **)error;

@end


typedef NS_ENUM(NSUInteger, AspectErrorCode) {
    AspectErrorSelectorBlacklisted,
    AspectErrorDoesNotRespondToSelector,
    AspectErrorSelectorDeallocPosition,
    AspectErrorSelectorAlreadyHookedInClassHierarchy,
    AspectErrorFailedToAllocateClassPair,
    AspectErrorMissingBlockSignature,
    AspectErrorIncompatibleBlockSignature,
    
    AspectErrorRemoveObjectAlreadyDeallocated = 100
};

extern NSString *const AspectErrorDomain;
