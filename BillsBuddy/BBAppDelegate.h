//
//  BBAppDelegate.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_DELEGATE_TYPE BBAppDelegate

@interface BBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

- (void)saveContext;
- (NSArray*)getAllRecords;

@end
