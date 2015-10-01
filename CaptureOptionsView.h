//
//  CaptureOptionsView.h
//  Social Media
//
//  Created by Utkarsh Kumar on 9/30/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureOptionsView : UIView

@property (nonatomic,weak) IBOutlet UIButton* captureButton;
@property (nonatomic,weak) IBOutlet UIButton* storyButton;
@property (nonatomic,weak) IBOutlet UIButton* signoutButton;
@property (nonatomic,weak) IBOutlet UIButton* settingsButton;
@property (nonatomic,weak) IBOutlet UISwitch* stealthSwitch;

@end
