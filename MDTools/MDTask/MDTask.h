//
//  MDTask.h
//  mobi-app
//
//  Created by Larkin Yang on 2017/6/27.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDTask;

typedef void (^MDTaskFinish)(__kindof MDTask *task, BOOL succeed);
typedef void (^MDTaskCancelBlock)(MDTask *task);
typedef void (^MDTaskBlock)(MDTask *task, MDTaskFinish finish);
typedef void (^MDTaskFailBlock)(MDTask *task, NSUInteger tryCount, void (^retry)(BOOL retry));

@interface MDTask : NSObject

@property (nonatomic, copy) NSString *tag;

//需要在适当的时候手动调用finish()
+ (MDTask *)task:(MDTaskBlock)taskBlock;
+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel;
+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel taskFailBlock:(MDTaskFailBlock)fail;
- (BOOL)runWithFinish:(MDTaskFinish)finish;

@end



//并发任务
@interface MDTaskGroup : MDTask

@property (nonatomic, readonly) NSUInteger count;

+ (MDTaskGroup *)taskGroup;
+ (MDTaskGroup *)taskGroupWithTasks:(MDTask *)task, ...;
- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock;
- (BOOL)addTask:(__kindof MDTask *)task;
/*
 if the tasks are running, they will be removed after the running is finished
 */
- (void)removeTasks;

@end



//顺序任务
@interface MDTaskList : MDTask

@property (nonatomic, readonly) NSUInteger count;

+ (MDTaskList *)taskList;
+ (MDTaskList *)taskListWithTasks:(MDTask *)task, ...;
- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock;
- (BOOL)addTask:(__kindof MDTask *)task;
/*
 if the tasks are running, they will be removed after the running is finished
 */
- (void)removeTasks;

@end
