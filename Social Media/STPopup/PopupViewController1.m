//
//  PopupViewController1.m
//  STPopup
//
//  Created by Kevin Lin on 11/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import "PopupViewController1.h"
#import "STPopup.h"

@implementation PopupViewController1{
    UIImageView* imageView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Post";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    
    if (!imageView) {
        imageView = [UIImageView new];
        imageView.frame = self.view.frame;
    }
    imageView.image = self.imageToPresent;
    
    [self.view addSubview:imageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   // _label.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20);
}

- (void)nextBtnDidTap
{
    NSLog(@"nil cannot go");
}

@end
