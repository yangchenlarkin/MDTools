//
//  MDTask.m
//  MDTools
//
//  Created by Larkin Yang on 2017/6/27.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import "MDTask.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSError *MDTaskDefaultError;

@interface MDTask () {
    @protected
    MDTaskCancelBlock _taskCancelBlock;
}
@property (nonatomic, copy) NSString *taskId;//需要保证唯一性

@property (nonatomic, copy) MDTaskFinishResult finishResult;
@property (nonatomic, copy) MDTaskBlock taskBlock;
@property (nonatomic, copy) MDTaskCancelBlock taskCancelBlock;
@property (nonatomic, copy) MDTaskFailBlock taskFailBlock;
@property (nonatomic, assign) NSUInteger tryCount;

@end

@implementation MDTask

+ (void)load {
    MDTaskDefaultError = [NSError errorWithDomain:@"MDTools.MDTask.DefaultError" code:0 userInfo:nil];
}

+ (NSMutableSet *)runningTasks {
    static NSMutableSet *tasks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [NSMutableSet set];
    });
    return tasks;
}

- (NSString *)taskId {
    @synchronized (self) {
        if (!_taskId) {
            static NSUInteger _taskIdPrefix = 0;
            static NSUInteger _taskIdCount = 0;
            static NSUInteger _taskIdSufix = 0;
            _taskId = [NSString stringWithFormat:@"%lu_%lu_%lu",
                       (unsigned long)_taskIdPrefix,
                       (unsigned long)_taskIdCount,
                       (unsigned long)_taskIdSufix];
            if (++_taskIdSufix == 0 && ++_taskIdCount == 0) {
                ++_taskIdPrefix;
            }
        }
    }
    return _taskId;
}

- (MDTaskFinishResult)finishResult {
    @synchronized (self) {
        if (!_finishResult) {
            __weak typeof(self) selfWeak = self;
            _finishResult = ^(MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
                typeof(selfWeak) self = selfWeak;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MDTask runningTasks] removeObject:self];
                });
            };
        }
    }
    return _finishResult;
}

- (MDTaskCancelBlock)taskCancelBlock {
    if (!_taskCancelBlock) {
        _taskCancelBlock = ^(MDTask *task){};
    }
    return _taskCancelBlock;
}

+ (MDTask *)task:(MDTaskBlock)taskBlock {
    return [self task:taskBlock
          cancelBlock:NULL
        taskFailBlock:NULL
           withTaskId:nil];
}

+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel {
    return [self task:taskBlock
          cancelBlock:cancel
        taskFailBlock:NULL
           withTaskId:nil];
}

+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel
   taskFailBlock:(MDTaskFailBlock)fail {
    return [self task:taskBlock
          cancelBlock:cancel
        taskFailBlock:fail
           withTaskId:nil];
}
+ (MDTask *)task:(MDTaskBlock)taskBlock withTaskId:(NSString *)taskId {
    return [self task:taskBlock
          cancelBlock:NULL
        taskFailBlock:NULL
           withTaskId:taskId];
}

+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel withTaskId:(NSString *)taskId {
    return [self task:taskBlock
          cancelBlock:cancel
        taskFailBlock:NULL
           withTaskId:taskId];
}
+ (MDTask *)task:(MDTaskBlock)taskBlock
     cancelBlock:(MDTaskCancelBlock)cancel
   taskFailBlock:(MDTaskFailBlock)fail
      withTaskId:(NSString *)taskId {
    if (!taskBlock) {
        return nil;
    }
    MDTask *t = [[MDTask alloc] init];
    t.taskId = taskId;
    t.taskCancelBlock = cancel;
    t.taskBlock = taskBlock;
    t.taskFailBlock = fail;
    return t;
}

