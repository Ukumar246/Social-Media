//
//  TestViewController.m
//  Social Media
//
//  Created by Utkarsh Kumar on 10/5/15.
//  Copyright © 2015 Karsh Foundation. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#include "AppHelper.h"
//#include "RBVolumeButtons.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsIndicatorLabel;

@end

@implementation TestViewController{
    int index;
    NSArray* location;
    //RBVolumeButtons* handler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = 0;
    location = @[  @36.05878,	@-94.17298,
                   @36.05718,	@-94.17509,
                   @36.06161,	@-94.17270,

                   @36.06473,	@-94.16768,
                   @36.06230,	@-94.16361];
    [self locationTest];
    
    static int counter = 0;
    //handler = [[RBVolumeButtons alloc] init];
    
//    handler.upBlock = ^{
//        counter++;
//        _resultsIndicatorLabel.text = [NSString stringWithFormat:@"Counte: %d", counter];
//    };
//    handler.downBlock = ^{
//        counter--;
//        _resultsIndicatorLabel.text = [NSString stringWithFormat:@"Counte: %d", counter];
//    };
    
    
    _resultsIndicatorLabel.text = @"Volume being monitored";
}


- (void) locationTest
{
    /*
     Test:
     36.05878	-94.17298
     36.05718	-94.17509
     36.06161	-94.17270   - Field
     
     36.06473	-94.16768
     36.06230	-94.16361
     */
    
    PFGeoPoint* currentLocation = [PFGeoPoint geoPointWithLatitude:36.06161 longitude:-94.17270];
    
    //36.062610, -94.175993
    PFGeoPoint* northWestCorner = [PFGeoPoint geoPointWithLatitude:36.062610 longitude:-94.175993];
    PFGeoPoint* southEastCorner = [PFGeoPoint geoPointWithLatitude:36.056734 longitude:-94.172428];
    _infoLabel.text = [NSString stringWithFormat:@"BOX: NW = %f (lat) \t %f (lon)\nSE = %f (lat) \t %f (lon)", northWestCorner.latitude, northWestCorner.longitude, southEastCorner.latitude, southEastCorner.longitude];
    _resultsLabel.text = [NSString stringWithFormat:@"Test = %f (lat) \t %f (lon)\n", currentLocation.latitude, currentLocation.longitude];
    
    BOOL inRegion = (currentLocation.latitude  >= northWestCorner.latitude && currentLocation.latitude  <= southEastCorner.latitude &&
                     currentLocation.longitude >= southEastCorner.longitude && currentLocation.longitude <= northWestCorner.longitude);
    
    if (inRegion){
        [AppHelper logInGreenColor:@"Pass"];
        _resultsIndicatorLabel.text = @"Pass";
        _resultsIndicatorLabel.backgroundColor = [UIColor greenColor];
    }
    else{
        [AppHelper logError:@"Fail"];
        _resultsIndicatorLabel.text = @"Fail";
        _resultsIndicatorLabel.backgroundColor = [UIColor redColor];
    }
}

- (IBAction)incrementIndex:(UIButton *)sender {
    static int i = 0;
    i++;
    
    [AppHelper logInColor:@"incremented"];
    index = i;
    NSLog(@"%d", index);
    [self locationTest];
}


@end
