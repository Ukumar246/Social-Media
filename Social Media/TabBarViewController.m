//
//  TabBarViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "TabBarViewController.h"
#import <Parse/Parse.h>
#import "AppHelper.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void) viewWillAppear:(BOOL)animated{
    
    // Auto direct to Capture Page
    self.selectedIndex = 0;
    
    PFUser* cUser = [PFUser currentUser];
    // No User Cached
    if (cUser == nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Get User Location
    [AppHelper logInGreenColor:@"checking location"];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
        
        // User Denied locaiton
        if (geoPoint == nil)
        {
            [AppHelper logError:@"no location found"];
            [AppHelper storeLocation:nil];
        }
        else
        {
            // Test
            NSString* disStr = [NSString stringWithFormat:@"Parse: got location:\t Lat: %f Lon: %f\nstoring..", geoPoint.latitude, geoPoint.longitude];
            [AppHelper logInColor:disStr];
            // Save
            [AppHelper storeLocation:geoPoint];
            [AppHelper logInGreenColor:@"stored location!"];
        }
    }];
}

@end
