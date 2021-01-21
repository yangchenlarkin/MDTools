//
//  NSString+ARCommon.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2020/5/20.
//  Copyright © 2020 allride.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ARCommon)

- (NSString *)rsaBase64StringWith2048PublicPEMKey:(NSString *)publicPEMKey;

- (NSString *)pinyin;
- (NSInteger)levenshteinDistanceToString:(NSString *)string;//编辑距离

@end

NS_ASSUME_NONNULL_END
