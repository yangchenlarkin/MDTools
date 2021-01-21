//
//  NSString+ARCommon.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2020/5/20.
//  Copyright © 2020 allride.ai. All rights reserved.
//

#import "NSString+ARCommon.h"
#import "DDRSAWrapper.h"
#import <YYCategories/YYCategories.h>

@implementation NSString (ARCommon)

- (NSString *)rsaBase64StringWith2048PublicPEMKey:(NSString *)publicPEMKey {
    DDRSAWrapper *w = [[DDRSAWrapper alloc] init];
    SecKeyRef publicKeyRef = [w publicSecKeyFromKeyBits:[[NSData alloc] initWithBase64EncodedString:publicPEMKey.copy options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t encData[2048/8] = {0};
    size_t blockSize = 2048 / 8 ;
    OSStatus ret;
    ret = SecKeyEncrypt(publicKeyRef, kSecPaddingNone, srcData.bytes, srcData.length, encData, &blockSize);
    NSAssert(ret==errSecSuccess, @"加密失败");

    NSData *resData = [NSData dataWithBytes:encData length:blockSize];
    return resData.base64EncodedString;
}

- (NSString *)pinyin {
    //转成可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为小写拼音
    NSString *pinyin = [str lowercaseString];
    return pinyin;
}

- (NSInteger)levenshteinDistanceToString:(NSString *)string {
    NSUInteger height = self.length + 1;
    NSUInteger width = string.length + 1;
    NSMutableArray *distance = [[NSMutableArray alloc] initWithCapacity:width * height];
    NSUInteger      x, y, cost;

    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            distance[y * width + x] = @(0);
        }
    }
    for (y = 0; y < height; y++) {
        distance[y * width + 0] = @(y);
    }
    for (x = 0; x < width; x++) {
        distance[x] = @(x);
    }

    for (y = 1; y < height; y++) {
        for (x = 1; x < width; x++) {
            unichar c1 = [self characterAtIndex:y - 1];
            unichar c2 = [string characterAtIndex:x - 1];
            cost = c1 == c2 ? 0 : 1;

            NSUInteger insert  = ((NSNumber *) distance[(y - 1) * width + x]).integerValue + 1;
            NSUInteger remove  = ((NSNumber *) distance[y * width + x - 1]).integerValue + 1;
            NSUInteger replace = ((NSNumber *) distance[(y - 1) * width + x - 1]).integerValue + cost;
            distance[y * width + x] = @(MIN(MIN(insert, remove), replace) );
        }
    }

    return ((NSNumber *) distance[height * width - 1]).integerValue;
}

@end
