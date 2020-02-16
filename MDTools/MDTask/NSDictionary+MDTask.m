//
//  NSDictionary+MDTask.m
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSDictionary+MDTask.h"

@implementation NSDictionary (MDTask)

- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDDictionaryKeyObjectTaskBlock _Nonnull)objectTask {
    return [self md_taskGroupWithObjectTask:objectTask
                               taskIdForKey:NULL];
}
- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDDictionaryKeyObjectTaskBlock _Nonnull)objectTask
                                        taskIdForKey:(MDDictionaryTaskIdForKey _Nullable)taskIdForKey {
    MDTaskGroup *taskGroup = [MDTaskGroup taskGroup];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [taskGroup addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, key, obj);
        }
                         taskId:taskIdForKey ? taskIdForKey(key, obj) : nil];
    }];
    return taskGroup;
}

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDDictionaryIdxKeyObjectTaskBlock _Nonnull)objectTask {
    return [self md_taskListWithObjectTask:objectTask
                              taskIdForKey:NULL];
}
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDDictionaryIdxKeyObjectTaskBlock _Nonnull)objectTask
                                     taskIdForKey:(MDDictionaryTaskIdForKey _Nullable)taskIdForKey {
    NSArray *allKeys = self.allKeys;
    MDTaskList *taskList = [MDTaskList taskList];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        [taskList addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, allKeys[idx], self[allKeys[idx]], idx);
        }
        taskId:taskIdForKey ? taskIdForKey(allKeys[idx], self[allKeys[idx]]) : nil];
    }
    return taskList;
}

@end
