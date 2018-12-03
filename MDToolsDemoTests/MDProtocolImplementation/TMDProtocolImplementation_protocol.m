//
//  TMDProtocolImplementation_protocol.m
//  MDToolsDemoTests
//
//  Created by Larkin Yang on 2018/12/3.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "TMDProtocolImplementation_protocol.h"

@implementationProtocol(TMDProtocolImplementation_protocol)

- (NSString *)testMethod {
    return [self.class description];
}

@end
