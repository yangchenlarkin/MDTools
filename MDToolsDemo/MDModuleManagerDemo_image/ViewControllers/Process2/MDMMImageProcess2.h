//
//  MDMMImageProcess2.h
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDModuleManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDMMImageProcess2 : NSObject <MDModuleManager>

@property (nonatomic, copy) void (^didFinish)(UIImage *image);
- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
