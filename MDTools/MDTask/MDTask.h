//
//  MDTask.h
//  MDTools
//
//  Created by Larkin Yang on 2017/6/27.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSError *MDTaskDefaultError;

@class MDTask;

typedef void (^MDTaskFinish)(__kindof MDTask *task, NSError *error, id result);
typedef void (^MDTaskCancelBlock)(MDTask *task);
typedef id (^MDTaskInputProxy)(NSString *taskId);

//inputProxy(nil) == inputProxy(task.taskId)
typedef void (^MDTaskBlock)(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish);
typedef void (^MDTaskFailBlock)(MDTask *task, NSUInteger tryCount, void (^retry)(BOOL retry));

typedef id (^MDTaskResultProxy)(NSString *taskId);
//resultProxy(nil) == resultProxy(task.taskId)
typedef void (^MDTaskFinishResult)(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy);

@interface MDTask : NSObject

@property (nonatomic, readonly) NSString *taskId;//TODO: 需要保证唯一性

//需要在适当的时候手动调用finish()

+ (MDTask *)task:(MDTaskBlock)taskBlock;
+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel;
+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel taskFailBlock:(MDTaskFailBlock)fail;

+ (MDTask *)task:(MDTaskBlock)taskBlock
      withTaskId:(NSString *)taskId;
+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel
      withTaskId:(NSString *)taskId;
+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel
   taskFailBlock:(MDTaskFailBlock)fail
      withTaskId:(NSString *)taskId;

- (BOOL)runWithInput:(id)input
        finishResult:(MDTaskFinishResult)finishResult;
- (BOOL)runWithFinishResult:(MDTaskFinishResult)finishResult;

@end



//并发任务
@interface MDTaskGroup : MDTask

@property (nonatomic, readonly) NSUInteger count;

+ (MDTaskGroup *)taskGroup;
+ (MDTaskGroup *)taskGroupWithTasks:(MDTask *)task, ...;
- (BOOL)addTask:(__kindof MDTask *)task;

- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock;
- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock
              taskId:(NSString *)taskId;
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
- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock
              taskId:(NSString *)taskId;
/*
 if the tasks are running, they will be removed after the running is finished
 */
- (void)removeTasks;

@end
