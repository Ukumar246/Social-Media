//
//  AppHelper.m
//  TeamSync
//
//  Created by Utkarsh Kumar on 9/16/15.
//  Copyright (c) 2015 Photon. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

@synthesize someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static AppHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
    }
    return self;
}

+ (UIColor*) systemColor{
    return [self colorWithHexString:@"#e91313"];
    
    //return [UIColor colorWithRed:0.93 green:0.00 blue:0.00 alpha:1.0];
}

+ (UIImage*) getBlurImageWith:(UIImage*) originalImage Intensity:(int) blurValue
{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[originalImage CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:[NSNumber numberWithInt:blurValue] forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *newImage       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return newImage;
}

+ (UIImage*) applyFilterToImage:(UIImage*) sourceImage withBrightness: (float) darknessLevel
{
    CIImage *inputImage = [[CIImage alloc] initWithCGImage:[sourceImage CGImage]];
    UIImageOrientation originalOrientation = sourceImage.imageOrientation;
    
    CIFilter* adjustmentFilter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [adjustmentFilter setDefaults];
    [adjustmentFilter setValue:inputImage forKey:@"inputImage"];
    [adjustmentFilter setValue:[NSNumber numberWithFloat:darknessLevel] forKey:@"inputEV"];
    
    CIImage *outputImage = [adjustmentFilter valueForKey:@"outputImage"];
    CIContext* context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent] ;
    
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    CGImageRelease(imgRef);
    return img;
}


+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Alerts

#pragma mark - NSLogs

+(void) logInColor: (NSString*) customMessage{
#define XCODE_COLORS_ESCAPE @"\033["
    
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
    /*
     NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;" @"Blue text" XCODE_COLORS_RESET);
     
     NSLog(XCODE_COLORS_ESCAPE @"bg220,0,0;" @"Red background" XCODE_COLORS_RESET);
     */
    
    NSLog(XCODE_COLORS_ESCAPE @"fg255,0,0; %@"  XCODE_COLORS_RESET, customMessage);
    
#undef XCODE_COLORS_ESCAPE
#undef XCODE_COLORS_RESET_FG
#undef XCODE_COLORS_RESET_BG
#undef XCODE_COLORS_RESET
    
}

+(void) logError: (NSString*) errorMessage
{
#define XCODE_COLORS_ESCAPE @"\033["
    
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
    /*
     NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;" @"Blue text" XCODE_COLORS_RESET);
     
     NSLog(XCODE_COLORS_ESCAPE @"bg220,0,0;" @"Red background" XCODE_COLORS_RESET);
     */
    NSString* errorMessageString = [NSString stringWithFormat:@"## Error: %@", errorMessage];
    
    NSLog(XCODE_COLORS_ESCAPE @"bg220,0,0; %@"  XCODE_COLORS_RESET, errorMessageString);
    
#undef XCODE_COLORS_ESCAPE
#undef XCODE_COLORS_RESET_FG
#undef XCODE_COLORS_RESET_BG
#undef XCODE_COLORS_RESET
    
}

+(void) logInBlueColor: (NSString*) customMessage{
#define XCODE_COLORS_ESCAPE @"\033["
    
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
    
    NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255; %@"  XCODE_COLORS_RESET, customMessage);
    
#undef XCODE_COLORS_ESCAPE
#undef XCODE_COLORS_RESET_FG
#undef XCODE_COLORS_RESET_BG
#undef XCODE_COLORS_RESET
}

+(void) logInGreenColor: (NSString*) customMessage{
#define XCODE_COLORS_ESCAPE @"\033["
    
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
    /*
     NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;" @"Blue text" XCODE_COLORS_RESET);
     
     NSLog(XCODE_COLORS_ESCAPE @"bg220,0,0;" @"Red background" XCODE_COLORS_RESET);
     */
    // Blue Background
    NSLog(XCODE_COLORS_ESCAPE @"fg0,255,0; %@"  XCODE_COLORS_RESET, customMessage);
    
#undef XCODE_COLORS_ESCAPE
#undef XCODE_COLORS_RESET_FG
#undef XCODE_COLORS_RESET_BG
#undef XCODE_COLORS_RESET
    
}


@end
