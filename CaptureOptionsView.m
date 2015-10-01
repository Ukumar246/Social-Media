//
//  CaptureOptionsView.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/30/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "CaptureOptionsView.h"

@implementation CaptureOptionsView

- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (!hidden) {
        _captureButton.layer.cornerRadius = CGRectGetWidth(_captureButton.frame)/2;
        _signoutButton.layer.cornerRadius = CGRectGetWidth(_signoutButton.frame)/2;
        _settingsButton.layer.cornerRadius = CGRectGetWidth(_settingsButton.frame)/2;
        _storyButton.layer.cornerRadius = CGRectGetWidth(_storyButton.frame)/2;
    }
}

@end