- (BOOL)runWithFinishResult:(MDTaskFinishResult)finishResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    __weak typeof(self) selfWeak = self;
    self.finishResult = ^(MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        typeof(selfWeak) self = selfWeak;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MDTask runningTasks] removeObject:self];
        });
        if (error && self.taskFailBlock) {
            self.taskFailBlock(self, self.tryCount, ^(BOOL retry) {
                typeof(selfWeak) self = selfWeak;
                if (retry) {
                    [self runWithFinishResult:finishResult];
                } else {
                    finishResult(task, error, resultProxy);
                }
            });
        } else {
            finishResult(task, error, resultProxy);
        }
    };
    if (self.taskBlock) {
        self.tryCount++;
        __weak typeof(self) selfWeak = self;
        self.taskBlock(self, ^(__kindof MDTask *task, NSError *error, id result) {
            if (!result) {
                self.finishResult(task, error, NULL);
                return;
            }
            typeof(selfWeak) self = selfWeak;
            MDTaskResultProxy resultProxy = ^id (NSString *taskId) {
                if (!taskId) {
                    return result;
                }
                if ([taskId isEqualToString:self.taskId]) {
                    return result;
                }
                return nil;
            };
            self.finishResult(task, error, resultProxy);
        });
        return YES;
    }
    return NO;
}

@end



@interface MDTaskGroup ()

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSUInteger finished;
@property (nonatomic, strong) NSMutableSet<__kindof MDTask *> *tasks;
@property (nonatomic, assign) BOOL removeTasksAfterRunning;

@end

@implementation MDTaskGroup

- (NSUInteger)count {
    return self.tasks.count;
}

- (NSMutableSet *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableSet set];
    }
    return _tasks;
}

+ (MDTaskGroup *)taskGroup {
    return [[MDTaskGroup alloc] init];
}

+ (MDTaskGroup *)taskGroupWithTasks:(MDTask *)task, ... {
    MDTaskGroup *t = [MDTaskGroup taskGroup];
    va_list ap;
    va_start(ap, task);
    t.tasks = [NSMutableSet setWithObject:task];
    MDTask *ts = nil;
    while ((ts = va_arg(ap, MDTask *))) {
        [t.tasks addObject:ts];
    }
    va_end(ap);
    return t;
}

- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock {
    return [self addTask:[MDTask task:taskBlock]];
}

- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock taskId:(NSString *)taskId {
    return [self addTask:[MDTask task:taskBlock withTaskId:taskId]];
}

- (BOOL)addTask:(__kindof MDTask *)task {
    if (!task) {
        return NO;
    }
    if (!self.isRunning) {
        [self.tasks addObject:task];
        return YES;
    }
    return NO;
}

- (BOOL)runWithFinishResult:(MDTaskFinishResult)finishResult {
    @synchronized (self) {
        if (self.isRunning) {
            return NO;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    self.finished = 0;
    self.isRunning = YES;
    self.finishResult = finishResult;
    
    if (self.tasks.count == 0) {
        [self finishRunningWithError:nil results:nil];
        return YES;
    }
    
    __weak typeof(self) selfWeak = self;
    NSMutableDictionary <NSString *, id> *results = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count];
    [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
            typeof(selfWeak) self = selfWeak;
            if (!self.isRunning) {
                return;
            }
            if (resultProxy) {
                results[task.taskId] = resultProxy;
            }
            if (error) {
                [self finishRunningWithError:error results:results];
                return;
            }
            self.finished++;
            if (self.finished == self.tasks.count) {
                [self finishRunningWithError:nil results:results];
            }
        }];
    }];
    
    return YES;
}

- (void)finishRunningWithError:(NSError *)error results:(NSDictionary <NSString *, id> *)results {
    self.finished = 0;
    self.isRunning = NO;
    if (error) {
        [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.taskCancelBlock(obj);
        }];
    }
    if (self.removeTasksAfterRunning) {
        self.removeTasksAfterRunning = NO;
        [self.tasks removeAllObjects];
    }
    
    self.finishResult(self, error, results.count == 0 ? NULL : ^id (NSString *taskId) {
        for (NSString *key in results) {
            MDTaskResultProxy resultProxy = results[key];
            id res = resultProxy(taskId);
            if ([key isEqualToString:taskId]) {
                return res;
            }
            if (res) {
                return res;
            }
        }
        return nil;
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] removeObject:self];
    });
}

- (void)removeTasks {
    if (self.isRunning) {
        self.removeTasksAfterRunning = YES;
        return;
    }
    [self.tasks removeAllObjects];
}

