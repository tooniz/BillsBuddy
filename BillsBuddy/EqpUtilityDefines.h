//
//  EqpUtilityDefines.h
//
//  Created by Tony Zhou on 11/10/13.
//  Copyright (c) 2013 Tony Zhou. All rights reserved.
//

#ifndef EqpUtilityDefines_h
#define EqpUtilityDefines_h

// Maro: Utility Defines
//
#pragma mark - Utility Defines

#define StringGen(text, ...) [NSString stringWithFormat:text, ##__VA_ARGS__]

#define DLog(desc, ...) \
    NSLog((@"[DEBUG] %s :%d \n" desc), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifndef DEBUG
    #define DLog(desc, ...)
#endif

#define DAssert(cond, desc, ...) \
    NSAssert(cond, (@"[ASSERT] %s :%d \n " desc), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifndef DEBUG
    #define DAssert(cond, desc, ...)
#endif

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB(R,G,B) [UIColor colorWithRed:(float)(R)/255.0 green:(float)(G)/255.0 blue:(float)(B)/255.0 alpha:1.0]
#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define APP_DELEGATE (APP_DELEGATE_TYPE *)[[UIApplication sharedApplication] delegate]

#define IS_RETINA_4 ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 && [[UIScreen mainScreen] bounds].size.height > 480)

// Macro: Automation Macros
//
#pragma mark - Automation Macros

#define EQP_SINGLETON_BEGIN(name) \
+ (instancetype)sharedInstance \
{ \
    static name *myInstance = nil; \
    if (nil == myInstance) { \
        myInstance  = [[[self class] alloc] init]; \
    } \
    return myInstance; \
} \
\
- (id)automation:(AutomationAction_E)action { \
    NSMutableArray *sprintArray = [[NSMutableArray alloc] init]; \
    
#define EQP_SINGLETON_END \
    switch (action) { \
        case AUTO_INIT: \
            return NULL; \
            break; \
        case AUTO_PRINT: \
            return [sprintArray componentsJoinedByString:@"\n"]; \
            break; \
        default: \
            break; \
    } \
}

#define EQP_FIELD_ENUM(var, init) \
switch (action) { \
    case AUTO_INIT: \
        self.var = init; \
    case AUTO_PRINT: \
        [sprintArray addObject:[NSString stringWithFormat:@" %s = %d", #var, (int)self.var]]; \
}


#define EQP_FIELD_INT(var, init) \
switch (action) { \
    case AUTO_INIT: \
        self.var = init; \
    case AUTO_PRINT: \
        [sprintArray addObject:[NSString stringWithFormat:@" %s = %d", #var, (int)self.var]]; \
}

#define EQP_FIELD_STRING(var, init) \
switch (action) { \
    case AUTO_INIT: \
        self.var = init; \
    case AUTO_PRINT: \
        [sprintArray addObject:[NSString stringWithFormat:@" %s = %@", #var, self.var]]; \
}

#define EQP_FIELD_OBJECT(var, init) \
switch (action) { \
    case AUTO_INIT: \
        self.var = init; \
    case AUTO_PRINT: \
        [sprintArray addObject:[NSString stringWithFormat:@" %s = %@", #var, self.var.description]]; \
}

// Enum: Enum Types
//
#pragma mark - Enum Types

typedef NS_OPTIONS(NSUInteger, AutomationAction_E) {
    AUTO_INIT,
    AUTO_PRINT
};

#endif
