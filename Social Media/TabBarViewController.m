//
//  TabBarViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "TabBarViewController.h"
#import <Parse/Parse.h>

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void) viewWillAppear:(BOOL)animated{
    
    // No User Cached
    if ([PFUser currentUser] == nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    // Auto direct to Capture Page
    self.selectedIndex = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
