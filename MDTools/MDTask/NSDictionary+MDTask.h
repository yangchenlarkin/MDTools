//
//  NSDictionary+MDTask.h
//  Mobi
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MDictionaryKeyObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull key, id _Nonnull obj);
typedef void(^MDictionaryIdxKeyObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull key, id _Nonnull obj, NSUInteger idx);

@interface NSDictionary (MDTask)

- (MDTaskGroup *_Nullable)lt_taskGroupWithObjectTask:(MDictionaryKeyObjectTaskBlock _Nonnull)objectTask;
- (MDTaskList *_Nonnull)lt_taskListWithObjectTask:(MDictionaryIdxKeyObjectTaskBlock _Nonnull)objectTask; //as the same order as allKeys

@end
