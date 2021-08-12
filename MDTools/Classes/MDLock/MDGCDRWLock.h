//
//  MDGCDRWLock.h
//  MDTools
//
//  Created by 杨晨 on 2021/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDGCDRWLock : NSObject

- (void)doReadWithSync:(BOOL)sync task:(void(^)(void))task;
- (void)doWriteWithSync:(BOOL)sync task:(void(^)(void))task;

@end

NS_ASSUME_NONNULL_END
