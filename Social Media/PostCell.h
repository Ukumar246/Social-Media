//
//  PostCell.h
//  Social Media
//
//  Created by Utkarsh Kumar on 9/30/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PostCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet PFImageView* picture;
@property (nonatomic,weak) IBOutlet UILabel* comment;
@property (nonatomic,weak) IBOutlet UIButton* likeButton;
@property (nonatomic,weak) IBOutlet UILabel* likes;
@property (nonatomic,weak) IBOutlet UIVisualEffectView* visualEffectView;

@end
