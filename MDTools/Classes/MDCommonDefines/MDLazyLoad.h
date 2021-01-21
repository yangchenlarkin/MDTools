//
//  MDLazyLoad.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#ifndef MDLazyLoad_h
#define MDLazyLoad_h

#define LAZY_LOAD_CODE(__CLASS__, __PROPERTY__, __CODE__) \
- (__CLASS__ *)__PROPERTY__ { \
if (!_##__PROPERTY__) { \
__CODE__ \
} \
return _##__PROPERTY__; \
}

#define LAZY_LOAD(__CLASS__, __PROPERTY__) \
LAZY_LOAD_CODE(__CLASS__, __PROPERTY__,{ \
_##__PROPERTY__ = [[__CLASS__ alloc] init]; \
})

#endif /* MDLazyLoad_h */
