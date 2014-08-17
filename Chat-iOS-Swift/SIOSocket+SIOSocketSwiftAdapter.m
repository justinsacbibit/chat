//
//  SIOSocket+SIOSocketSwiftAdapter.m
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-08-16.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "SIOSocket+SIOSocketSwiftAdapter.h"

@implementation SIOSocket (SIOSocketSwiftAdapter)

- (void)emit:(NSString *)event message:(NSString *)message
{
    [self emit:event, message, nil];
}

- (void)on:(NSString *)event executeBlock:(void (^)(id))function
{
    [self on:event do:^(id param) {
        dispatch_async(dispatch_get_main_queue(), ^{
            function(param);
        });
    }];
}

@end
