//
//  AppDelegate.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AppHelper.h"
#import <CoreLocation/CoreLocation.h>
#import <ParseUI/ParseUI.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
// User Location
@property CLLocationManager* locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize Parse.
    [Parse setApplicationId:@"0R6LwrHMNcPYkNbXZ7Opm6W34am82n0x2r49Xhg0"
                  clientKey:@"vLSh8NnLzqIvrF8FFIs3KczyIBF8PX6mJo7NzUeF"];
    [PFImageView class];
    
    [AppHelper logInColor:@"Next Big Thing is here"];
    
    // Appearance Tint
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[AppHelper customOrange]];
    [[UINavigationBar appearance] setBarTintColor:[AppHelper customOrange]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Get Location
    
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
