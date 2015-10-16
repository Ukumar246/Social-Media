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
    [super viewWillAppear:animated];
    
    // Auto direct to Capture Page
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        self.selectedIndex = 1;
    });
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]== nil) {
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Get User Location
    [AppHelper updateUserLocation];
}

@end
