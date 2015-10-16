//
//  PopupViewController2.m
//  STPopup
//
//  Created by Kevin Lin on 11/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import "PopupViewController2.h"
#import "STPopup.h"
#import "AppHelper.h"
#include "FVCustomAlertView.h"

@interface PopupViewController2()

@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *likes;

@end

@implementation PopupViewController2

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentSizeInPopup = CGSizeMake(300, 400);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RightBBtn" style:UIBarButtonItemStylePlain target:self action:@selector(rightBBiPressed:)];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Setup

    
    // Keys
    PFUser* currentUser = [PFUser currentUser];
    PFUser* postUser = _post[@"user"];
    PFFile* postImageFile = _post[@"picture"];
    NSString* postComment = _post[@"comment"];
    PFGeoPoint* postLocation = _post[@"location"];
    NSNumber* postLikes      = _post[@"likes"];
    
    // Load Barbutton Item
    if (currentUser == nil) {
        [AppHelper logError:@"No User Signed in ... Dissmiss"];
        [self removeFromParentViewController];
        return;
    }
    
    if ([postUser.email isEqualToString:currentUser.email] && [postUser.username isEqualToString:currentUser.username]) {
        [AppHelper logInBlueColor:@"you posted this!"];
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Like"];
    }
    
    // Load Image
    _imageView.file = postImageFile;
    [_imageView loadInBackground];
    
    // Load Comment
    _comment.text = postComment;
    
    // Load Likes
    if (postLikes == nil)
        _likes.text = @"0";
    else
        _likes.text = [postLikes stringValue];
    
    
    //    cell.likeButton.tag = indexPath.row;
    //    [cell.likeButton setImage:[UIImage imageNamed:@"LikeBlack"] forState:UIControlStateNormal];
    //    [cell.likeButton setImage:[UIImage imageNamed:@"LikeRed"] forState:UIControlStateHighlighted];
    //
    //    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
        
}

- (IBAction)rightBBiPressed:(UIBarButtonItem*)sender
{
    if ([sender.title isEqualToString:@"Delete"])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        btn.backgroundColor = [AppHelper customOrange];
        btn.layer.cornerRadius = CGRectGetWidth(btn.frame) / 2;
        [btn setTitle:@"Delete" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmDelete:) forControlEvents:UIControlEventTouchUpInside];
        [FVCustomAlertView showAlertOnView:self.view withTitle:@"" titleColor:[UIColor whiteColor] width:100 height:120 blur:YES backgroundImage:nil backgroundColor:[AppHelper customOrange] cornerRadius:20 shadowAlpha:0.2 alpha:0.8 contentView:btn type:FVAlertTypeCustom allowTap:YES];
    }
    
    else if ([sender.title isEqualToString:@"Like"]) {
        [AppHelper logInBlueColor:@"like"];
        [self likePost:sender];
    }
}


-(IBAction)likePost:(UIBarButtonItem*) button
{
    [_post incrementKey:@"likes"];
    [_post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [AppHelper logInColor:@"liked!"];
            [button setTitle:@"Liked"];
            
            NSNumber* newLikes = _post[@"likes"];
            _likes.text = [newLikes stringValue];
        }
        else
        {
            [AppHelper logInColor:@"Error liking pic!"];
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"Error" withBlur:YES allowTap:YES];
        }
    }];
    
}

- (IBAction)confirmDelete:(id)sender
{
    [AppHelper logInBlueColor:@"deleting...."];
    [self.post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
@end
