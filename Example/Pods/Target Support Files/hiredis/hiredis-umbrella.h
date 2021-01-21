#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "async.h"
#import "dict.h"
#import "fmacros.h"
#import "hiredis.h"
#import "net.h"
#import "sds.h"

FOUNDATION_EXPORT double hiredisVersionNumber;
FOUNDATION_EXPORT const unsigned char hiredisVersionString[];

