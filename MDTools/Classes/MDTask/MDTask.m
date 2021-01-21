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

+ (MDTaskInputProxy)nilObjectInputProxy {
    static MDTaskInputProxy res = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        res = ^id(NSString *taskId) {
            return nil;
        };
    });
    return res;
}

+ (MDTaskInputProxy)nilObjectFinishResultProxy {
    static MDTaskInputProxy res = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        res = ^id(NSString *taskId) {
            return nil;
        };
    });
    return res;
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
    return [self runWithInput:nil finishResult:finishResult];
}

- (BOOL)runWithInput:(id)input
        finishResult:(MDTaskFinishResult)finishResult {
    return [self runWithLastInputProxy:NULL input:input finishResult:finishResult];
}

- (BOOL)runWithLastInputProxy:(MDTaskInputProxy)inputProxy
                        input:(id)input
                 finishResult:(MDTaskFinishResult)finishResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    __weak typeof(self) selfWeak = self;
    self.finishResult = ^(MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        typeof(selfWeak) self = selfWeak;
        if (self.resultGenerator) {
            resultProxy = ^id(NSString *taskId) {
                typeof(selfWeak) self = selfWeak;
                if ([self.taskId isEqualToString:taskId] || !taskId) {
                    return self.resultGenerator(resultProxy(nil));
                }
                return resultProxy(taskId);
            };
        }
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
        MDTaskInputProxy curInputProxy = [MDTask nilObjectInputProxy];
        if (input || (inputProxy && inputProxy != [MDTask nilObjectInputProxy])) {
            curInputProxy = ^id (NSString *taskId) {
                typeof(selfWeak) self = selfWeak;
                if ([taskId isEqualToString:self.taskId] || !taskId) {
                    return input;
                }
                if (inputProxy) {
                    return inputProxy(taskId);
                }
                return nil;
            };
        }
        self.taskBlock(self, curInputProxy, ^(__kindof MDTask *task, NSError *error, id result) {
            if (!result) {
                self.finishResult(task, error, [MDTask nilObjectFinishResultProxy]);
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

- (BOOL)runWithLastInputProxy:(MDTaskInputProxy)inputProxy
                        input:(id)input
                 finishResult:(MDTaskFinishResult)finishResult {
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
    MDTaskInputProxy curInputProxy = (input || inputProxy) ? ^id (NSString *taskId) {
        typeof(selfWeak) self = selfWeak;
        if ([taskId isEqualToString:self.taskId] || !taskId) {
            return input;
        }
        
        if (inputProxy) {
            return inputProxy(taskId);
        }
        return nil;
    } : NULL;
    NSMutableDictionary <NSString *, id> *results = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count + 1];
    NSMutableDictionary <NSString *, id> *groupResult = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count];
    results[self.taskId] = ^id(NSString *taskId) {
        typeof(selfWeak) self = selfWeak;
        if ([taskId isEqualToString:self.taskId] || !taskId) {
            if (self.resultGenerator) {
                return self.resultGenerator(groupResult);
            }
            return groupResult;
        }
        return nil;
    };
    [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj runWithLastInputProxy:curInputProxy
                             input:input
                      finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
            typeof(selfWeak) self = selfWeak;
            if (!self.isRunning) {
                return;
            }
            if (resultProxy != [MDTask nilObjectFinishResultProxy]) {
                results[task.taskId] = resultProxy;
            }
            if (resultProxy(task.taskId)) {
                groupResult[task.taskId] = resultProxy(task.taskId);
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

- (void)finishRunningWithError:(NSError *)error
                       results:(NSDictionary <NSString *, MDTaskResultProxy> *)results {
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
    
    self.finishResult(self, error, results.count == 0 ? [MDTask nilObjectFinishResultProxy] : ^id (NSString *taskId) {
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

- (BOOL)runWithLastInputProxy:(MDTaskInputProxy)inputProxy
                        input:(id)input
                 finishResult:(MDTaskFinishResult)finishResult {
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
    
    __weak typeof(self) selfWeak = self;
    
    NSMutableDictionary <NSString *, MDTaskResultProxy> *results = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count + 1];
    NSMutableDictionary <NSString *, id> *listResults = [NSMutableDictionary dictionaryWithCapacity:self.tasks.count];

    results[self.taskId] = ^id(NSString *taskId) {
        typeof(selfWeak) self = selfWeak;
        if ([self.taskId isEqualToString:taskId] || !taskId) {
            if (self.resultGenerator) {
                return self.resultGenerator(listResults);
            }
            return listResults;
        }
        return nil;
    };
    
    MDTaskInputProxy curInputProxy = [MDTask nilObjectInputProxy];
    if (input || (inputProxy && inputProxy != [MDTask nilObjectInputProxy])) {
        curInputProxy = ^id (NSString *taskId) {
            typeof(selfWeak) self = selfWeak;
            if ([taskId isEqualToString:self.taskId] || !taskId) {
                return input;
            }
            if (inputProxy) {
                return inputProxy(taskId);
            }
            return nil;
        };
    }
    [self runNextWithLastInputProxy:curInputProxy input:input currentResults:results listResults:listResults];
    
    return YES;
}

- (void)runNextWithLastInputProxy:(MDTaskInputProxy)inputProxy
                            input:(id)input
                    currentResults:(NSMutableDictionary <NSString *, MDTaskResultProxy> *)results
                       listResults:(NSMutableDictionary <NSString *, id> *)listResults {
    if (self.runningTaskIndex >= self.tasks.count) {
        [self finishRunningWithError:nil results:results listResults:listResults];
        return;
    }
    
    MDTask *t = self.tasks[self.runningTaskIndex];
    __weak typeof(self) selfWeak = self;
    
    MDTaskInputProxy curInputProxy = [MDTask nilObjectInputProxy];
    if (input || (inputProxy && inputProxy != [MDTask nilObjectInputProxy])) {
        curInputProxy = ^id (NSString *taskId) {
            typeof(selfWeak) self = selfWeak;
            if ([taskId isEqualToString:self.taskId] || !taskId) {
                return input;
            }
            if (inputProxy) {
                return inputProxy(taskId);
            }
            return nil;
        };
    }
    [t runWithLastInputProxy:curInputProxy
                       input:input
                finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        typeof(selfWeak) self = selfWeak;
        if (resultProxy != [MDTask nilObjectFinishResultProxy]) {
            results[task.taskId] = resultProxy;
        }
        if (resultProxy(task.taskId)) {
            listResults[task.taskId] = resultProxy(nil);
        }
        if (error) {
            [self finishRunningWithError:error results:results listResults:listResults];
            return;
        }
        self.runningTaskIndex++;
        [self runNextWithLastInputProxy:curInputProxy
                                  input:resultProxy ? resultProxy(nil) : nil
                         currentResults:results
                            listResults:listResults];
    }];
}

- (void)finishRunningWithError:(NSError *)error
                       results:(NSMutableDictionary <NSString *, MDTaskResultProxy> *)results
                   listResults:(NSMutableDictionary <NSString *, id> *)listResults {
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
        typeof(self) selfWeak = self;
        self.finishResult(self, error, results.count == 0 ? [MDTask nilObjectFinishResultProxy] : ^id (NSString *taskId) {
            typeof(selfWeak) self = selfWeak;
            if ([self.taskId isEqualToString:taskId] || !taskId) {
                if (self.resultGenerator) {
                    return self.resultGenerator(listResults);
                }
                return listResults;
            }
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
