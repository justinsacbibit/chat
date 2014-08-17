//
//  SIOSocket+SIOSocketSwiftAdapter.h
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-08-16.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "SIOSocket.h"

@interface SIOSocket (SIOSocketSwiftAdapter)

- (void)emit:(NSString *)event message:(NSString *)message;

- (void)on:(NSString *)event executeBlock:(void (^)(id))function;

@end
