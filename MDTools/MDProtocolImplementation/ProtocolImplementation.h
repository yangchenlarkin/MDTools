//
//  ProtocolImplementation.h
//  MVVMsDemo
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __ImplementationClassName__(__ProtocolName__) _##__ProtocolName__##_Implementation



#define interfaceProtocol(__ProtocolName__) \
interface __ImplementationClassName__(__ProtocolName__) : NSObject <__ProtocolName__>

#define interfaceProtocol_(__ProtocolName__, __SuperProtocolName__) \
interface __ImplementationClassName__(__ProtocolName__) : __ImplementationClassName__(__SuperProtocolName__) <__ProtocolName__>



#define implementationProtocol(__ProtocolName__) \
interfaceProtocol(__ProtocolName__) \
@end \
@implementation __ImplementationClassName__(__ProtocolName__)

#define implementationProtocol_(__ProtocolName__, __SuperProtocolName__) \
interfaceProtocol_(__ProtocolName__, __SuperProtocolName__) \
@end \
@implementation __ImplementationClassName__(__ProtocolName__)


#define endProtocol(__ProtocolName__) \
end

#define __ImplementationProtocol__ \
+ (void)initialize { \
__ImplementationProtocol__in__initialize \
}

#define __ImplementationProtocol__in__initialize \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_append_default_implement_method_to_class_implementation_class(self); \
});

void _append_default_implement_method_to_class_implementation_class(Class c);
