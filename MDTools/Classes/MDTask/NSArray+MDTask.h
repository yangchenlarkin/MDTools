//
//  NSArray+MDTask.h
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MDArrayObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj, NSUInteger idx);
typedef NSString *_Nullable(^MDArrayObjectTaskId)(id _Nonnull obj, NSUInteger idx);

@interface NSArray (MDTask)

- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDArrayObjectTaskBlock _Nonnull)objectTask;
- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDArrayObjectTaskBlock _Nonnull)objectTask
                                      taskIdForIndex:(MDArrayObjectTaskId _Nullable )taskIdForIndex;

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDArrayObjectTaskBlock _Nonnull)objectTask;
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDArrayObjectTaskBlock _Nonnull)objectTask
                                   taskIdForIndex:(MDArrayObjectTaskId _Nullable )taskIdForIndex;

@end
