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
    
    // Set Pattern Image Random
//    int r = arc4random_uniform(2);
//    NSString* imgIdentifier = [NSString stringWithFormat:@"Texture%d", r];
//    UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgIdentifier]];
//    self.view.backgroundColor = patternColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Texture2"]];
    self.view.backgroundColor = patternColor;
}

@end
