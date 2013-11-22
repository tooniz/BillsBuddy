//
//  BBVariableStore.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBVariableStore.h"

@implementation BBVariableStore

EQP_SINGLETON_BEGIN(BBVariableStore)
EQP_FIELD_INT(totalCount, 0)
EQP_SINGLETON_END

-(NSUInteger) totalCount {
    return _totalCount;
}

@end
