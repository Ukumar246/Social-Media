//
//  FirstViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "CaptureViewController.h"
#define commentOriginalY 50
#define commentOffsetY 190

static CGFloat originalBrightnessValue = 0.5;
BOOL rotateImage = YES;

@interface CaptureViewController ()<CACameraSessionDelegate, UITextFieldDelegate>
@property (nonatomic,strong) CameraSessionView* cameraView;
@property (weak, nonatomic) IBOutlet PictureView *pictureView;
@property (weak, nonatomic) IBOutlet CaptureOptionsView *optionPane;

@end

@implementation CaptureViewController{
    UIColor* customOrange;
    UIColor* customWhite;
    UIImage* uploadImage;
    
    UIView* blackTransparent;
    BOOL stealthMode;
}

#pragma mark - Start
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    customOrange = [AppHelper customOrange];
    customWhite = [UIColor whiteColor];
    
    //Option Pane setup
    _optionPane.backgroundColor = [UIColor clearColor];
    _optionPane.hidden = YES;
    [_optionPane.captureButton addTarget:self action:@selector(launchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [_optionPane.storyButton addTarget:self action:@selector(showStory:) forControlEvents:UIControlEventTouchUpInside];
    [_optionPane.signoutButton addTarget:self action:@selector(signOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_optionPane.stealthSwitch addTarget:self action:@selector(toggleStealthMode:) forControlEvents:UIControlEventValueChanged];
    
    // Transparent view setup
    blackTransparent = [UIView new];
    blackTransparent.frame = self.view.frame;
    blackTransparent.backgroundColor = [UIColor blackColor];
    blackTransparent.alpha = 0.8f;

    // Launch Camera
    [self launchCamera:nil];
}

-(void ) viewWillAppear:(BOOL)animated{
    
    if (![self.view.subviews containsObject:_cameraView]){
        [AppHelper logInColor:@"capture view will appear.. lauching cam"];
        [self launchCamera:nil];
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    
    // Memory Safe
    if ([self.view.subviews containsObject:_cameraView]) {
        [AppHelper logInColor:@"capture view disappeared.. removing cameara"];
        [_cameraView removeFromSuperview];
    }
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

    // remove previous instances
    if ([self.view.subviews containsObject:_cameraView]) {
        [_cameraView removeFromSuperview];
    }

    // Hide other view
    _optionPane.hidden = YES;
    
    if (blackTransparent != nil) {
        blackTransparent.hidden = YES;
    }
    
    [FVCustomAlertView hideAlertFromView:self.view fading:NO];
    
    self.tabBarController.tabBar.hidden = YES;
    self.pictureView.hidden = YES;
    [self.view addSubview:_cameraView];
}

- (void) didCaptureImage:(UIImage *)image withCamera:(int)cameraType{
    //  Camera type: 0 = Front Facing     1 = Back Facing
    [_cameraView removeFromSuperview];
    
    // Remove stealth mode
    if (_cameraView.cameraStealth.isOn)
        [UIScreen mainScreen].brightness = [AppHelper getUserBrightness];
    
    
    self.tabBarController.tabBar.hidden = NO;
    
    uploadImage = image;
    // Flip the damn image if from front camera
    if (cameraType == 0){
        uploadImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
    }
    
    [self loadPreview:uploadImage];
}

// Camera view was dismissed
- (void) didDismissCameraView{
    // Unhide tab bar
    self.tabBarController.tabBar.hidden = NO;
    
    // Give Option To Relaunch Camera
    _optionPane.hidden = NO;
    blackTransparent.hidden = NO;
    
    // Add camera with black tint
    [self.view addSubview:_cameraView];
    [self.view insertSubview:blackTransparent aboveSubview:_cameraView];
    [self.view insertSubview:_optionPane aboveSubview:blackTransparent];
}

#pragma Parse Calls
- (IBAction)postPicture:(id)sender
{
    [AppHelper logInColor:@"uploading picture.."];
    
    if (uploadImage == nil) {
        [AppHelper logError:@"fatal error: No image data!!"];
        return;
    }
    
    // Test
    PFGeoPoint* storedUserLoc = [AppHelper storedUserLocation];
    if (storedUserLoc == nil)     // No Location was stored
    {
        [AppHelper logError:@"error: no location found aboring"];
        [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"No Location found" withBlur:YES allowTap:YES];
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
    post[@"location"] = storedUserLoc;
    
    // Save Picure
    NSData* data = UIImageJPEGRepresentation(uploadImage, 0.85);
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
    // Hide other view
    _optionPane.hidden = YES;
    
    // Rounded Button
    self.pictureView.uploadButton.layer.cornerRadius = CGRectGetWidth(self.pictureView.uploadButton.frame)/2;
    [self.pictureView.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.pictureView.visualEffectView.layer.cornerRadius = 10;
    self.pictureView.visualEffectView.clipsToBounds = YES;
    
    UIFont* font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
    
    // clear data
    self.pictureView.comment.text = @"";
    
    // Placeholder
    self.pictureView.comment.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"comment" attributes:@{NSForegroundColorAttributeName: customWhite, NSFontAttributeName:font}];
    
    // Addtional Setup
    [self.pictureView.uploadButton addTarget:self action:@selector(postPicture:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pictureView.alpha = 0;
    self.pictureView.hidden = NO;

    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pictureView.alpha = 1;
    } completion:nil];
    
    self.pictureView.imageView.image = capturedImage;
    self.pictureView.imageView.contentMode = UIViewContentModeScaleAspectFill;
}


#pragma mark - Helpers
- (IBAction)toggleStealthMode:(UISwitch*)sender
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        originalBrightnessValue = [UIScreen mainScreen].brightness;
        [AppHelper logInBlueColor:[NSString stringWithFormat:@"saved org screen brightness: %f", originalBrightnessValue]];
    });
    
    if (sender.isOn){
        stealthMode = YES;
        [AppHelper logInGreenColor:@"stealth mode ON"];
        [[UIScreen mainScreen] setBrightness:0.0];
    }
    else{
        stealthMode = NO;
        [AppHelper logInGreenColor:@"stealth mode OFF"];
        [[UIScreen mainScreen] setBrightness:originalBrightnessValue];
    }
}


- (IBAction)showStory:(id)sender
{
    self.tabBarController.selectedIndex = 0;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)signOutAction:(UIButton *)sender {
    [PFUser logOutInBackground];
    [self.tabBarController performSegueWithIdentifier:@"login" sender:nil];
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
