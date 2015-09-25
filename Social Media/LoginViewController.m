//
//  LoginViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "LoginViewController.h"
#import "FVCustomAlertView.h"
#import "AppHelper.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController ()<UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (nonatomic)       BOOL               userFound;

@end

@implementation LoginViewController{
    UIColor* customRedColor;
    
    PFGeoPoint* userLocation;
}

- (void) setUserFound:(BOOL)userFound{
    _userFound = userFound;

    if (userFound){
        [AppHelper logInColor:@"user found"];
        // Log in button
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitle:@"Nearby" forState:UIControlStateNormal];
        [_actionButton setBackgroundColor: customRedColor];
    }
    else
    {
        [AppHelper logInColor:@"user NOT found"];
        // Sign up button
        [_actionButton setTitleColor:customRedColor forState:UIControlStateNormal];
        [_actionButton setTitle:@"Create" forState:UIControlStateNormal];
        [_actionButton setBackgroundColor: [UIColor whiteColor]];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL) prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

    // Set defaults of user found to NO-- Callback wait period
    _userFound = YES;
    
    // Decor
    UIFont* font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
    customRedColor = [UIColor colorWithRed:0.93 green:0.00 blue:0.00 alpha:1.0];
    
    // Set Pattern Image
    UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackpatter"]];
    self.view.backgroundColor = patternColor;
    
    // Text Field Decor
    _username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{
                                                                           NSForegroundColorAttributeName:customRedColor,NSFontAttributeName:font
                                                                           }];
    _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{
                                                                                                          NSForegroundColorAttributeName:customRedColor,NSFontAttributeName:font
                                                                           }];
    [self addBorderToTextField:_username withColor:customRedColor];
    [self addBorderToTextField:_password withColor:customRedColor];
    
    // Button Decor
    _actionButton.layer.cornerRadius = CGRectGetWidth(_actionButton.frame)/2;
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) addBorderToTextField:(UITextField*) tf withColor:(UIColor*) color
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, tf.frame.size.height - 1, tf.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [tf.layer addSublayer:bottomBorder];
}

#pragma mark - Action Methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_username]) {
        [AppHelper logInBlueColor:@"checking email..."];
        
        [self checkUserStatus:nil];
    }
    if ([textField isEqual:_password]) {
        [AppHelper logInBlueColor:@"password done editing"];
    }
}

- (IBAction)actionButton:(UIButton *)sender {
    
    if (_username.text == nil || _password.text == nil || [_username.text isEqualToString:@""] || [_password.text isEqualToString:@""]) {
        
        [AppHelper logError:@"empty tfs"];
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"Empty Fields" withBlur:YES allowTap:YES];
        
        return;
    }
    
    // Hide Loading Alert
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    // Launch Alert
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"Checking Location..." withBlur:YES allowTap:YES];
    
    // Get Location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
        
        // Hide Loading Alert
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        
        // User Denied locaiton
        if (geoPoint == nil)
        {
            [AppHelper logError:@"no location found"];
            [AppHelper storeLocation:nil];
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"Location required to continue" withBlur:YES allowTap:YES];
        }
        else
        {
            // Test
            NSString* disStr = [NSString stringWithFormat:@"Parse: got location:\t Lat: %f Lon: %f\nstoring..", geoPoint.latitude, geoPoint.longitude];
            [AppHelper logInColor:disStr];
            // Save
            [AppHelper storeLocation:geoPoint];
            [AppHelper logInGreenColor:@"stored location!\nAction..."];
            
            // Action
            if (self.userFound)
                [self loginUser];
            else
                [self signupUser];

        }
    }];
    
}

#pragma mark - Parse Calls
- (IBAction)checkUserStatus:(id)sender{
    
    PFQuery* userQuery = [PFUser query];
    [userQuery whereKey:@"email" equalTo:_username.text];   // Check by username
    
    [userQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error) {
            if (number > 0) {
                // User found
                self.userFound = YES;
            }
            else{
                self.userFound = NO;
            }
        }
    }];
}

- (void) signupUser
{
    // Base Case
    if (_username.text == nil || _password.text == nil || [_username.text isEqualToString:@""] || [_password.text isEqualToString:@""]) {
        
        [AppHelper logError:@"empty tfs"];
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"Empty Fields" withBlur:YES allowTap:YES];
        
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = _username.text;
    user.password = _password.text;
    user.email = _username.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [AppHelper logInGreenColor:@"succesfully logged in user"];
            [self performSegueWithIdentifier:@"Segue_start" sender:self];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            errorString = [NSString stringWithFormat:@"Error: %@", errorString];
            // Show alert
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:[errorString uppercaseString] withBlur:YES allowTap:YES];
        }
    }];
}

- (void) loginUser
{
    // Base Case
    if (_username.text == nil || _password.text == nil || [_username.text isEqualToString:@""] || [_password.text isEqualToString:@""]) {
        
        [AppHelper logError:@"empty tfs"];
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"Empty Fields" withBlur:YES allowTap:YES];

        return;
    }
    
    // Login User
    [PFUser logInWithUsernameInBackground:_username.text password:_password.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error && user != nil) {
            [AppHelper logInGreenColor:@"succesfully logged in user"];
            [self performSegueWithIdentifier:@"Segue_start" sender:self];
        }
        else{
            [AppHelper logInGreenColor:@"Error logging in user:\t"];
             NSString *errorString = [error userInfo][@"error"];
            [AppHelper logInGreenColor:errorString];
            
            // Show Alert
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:[NSString stringWithFormat:@"Error: %@", errorString] withBlur:YES allowTap:YES];
        }
    }];
}

@end
