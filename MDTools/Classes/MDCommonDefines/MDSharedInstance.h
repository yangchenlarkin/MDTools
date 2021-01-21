//
//  ARSharedInstance.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/6/28.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#ifndef ARSharedInstance_h
#define ARSharedInstance_h

#define __SHARED_INSTANCE_HEADER__(__CLASS__) \
+ (__CLASS__ *)sharedInstance;


#define __SHARED_INSTANCE_DEFINE__(__CLASS__, __CODE__) \
+ (__CLASS__ *)sharedInstance { \
static __CLASS__ *instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
{ \
__CODE__ \
} \
}); \
return instance; \
}

#define __SHARED_INSTANCE__(__CLASS__) \
__SHARED_INSTANCE_DEFINE__(__CLASS__, instance = [[__CLASS__ alloc] init];)


#endif /* ARSharedInstance_h */