- (MDTaskCancelBlock)taskCancelBlock {
    if (!_taskCancelBlock) {
        _taskCancelBlock = ^(MDTask *taskGroup) {
            for (MDTask *task in ((MDTaskGroup *)taskGroup).tasks) {
                task.taskCancelBlock(task);
            }
        };
    }
    return _taskCancelBlock;
}

@end




@interface MDTaskList ()

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSUInteger runningTaskIndex;
@property (nonatomic, strong) NSMutableArray<__kindof MDTask *> *tasks;
@property (nonatomic, assign) BOOL removeTasksAfterRunning;

@end

@implementation MDTaskList

- (NSUInteger)count {
    return self.tasks.count;
}

- (NSMutableArray *)tasks {
    return _tasks ?: (_tasks = [NSMutableArray array]);
}

+ (MDTaskList *)taskList {
    return [[MDTaskList alloc] init];
}

+ (MDTaskList *)taskListWithTasks:(MDTask *)task, ... {
    MDTaskList *t = [MDTaskList taskList];
    va_list ap;
    va_start(ap, task);
    t.tasks = [NSMutableArray arrayWithObject:task];
    MDTask *ts = nil;
    while ((ts = va_arg(ap, MDTask *))) {
        [t.tasks addObject:ts];
    }
    va_end(ap);
    return t;
}

- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock {
    return [self addTask:[MDTask task:taskBlock]];
}

- (BOOL)addTaskBlock:(MDTaskBlock)taskBlock taskId:(NSString *)taskId {
    return [self addTask:[MDTask task:taskBlock withTaskId:taskId]];
}

- (BOOL)addTask:(__kindof MDTask *)task {
    if (!task) {
        return NO;
    }
    if (!self.isRunning) {
        [self.tasks addObject:task];
        return YES;
    }
    return NO;
}

- (BOOL)runWithFinishResult:(MDTaskFinishResult)finishResult {
    @synchronized (self) {
        if (self.isRunning) {
            return NO;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    self.runningTaskIndex = 0;
    self.isRunning = YES;
    self.finishResult = finishResult;
    
    NSMutableDictionary <NSString *, MDTaskResultProxy> *results = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count];
    [self runNextWithCurrentResults:results];
    
    return YES;
}

- (void)runNextWithCurrentResults:(NSMutableDictionary <NSString *, MDTaskResultProxy> *)results {
    if (self.runningTaskIndex >= self.tasks.count) {
        [self finishRunningWithError:nil results:results];
        return;
    }
    
    MDTask *t = self.tasks[self.runningTaskIndex];
    __weak typeof(self) selfWeak = self;
    [t runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        typeof(selfWeak) self = selfWeak;
        if (resultProxy) {
            results[task.taskId] = resultProxy;
        }
        if (error) {
            [self finishRunningWithError:error results:results];
            return;
        }
        self.runningTaskIndex++;
        [self runNextWithCurrentResults:results];
    }];
}

- (void)finishRunningWithError:(NSError *)error results:(NSMutableDictionary <NSString *, MDTaskResultProxy> *)results {
    self.runningTaskIndex = 0;
    self.isRunning = NO;
    if (error) {
        [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.taskCancelBlock(obj);
        }];
    }
    if (self.removeTasksAfterRunning) {
        self.removeTasksAfterRunning = NO;
        [self.tasks removeAllObjects];
    }
    if (self.finishResult) {
        self.finishResult(self, error, results.count == 0 ? NULL : ^id (NSString *taskId) {
            for (NSString *key in results) {
                MDTaskResultProxy resultProxy = results[key];
                id res = resultProxy(taskId);
                if ([key isEqualToString:taskId]) {
                    return res;
                }
                if (res) {
                    return res;
                }
            }
            return nil;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] removeObject:self];
    });
}

- (void)removeTasks {
    if (self.isRunning) {
        self.removeTasksAfterRunning = YES;
        return;
    }
    [self.tasks removeAllObjects];
}

- (MDTaskCancelBlock)taskCancelBlock {
    if (!_taskCancelBlock) {
        _taskCancelBlock = ^(MDTask *taskList) {
            for (MDTask *task in ((MDTaskList *)taskList).tasks) {
                task.taskCancelBlock(task);
            }
        };
    }
    return _taskCancelBlock;
}

@end
