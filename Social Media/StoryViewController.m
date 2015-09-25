//
//  SecondViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "StoryViewController.h"
#import "FVCustomAlertView.h"
#import "AppHelper.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

- (void) viewDidAppear:(BOOL)animated{
    
    [AppHelper logInColor:@"Story Did Appear"];
    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"Done" withBlur:YES allowTap:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
