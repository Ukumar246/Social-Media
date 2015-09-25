//
//  FirstViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "CaptureViewController.h"
#import <Parse/Parse.h>
#import "AppHelper.h"
#import "PictureView.h"
#import "FVCustomAlertView.h"

#define commentOriginalY 50
#define commentOffsetY 190

@interface CaptureViewController ()<CACameraSessionDelegate, UITextFieldDelegate>

@property (nonatomic,strong) CameraSessionView* cameraView;
@property (weak, nonatomic) IBOutlet PictureView *pictureView;

@end

@implementation CaptureViewController{
    UIColor* systemColor;
    UIImage* uploadImage;
}

#pragma mark - Start
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    systemColor = [UIColor colorWithRed:0.93 green:0.00 blue:0.00 alpha:1.0];
    
    [self launchCamera:nil];

}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

#pragma mark - Camera
- (IBAction)launchCamera:(id)sender
{
    // Launch Camera
    if (!_cameraView) {
        _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
        _cameraView.delegate = self;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    self.pictureView.hidden = YES;
    [self.view addSubview:_cameraView];
}

- (void) didCaptureImage:(UIImage *)image{
    [_cameraView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    uploadImage = image;
    [self loadPreview:image];
    
}

// Camera view was dismissed
- (void) didDismissCameraView{
    // Unhide tab bar
    self.tabBarController.tabBar.hidden = NO;
    
    // Give Option To Relaunch Camera
    UIButton* relaunchButton = [UIButton new];
    relaunchButton.frame = CGRectMake(55, 266, 210, 35);
}

#pragma Parse Calls
- (IBAction)postPicture:(id)sender
{
    [AppHelper logInColor:@"uploading picture.."];
    
    if (uploadImage == nil) {
        [AppHelper logError:@"fatal error: No image data!!"];
        return;
    }
    
    // UPLOAD
    
    // Alert User
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"Loading..." withBlur:YES allowTap:YES];
    
    PFObject* post = [PFObject objectWithClassName:@"Post"];
    
    if ([PFUser currentUser] != nil) {
        post[@"user"] = [PFUser currentUser];
    }
    // Save Comment
    post[@"comment"] = self.pictureView.comment.text;
    
    // Save Picure
    NSData* data = UIImagePNGRepresentation(uploadImage);
    PFFile *imageFile = [PFFile fileWithName:@"post.jpg" data:data];
    
    
    // Save the image to Parse
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Hide Loading Alert
        [FVCustomAlertView hideAlertFromView:self.view fading:NO];

        if (!error) {
            [AppHelper logInColor:@"The image has now been uploaded to Parse. Associate it with a new object"];
            // Link Photo to Upload
            [post setObject:imageFile forKey:@"picture"];
            
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [AppHelper logInGreenColor:@"saved!"];
                    
                    [FVCustomAlertView hideAlertFromView:self.view fading:NO];
                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"Done" withBlur:YES allowTap:YES];
                    [self performSelector:@selector(launchCamera:) withObject:nil afterDelay:2];
                }
                else{
                    NSString* errStr = [NSString stringWithFormat:@"Error: %@ %@", error, [error userInfo]];
                    [AppHelper logInGreenColor:errStr];

                }
            }];
        }
    }];


}

#pragma mark - Loading Views
- (void) loadPreview: (UIImage*) capturedImage
{
    // Rounded Button
    self.pictureView.uploadButton.layer.cornerRadius = CGRectGetWidth(self.pictureView.uploadButton.frame)/2;

    self.pictureView.visualEffectView.layer.cornerRadius = 8;
    self.pictureView.visualEffectView.clipsToBounds = YES;
    
    // Placeholder
    self.pictureView.comment.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"comment" attributes:@{NSForegroundColorAttributeName: systemColor}];

    // Addtional Setup
    [self.pictureView.uploadButton addTarget:self action:@selector(postPicture:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pictureView.alpha = 0;
    self.pictureView.hidden = NO;

    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pictureView.alpha = 1;
    } completion:nil];
    
    self.pictureView.imageView.image = capturedImage;
    //self.pictureView.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark - Helpers
- (IBAction)retakePicture:(UIButton *)sender {
    [self launchCamera:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength <= 50) {
        return YES;
    }
    else
        return NO;
}

@end
