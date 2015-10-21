//
//  EqpSingleton.m
//
//  Created by Tony Zhou on 11/11/13.
//  Copyright (c) 2013 Tony Zhou. All rights reserved.
//

#import "EqpSingleton.h"

@implementation EqpSingleton

+ (instancetype)sharedInstance
{
    return NULL;
}

- (NSString *)sprint {
    return (NSString *)[self automation:AUTO_PRINT];
}

- (void) initialize {
    [self automation:AUTO_INIT];
    DLog(@"Initializing Variable Store:\n%@", [self sprint])
}

- (void) dump {
    DLog(@"Dump of Variable Store:\n%@", [self sprint])
}

- (id)automation:(AutomationAction_E)action {
    return NULL;
}
    
@end
