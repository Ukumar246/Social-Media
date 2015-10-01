//
//  SecondViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 9/24/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "StoryViewController.h"
#import "TTRangeSlider.h"

#define cellIdentifier @"contentcell"
int maxSearchRange = 5;
int minSearchRange = 1;

@interface StoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet    UICollectionView*   collectionView;
@property (nonatomic,strong)            NSMutableArray*     posts;
@property (nonatomic)                   int                 maxsearchFilter;
@end

@implementation StoryViewController{
    BOOL filterViewVisible;
}

#pragma mark - Accessors
- (void) setPosts:(NSMutableArray *)posts{
    if (posts == nil) {
        _posts = [NSMutableArray array];
        return;
    }
    _posts = posts;
    [AppHelper logInColor:@"posts saved locally"];

    [self.collectionView reloadData];
}


- (void)setMaxsearchFilter:(int)maxsearchFilter
{
    _maxsearchFilter = maxsearchFilter;

    if (_maxsearchFilter < minSearchRange)
        _maxsearchFilter = minSearchRange;
    else if (_maxsearchFilter > maxSearchRange)
        _maxsearchFilter = maxSearchRange;
    
    
    [AppHelper logInGreenColor:[NSString stringWithFormat:@"max range: %d", _maxsearchFilter]];
    
    [self.collectionView reloadData];
    [self getPostsNearMe];
}

#pragma mark - Start
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self getPostsNearMe];
    [AppHelper logInColor:@"Story Did Appear"];
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL) prefersStatusBarHidden{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Default search - 1mi
    self.maxsearchFilter = 1;
    
    filterViewVisible = NO;
    
    // Background Color
    UIColor* patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtleDots"]];
    _collectionView.backgroundColor = patternColor;
    
    
    // ST Popup
    [STPopupNavigationBar appearance].barTintColor = [AppHelper customOrange];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [AppHelper customFont],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor] };
    
}

#pragma mark - Popoverview
- (void)showPopupWithTransitionStyle:(STPopupTransitionStyle)transitionStyle rootViewController:(UIViewController *)rootViewController
{
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:rootViewController];
    popupController.cornerRadius = 4;
    popupController.transitionStyle = transitionStyle;
    [popupController presentInViewController:self];
}

#pragma mark - Collection view 
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 8;
    cell.clipsToBounds = YES;
    cell.picture.image = nil;
    
    PFObject* post = [self.posts objectAtIndex:indexPath.row];
    
    if (post == nil || [post isKindOfClass:[NSNull class]]) {
        [AppHelper logError:@"fatal error: Nil Post at index"];
        return cell;
    }

    // setup
    cell.picture.backgroundColor = [UIColor clearColor];
    cell.picture.file = post[@"picture"];
    [cell.picture loadInBackground];
    cell.comment.layer.cornerRadius = 8;
    NSNumber* likes = post[@"likes"];
    if (likes!= nil)
        cell.likes.text = [likes stringValue];
    else
        cell.likes.text = @"0";
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject* postObject = [self.posts objectAtIndex:indexPath.row];
    
    
    PopupViewController2* dvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopupViewController2"];
    dvc.post = postObject;
    
    // Present
    [self showPopupWithTransitionStyle:STPopupTransitionStyleSlideVertical rootViewController:dvc];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView* reuseableView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView* headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview" forIndexPath:indexPath];
        
        UILabel* labelRadiusIndicator = (UILabel*) [headerview viewWithTag:2];
        labelRadiusIndicator.text = [NSString stringWithFormat:@"Radius: %d mi", _maxsearchFilter];
        
        if (_maxsearchFilter == maxSearchRange)
            labelRadiusIndicator.text = @"All Photos";
            
        return headerview;
    }
    
    return reuseableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return (filterViewVisible)? CGSizeMake(CGRectGetWidth(self.view.frame), 90): CGSizeMake(CGRectGetWidth(self.view.frame), 0);
}

#pragma mark - Actions
// Show Filter View
- (IBAction)filterViewTrigger:(UIBarButtonItem *)sender {
    
    filterViewVisible = (filterViewVisible) ? NO: YES;
    
    [self.collectionView reloadData];
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    int newVal = (int) lroundf(sender.value);
    [sender setValue:newVal];
}

- (IBAction)sliderDragged:(UISlider *)sender {
    self.maxsearchFilter = sender.value;
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
    // Refetch Location
    NSDate* lastLocationUpdate = [AppHelper lastLocationUpdateTime];
    if ([lastLocationUpdate timeIntervalSinceNow] > 180) {
        [AppHelper updateUserLocation];
    }
    
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    // filter location
    if (_maxsearchFilter < maxSearchRange){
        [AppHelper logInColor:[NSString stringWithFormat:@"* filter set at %d mi", self.maxsearchFilter]];
        [query whereKey:@"location" nearGeoPoint:userLocation withinMiles:self.maxsearchFilter];
    }
    else{
        [AppHelper logInColor:@"* No Filter"];
    }
        
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
