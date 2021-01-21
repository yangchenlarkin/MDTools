//
//  MDARC.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/6/28.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#ifndef MDARC_h
#define MDARC_h


#define MDWeakify(__T__) \
__weak typeof(__T__) __weak__##__T__ = __T__;

#define MDStrongify(__T__) \
typeof(__weak__##__T__) __T__ = __weak__##__T__


#endif /* MDARC_h */
