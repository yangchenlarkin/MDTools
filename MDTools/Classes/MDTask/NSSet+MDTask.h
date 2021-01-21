//
//  NSSet+MDTask.h
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MDSetObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj);
typedef void(^MDSetIdxObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj, NSUInteger idx);

typedef NSString *_Nullable(^MDSetTaskIdForObject)(id _Nonnull obj);
typedef NSString *_Nullable(^MDSetTaskIdForIdxObject)(id _Nonnull obj, NSUInteger idx);

@interface NSSet (MDTask)

- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDSetObjectTaskBlock _Nonnull)objectTask;
- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDSetObjectTaskBlock _Nonnull)objectTask
                                     taskIdForObject:(MDSetTaskIdForObject _Nullable)taskIdForObject;

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDSetIdxObjectTaskBlock _Nonnull)objectTask; //as the same order as allObjects
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDSetIdxObjectTaskBlock _Nonnull)objectTask
                               taskIdForIdxObject:(MDSetTaskIdForIdxObject _Nullable)taskIdForIdxObject; //as the same order as allObjects

@end
