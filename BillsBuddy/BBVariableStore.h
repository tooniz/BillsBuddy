//
//  BBVariableStore.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "EqpSingleton.h"

#define VAR_STORE (BBVariableStore *)[BBVariableStore sharedInstance]

@interface BBVariableStore : EqpSingleton

@property (nonatomic) NSUInteger totalCount;

@end
