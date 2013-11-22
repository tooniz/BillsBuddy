//
//  BBSidePanelController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBSidePanelController.h"

#import "CustomBadge.h"
#import "BBVariableStore.h"

@interface BBSidePanelController ()

@end

@implementation BBSidePanelController

BOOL statusBarHidden = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setLeftDrawerViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
    
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    [self placeButtonForLeftPanel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIImage *)defaultImage {
	static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 20, 1)] fill];
		
		[[UIColor whiteColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 20, 2)] fill];
		
		defaultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
	});
    return defaultImage;
}

- (UIBarButtonItem *)leftButtonForCenterPanel {
    return [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftDrawer)];
}


- (void)toggleLeftDrawer {
    [self openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

- (void)placeButtonForLeftPanel {
    if (self.leftDrawerViewController) {
        UIViewController *buttonController = self.centerViewController;
        if ([buttonController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)buttonController;
            if ([nav.viewControllers count] > 0) {
                buttonController = [nav.viewControllers objectAtIndex:0];
            }
        }
        if (!buttonController.navigationItem.leftBarButtonItem) {
            buttonController.navigationItem.leftBarButtonItem = [self leftButtonForCenterPanel];
        }
    }
}

@end
