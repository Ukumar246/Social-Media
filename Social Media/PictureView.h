//
//  PictureView.h
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureView : UIView
@property (nonatomic,weak) IBOutlet UIImageView*    imageView;
@property (nonatomic,weak) IBOutlet UIVisualEffectView* visualEffectView;
@property (nonatomic,weak) IBOutlet UITextField*    comment;
@property (nonatomic,weak) IBOutlet UIButton*       uploadButton;

@end
