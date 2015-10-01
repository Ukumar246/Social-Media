//
//  PopupViewController2.m
//  STPopup
//
//  Created by Kevin Lin on 11/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import "PopupViewController2.h"
#import "STPopup.h"

@interface PopupViewController2()

@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end

@implementation PopupViewController2

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentSizeInPopup = CGSizeMake(300, 400);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStylePlain target:self action:@selector(pressedRightBBI)];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.file = _post[@"picture"];
    [_imageView loadInBackground];
    _comment.text = _post[@"comment"];
    
    //NSNumber* likes = _post[@"likes"];
    //if (likes!= nil)
        //cell.likes.text = [likes stringValue];
    //    cell.likeButton.tag = indexPath.row;
    //    [cell.likeButton setImage:[UIImage imageNamed:@"LikeBlack"] forState:UIControlStateNormal];
    //    [cell.likeButton setImage:[UIImage imageNamed:@"LikeRed"] forState:UIControlStateHighlighted];
    //
    //    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
        
}


- (void) pressedRightBBI
{
    
}

@end
