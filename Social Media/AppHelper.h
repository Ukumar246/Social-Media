//
//  AppHelper.h
//  TeamSync
//
//  Created by Utkarsh Kumar on 9/16/15.
//  Copyright (c) 2015 Photon. All rights reserved.
//

/*
    Use this file for universal functions that will be used throughtout the app
        Example: Blur
                 Image Processing Functions
                 Custom NS Logs
                 Custom Alerts
                 Etc
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHelper : NSObject

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;

// System Color
+ (UIColor*) systemColor;

// Blurs Images - Performance Hit ** use blur effect view
+ (UIImage*) getBlurImageWith:(UIImage*) originalImage Intensity:(int) blurValue;

// Applies Dark Filter to Images
+ (UIImage*) applyFilterToImage:(UIImage*) sourceImage withBrightness: (float) darknessLevel;

// Input- hex color string - returns ui color object
+ (UIColor*) colorWithHexString:(NSString*)hex;

#pragma mark - Alerts
//+(void) showJTAlert;

#pragma mark - NSLogs
// Colored Logs
+(void) logInColor: (NSString*) customMessage;

+(void) logError: (NSString*) errorMessage;

+(void) logInBlueColor: (NSString*) customMessage;

+(void) logInGreenColor: (NSString*) customMessage;

@end
