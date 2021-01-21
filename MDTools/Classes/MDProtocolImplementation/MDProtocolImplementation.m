//
//  MDProtocolImplementation.m
//  MDTools
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "MDProtocolImplementation.h"
#import <objc/runtime.h>

void __append_default_implement_method_to_class_implementation_class(Protocol * __unsafe_unretained *protocols, unsigned protocolCount, Class metaClass, Class class) {
    for (int j = 0; j < protocolCount; j ++) {
        Protocol *protocol = protocols[j];
        NSString *tempClassName = [NSString stringWithFormat:@"_%s_Implementation", protocol_getName(protocol)];
        Class tempClass = objc_getClass(tempClassName.UTF8String);
        
        while (tempClass) {
            unsigned methodCount;
            Method *methods = class_copyMethodList(tempClass, &methodCount);
            
            for (int k = 0; k < methodCount; k ++) {
                Method method = methods[k];
                class_addMethod(class, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
            }
            free(methods);
            
            Class metaTempClass = object_getClass(tempClass);
            unsigned metaMethodCount;
            Method *metaMethods = class_copyMethodList(metaTempClass, &metaMethodCount);
            
            for (int k = 0; k < metaMethodCount; k ++) {
                Method method = metaMethods[k];
                class_addMethod(metaClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
            }
            free(metaMethods);
            
            tempClass = class_getSuperclass(tempClass);
        }

        unsigned _protocolCount;
        Protocol * __unsafe_unretained *_protocols = protocol_copyProtocolList(protocol, &_protocolCount);
        __append_default_implement_method_to_class_implementation_class(_protocols, _protocolCount, metaClass, class);
    }
}

void _append_default_implement_method_to_class_implementation_class(Class class) {
    Class metaClass = object_getClass(class);
    
    unsigned protocolCount;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(class, &protocolCount);
    __append_default_implement_method_to_class_implementation_class(protocols, protocolCount, metaClass, class);
    free(protocols);
}

