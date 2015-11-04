//
//  AppDelegate.m
//  ITRAirSideMenu
//
//  Created by kirthi on 11/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import "AppDelegate.h"
#import "ITRFirstViewController.h"
#import "ITRLeftMenuController.h"
#import "AFNetworkActivityIndicatorManager.h" //show activityIndicator
#import "AppViewController.h"
#import "TaxiCollectionViewController.h"
#import <Parse/Parse.h>
#import "StorePFQueryVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()<ITRAirSideMenuDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
        // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Parse setApplicationId:@"s6bYtW529EN7R75BrlT5DdasvpYBZTsvjy9axapd"
                  clientKey:@"iEd6tov1HeXrbTFOcRuczDEVJzFNcNImPRAx8a0x"];

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    //sidemenu created with content view controller & menu view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[AppViewController controller]];
    ITRLeftMenuController *leftMenuViewController = [ITRLeftMenuController controller];
    _itrAirSideMenu = [[ITRAirSideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController];

    _itrAirSideMenu.backgroundImage = [UIImage imageNamed:@"menu_bg"];
    
    //optional delegate to receive menu view status
    _itrAirSideMenu.delegate = self;
    
    //content view shadow properties
    _itrAirSideMenu.contentViewShadowColor = [UIColor clearColor];
    _itrAirSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _itrAirSideMenu.contentViewShadowOpacity = 0.6;
    _itrAirSideMenu.contentViewShadowRadius = 12;
    _itrAirSideMenu.contentViewShadowEnabled = YES;
    
    //content view animation properties
    _itrAirSideMenu.contentViewScaleValue = 0.8f;
    _itrAirSideMenu.contentViewRotatingAngle = 30.0f;
    _itrAirSideMenu.contentViewTranslateX = 50.0f;
    
    //menu view properties
    _itrAirSideMenu.menuViewRotatingAngle = 30.0f;
    _itrAirSideMenu.menuViewTranslateX = 130.0f;
    
    self.window.rootViewController = _itrAirSideMenu;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES; //show activity indicator

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark ITRAirSideMenu Delegate

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
