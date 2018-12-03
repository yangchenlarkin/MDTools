//
//  NSArray+MDTask.h
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

typedef void(^MArrayObjectTaskBlock)(MDTask * _Nonnull task, MDTaskFinish _Nonnull finish, id _Nonnull obj, NSUInteger idx);

@interface NSArray (MDTask)

- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MArrayObjectTaskBlock _Nonnull)objectTask;
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MArrayObjectTaskBlock _Nonnull)objectTask;

@end
