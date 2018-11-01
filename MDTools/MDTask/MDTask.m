//
//  MDTask.m
//  mobi-app
//
//  Created by Larkin Yang on 2017/6/27.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import "MDTask.h"

@interface MDTask () {
    @protected
    MDTaskCancelBlock _taskCancelBlock;
}

@property (nonatomic, copy) MDTaskFinish finish;
@property (nonatomic, copy) MDTaskBlock taskBlock;
@property (nonatomic, copy) MDTaskCancelBlock taskCancelBlock;
@property (nonatomic, copy) MDTaskFailBlock taskFailBlock;
@property (nonatomic, assign) NSUInteger tryCount;

@end

@implementation MDTask

+ (NSMutableSet *)runningTasks {
    static NSMutableSet *tasks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [NSMutableSet set];
    });
    return tasks;
}

- (MDTaskFinish)finish {
    if (!_finish) {
        __weak typeof(self) selfWeak = self;
        _finish = ^(MDTask *task, BOOL succeed){
            typeof(selfWeak) self = selfWeak;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MDTask runningTasks] removeObject:self];
            });
        };
    }
    return _finish;
}

- (MDTaskCancelBlock)taskCancelBlock {
    if (!_taskCancelBlock) {
        _taskCancelBlock = ^(MDTask *task){};
    }
    return _taskCancelBlock;
}

+ (MDTask *)task:(MDTaskBlock)taskBlock {
    return [self task:taskBlock cancelBlock:NULL taskFailBlock:NULL];
}

+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel {
    return [self task:taskBlock cancelBlock:cancel taskFailBlock:NULL];
}

+ (MDTask *)task:(MDTaskBlock)taskBlock cancelBlock:(MDTaskCancelBlock)cancel taskFailBlock:(MDTaskFailBlock)fail {
    if (!taskBlock) {
        return nil;
    }
    MDTask *t = [[MDTask alloc] init];
    t.taskCancelBlock = cancel;
    t.taskBlock = taskBlock;
    t.taskFailBlock = fail;
    return t;
}

- (BOOL)runWithFinish:(MDTaskFinish)finish {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    __weak typeof(self) selfWeak = self;
    self.finish = ^(MDTask *task, BOOL succeed) {
        typeof(selfWeak) self = selfWeak;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MDTask runningTasks] removeObject:self];
        });
        if (!succeed && self.taskFailBlock) {
            self.taskFailBlock(self, self.tryCount, ^(BOOL retry) {
                typeof(selfWeak) self = selfWeak;
                if (retry) {
                    [self runWithFinish:finish];
                } else {
                    finish(task, succeed);
                }
            });
        } else {
            finish(task, succeed);
        }
    };
    if (self.taskBlock) {
        self.tryCount++;
        self.taskBlock(self, self.finish);
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

- (BOOL)runWithFinish:(MDTaskFinish)finish {
    if (self.isRunning) {
        return NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    self.finished = 0;
    self.isRunning = YES;
    self.finish = finish;
    
    if (self.tasks.count == 0) {
        [self finishRunningWithSucceed:YES];
        return YES;
    }
    
    __weak typeof(self) selfWeak = self;
    [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
            typeof(selfWeak) self = selfWeak;
            if (!self.isRunning) {
                return;
            }
            if (!succeed) {
                [self finishRunningWithSucceed:NO];
                return;
            }
            self.finished++;
            if (self.finished == self.tasks.count) {
                [self finishRunningWithSucceed:YES];
            }
        }];
    }];
    
    return YES;
}

- (void)finishRunningWithSucceed:(BOOL)succeed {
    self.finished = 0;
    self.isRunning = NO;
    if (!succeed) {
        [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.taskCancelBlock(obj);
        }];
    }
    if (self.removeTasksAfterRunning) {
        self.removeTasksAfterRunning = NO;
        [self.tasks removeAllObjects];
    }
    if (self.finish) {
        self.finish(self, succeed);
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

- (BOOL)runWithFinish:(MDTaskFinish)finish {
    if (self.isRunning) {
        return NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDTask runningTasks] addObject:self];
    });
    self.runningTaskIndex = 0;
    self.isRunning = YES;
    self.finish = finish;
    
    [self runNext];
    
    return YES;
}

- (void)runNext {
    if (self.runningTaskIndex >= self.tasks.count) {
        [self finishRunningWithSucceed:YES];
        return;
    }
    
    MDTask *t = self.tasks[self.runningTaskIndex];
    __weak typeof(self) selfWeak = self;
    [t runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        typeof(selfWeak) self = selfWeak;
        if (!succeed) {
            [self finishRunningWithSucceed:NO];
            return;
        }
        self.runningTaskIndex++;
        [self runNext];
    }];
}

- (void)finishRunningWithSucceed:(BOOL)succeed {
    self.runningTaskIndex = 0;
    self.isRunning = NO;
    if (!succeed) {
        [self.tasks enumerateObjectsUsingBlock:^(__kindof MDTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.taskCancelBlock(obj);
        }];
    }
    if (self.removeTasksAfterRunning) {
        self.removeTasksAfterRunning = NO;
        [self.tasks removeAllObjects];
    }
    if (self.finish) {
        self.finish(self, succeed);
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
