//
//  BBSidePanelController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBSidePanelController.h"
#import "BBCenterViewController.h"

@interface BBSidePanelController ()

@end

@implementation BBSidePanelController

BOOL statusBarHidden = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setLeftDrawerViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"navigationViewController"]];
    // Setup drawer interactions
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    // Setup status and navigation bar appearance
    [self setShowsStatusBarBackgroundView:YES];
    [self setStatusBarViewBackgroundColor:[VAR_STORE navBarTintColor]];
    [self initNavigationControllerRootView];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:[VAR_STORE buttonDefaultFontName] size:16.0f], NSFontAttributeName, nil] forState: UIControlStateNormal];
    [VAR_STORE setCenterViewType:CV_UPCOMING];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

#pragma mark - Callback Functions
- (void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void ( ^ ) ( BOOL ))completion {
    [super closeDrawerAnimated:animated velocity:velocity animationOptions:options completion:completion];
    [self initNavigationControllerRootView];
    [UIView beginAnimations:nil context:nil];
    [self setStatusBarViewBackgroundColor:[VAR_STORE navBarTintColor]];
    [UIView commitAnimations];
}

- (void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void ( ^ ) ( BOOL ))completion {
    [super openDrawerSide:drawerSide animated:animated velocity:velocity animationOptions:options completion:completion];
    [UIView beginAnimations:nil context:nil];
    [self setStatusBarViewBackgroundColor:[UIColor blackColor]];
    [UIView commitAnimations];
}

#pragma mark - NavigationView Setup
- (void)initNavigationControllerRootView {

// FIXME
    if ([VAR_STORE centerViewType] == CV_UPCOMING)
        [[UINavigationBar appearance] setTitleTextAttributes: @{ NSFontAttributeName: [UIFont fontWithName:[VAR_STORE navBarDefaultFontName] size:19.0f] }];
    else
        [[UINavigationBar appearance] setTitleTextAttributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:19.0f] }];

    // Setup navigation root view controller
    UINavigationController *nav = (UINavigationController *)self.centerViewController;
    BBCenterViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:centerViewController, nil];
    [nav setViewControllers:viewControllers animated:NO];
    [self placeButtonForLeftPanel];
    DLog(@"navigiationController has %d viewControllers", (int)[nav.viewControllers count])
}

#pragma mark - CenterView Setup

+ (UIImage *)defaultImage {
	static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 25, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 25, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 25, 1)] fill];
		
		[[UIColor whiteColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 25, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  25, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 25, 1)] fill];
		
		defaultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
	});
    return defaultImage;
}

- (UIBarButtonItem *)leftButtonForCenterPanel {
    return [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftDrawer)];
}


- (void)toggleLeftDrawer {
    [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

- (void)placeButtonForLeftPanel {
    if (self.leftDrawerViewController) {
        UIViewController *buttonController = self.centerViewController;
        if ([buttonController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)buttonController;
            if ([nav.viewControllers count] > 0) {
                DLog(@"rootViewController on navigationViewController found")
                buttonController = [nav.viewControllers objectAtIndex:0];
            }
        }
        if (!buttonController.navigationItem.leftBarButtonItem) {
            buttonController.navigationItem.leftBarButtonItem = [self leftButtonForCenterPanel];
        }
    }
}

@end
