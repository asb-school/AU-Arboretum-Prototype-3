//
//  AppDelegate.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/11/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "AppDelegate.h"


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation AppDelegate


// --------------------------------------------------------------
// APPLICATION DID FINISH LAUNCHING

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Get a reference to the main storyboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	
	// Setup two view controllers, one for the search UI and one for the main content
	UIViewController *left = [mainStoryboard instantiateViewControllerWithIdentifier:@"search"];
	UIViewController *mainMenu = [mainStoryboard instantiateViewControllerWithIdentifier:@"navCtrl"];

	// Setup our split/slide view controller with the two previously defined controllers
	IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:mainMenu leftViewController:left];
	
	// Set the size of the left pane
	deckController.leftSize = 490;
	
	// Disallow user from sliding left pane with a gesture (because we have a map we need to slide instead)
	deckController.panningMode = IIViewDeckNoPanning;

	// Apply the new split/slide view controller to the main root view controller
	self.window.rootViewController = deckController;

    return YES;
}


// --------------------------------------------------------------
// APPLICATION WILL RESIGN ACTIVE
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


// --------------------------------------------------------------
// APPLICATION DID ENTER BACKGROUND

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


// --------------------------------------------------------------
// APPLICATION WILL ENTER FOREGROUND

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


// --------------------------------------------------------------
// APPLICATION DID BECOME ACTIVE

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


// --------------------------------------------------------------
// APPLICATION WILL TERMINATE

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
