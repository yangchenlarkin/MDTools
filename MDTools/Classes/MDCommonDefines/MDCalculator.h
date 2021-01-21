//
//  MDCalculator.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/6/28.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#ifndef MDCalculator_h
#define MDCalculator_h


#define MDValueBetween(v0, v1, t) \
((1 - (t)) * (v0) + (t) * (v1))

#define MDValueInCloseRange(min, v, max) \
((min) <= (v) && (v) <= (max))

#define MDValueInOpenRange(min, v, max) \
((min) < (v) && (v) < (max))

#define MDValueInLORCRange(min, v, max) \
((min) < (v) && (v) <= (max))

#define MDValueInLCRORange(min, v, max) \
((min) <= (v) && (v) < (max))

#endif /* MDCalculator_h */
