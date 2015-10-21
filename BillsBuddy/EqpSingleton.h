//
//  EqpSingleton.h
//
//  Created by Tony Zhou on 11/11/13.
//  Copyright (c) 2013 Tony Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EqpSingleton : NSObject

+ (EqpSingleton *)sharedInstance;
- (NSString *)sprint;
- (void) initialize;
- (void) dump;

@end
