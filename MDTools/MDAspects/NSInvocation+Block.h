//
//  NSInvocation+Block.h
//  MDTools
//
//  Created by Larkin Yang on 2017/8/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Block)
+ (instancetype) invocationWithBlock:(id) block;
+ (instancetype) invocationWithBlockAndArguments:(id) block ,...;
@end
