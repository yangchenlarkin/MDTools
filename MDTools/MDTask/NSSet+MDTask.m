//
//  NSSet+MDTask.m
//  Mobi
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSSet+MDTask.h"

@implementation NSSet (MDTask)


- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MSetObjectTaskBlock _Nonnull)objectTask {
    MDTaskGroup *taskGroup = [MDTaskGroup taskGroup];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [taskGroup addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, obj);
        }];
    }];
    return taskGroup;
}

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MSetIdxObjectTaskBlock _Nonnull)objectTask {
    NSArray *allObjects = self.allObjects;
    
    MDTaskList *taskList = [MDTaskList taskList];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        [taskList addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, allObjects[idx], idx);
        }];
    }
    return taskList;
}

@end
