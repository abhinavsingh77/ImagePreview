//
//  ViewController.m
//  ImagePreview
//
//  Created by Abhinav Singh on 06/04/16.
//  Copyright © 2016 Abhinav Singh. All rights reserved.
//

#import "ViewController.h"
#import "LSTImagePreviewView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)topTestClicked:(id)sender {
    
    LSTImagePreviewView *preview = [[LSTImagePreviewView alloc] initWithFrame:CGRectZero];
    preview.removeOnTap = NO;
    preview.animationDuration = 3;
    
    [preview showPreviewForImageView:topImageView];
}

-(IBAction)bottomTestClicked:(id)sender {
    
    LSTImagePreviewView *preview = [[LSTImagePreviewView alloc] initWithFrame:CGRectZero];
    preview.animationDuration = 3;
    [preview showPreviewForImageView:bottomImageView];
}

-(IBAction)centerTestClicked:(id)sender {
    
    LSTImagePreviewView *preview = [[LSTImagePreviewView alloc] initWithFrame:CGRectZero];
    preview.animationDuration = 3;
    [preview showPreviewForImageView:centerImageView];
}

@end
