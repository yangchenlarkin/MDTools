//
//  NSSet+MDTask.h
//  Mobi
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MSetObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj);
typedef void(^MSetIdxObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj, NSUInteger idx);

@interface NSSet (MDTask)

- (MDTaskGroup *_Nullable)lt_taskGroupWithObjectTask:(MSetObjectTaskBlock _Nonnull)objectTask;

- (MDTaskList *_Nonnull)lt_taskListWithObjectTask:(MSetIdxObjectTaskBlock _Nonnull)objectTask; //as the same order as allObjects

@end
