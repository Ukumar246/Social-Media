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
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "ContentTableViewCell.h"

#define cellIdentifier @"contentcell"

@interface StoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topPictureView;

@property (nonatomic,strong) NSMutableArray* posts;
@end

@implementation StoryViewController

- (void) setPosts:(NSMutableArray *)posts{
    if (posts == nil) {
        _posts = [NSMutableArray array];
        return;
    }
    
    _posts = posts;
    [AppHelper logInColor:@"posts saved locally"];

    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated{
    [self getPostsNearMe];
}

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view insertSubview:self.tableView aboveSubview:_topPictureView];

    // Get posts
    [self getPostsNearMe];
}

#pragma mark - Table view delegates
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentTableViewCell* cell = (ContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [AppHelper logError:@"fatal error: Nil cell"];
        cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Nil cell"];
        return cell;
    }
    
    if (indexPath.row >= self.posts.count || self.posts == nil) {
        [AppHelper logError:@"fatal error: non-valid index path for array"];
        return cell;
    }
    
    cell.picture.image = nil;
    cell.comment.hidden = NO;
    cell.likeButton.hidden = NO;
    cell.visualEffectView.hidden = NO;
    
    PFObject* post = [self.posts objectAtIndex:indexPath.row];
    
    if (post == nil || [post isKindOfClass:[NSNull class]]) {
        [AppHelper logError:@"fatal error: Nil Post at index"];
        return cell;
    }
    
    
    // setup
    cell.picture.backgroundColor = [UIColor clearColor];
    cell.picture.file = post[@"picture"];
    [cell.picture loadInBackground];
    cell.comment.text = post[@"comment"];
    
    NSNumber* likes = post[@"likes"];
    if (likes!= nil)
        cell.likes.text = [likes stringValue];
    
    cell.likeButton.tag = indexPath.row;
    [cell.likeButton setImage:[UIImage imageNamed:@"LikeRed"] forState:UIControlStateHighlighted];
    
    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 212;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



#pragma mark - Database Calls
- (IBAction)refresh:(id)sender {
    
    [self getPostsNearMe];
}


-(void) likePost:(UIButton*) button
{
    PFObject* post = [self.posts objectAtIndex:button.tag];
    [post incrementKey:@"likes"];
    [post saveInBackground];
    
    [AppHelper logInColor:@"liked!"];
    [button setImage:[UIImage imageNamed:@"LikeRed"] forState:UIControlStateNormal];
}

-(void) getPostsNearMe
{
    [AppHelper logInColor:@"fetching posts..."];
    
    PFGeoPoint* userLocation = [AppHelper storedUserLocation];
    if (userLocation == nil) {
        [AppHelper logError:@"user location never set before"];
        return;
    }
    
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    // 1 mile filter
    [query whereKey:@"location" nearGeoPoint:userLocation withinMiles:1.0];
    // Recent First
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error && objects != nil) {
            [AppHelper logInColor:@"posts found"];
            self.posts = [NSMutableArray arrayWithArray:objects];
        }
        else{
            [AppHelper logInColor:@"posts NOT found"];
            self.posts = [NSMutableArray array];
        }
    }];
}

@end
