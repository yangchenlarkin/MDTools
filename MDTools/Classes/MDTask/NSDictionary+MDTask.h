//
//  NSDictionary+MDTask.h
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MDDictionaryKeyObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull key, id _Nonnull obj);
typedef void(^MDDictionaryIdxKeyObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull key, id _Nonnull obj, NSUInteger idx);

typedef NSString *_Nullable(^MDDictionaryTaskIdForKey)(id _Nonnull key, id _Nonnull obj);

@interface NSDictionary (MDTask)

- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDDictionaryKeyObjectTaskBlock _Nonnull)objectTask
                                        taskIdForKey:(MDDictionaryTaskIdForKey _Nullable)taskIdForKey;
- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDDictionaryKeyObjectTaskBlock _Nonnull)objectTask;

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDDictionaryIdxKeyObjectTaskBlock _Nonnull)objectTask
                                     taskIdForKey:(MDDictionaryTaskIdForKey _Nullable)taskIdForKey;
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDDictionaryIdxKeyObjectTaskBlock _Nonnull)objectTask; //as the same order as allKeys

@end
