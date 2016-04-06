//
//  LSTImagePreviewView.m
//  ImagePreview
//
//  Created by Abhinav Singh on 06/04/16.
//  Copyright © 2016 Abhinav Singh. All rights reserved.
//

#import "LSTImagePreviewView.h"

@interface LSTImagePreviewView () {

    __weak UIView *backgroundView;
    __weak UIImageView *imageView;
    
    __weak UIImageView *animatedFromImageView;
}

@end

@implementation LSTImagePreviewView

+(LSTImagePreviewView*)defaultPreviewView {
    
    return [[[self class] alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialSetup];
    }
    
    return self;
}

-(void)initialSetup {
    
    self.minimumZoomScale = 0.5;
    self.maximumZoomScale = 2;
    self.animationDuration = 0.25;
    
    self.maximumWidthAllowed = ([UIScreen mainScreen].bounds.size.width - 20);
    self.maximumHeightAllowed = ([UIScreen mainScreen].bounds.size.height - 100);
    
    self.removeOnTap = YES;
}

-(void)showPreviewForImageView:(UIImageView *)imageV {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (imageView || !window) {
        return;
    }
    
    self.frame = window.bounds;
    [window addSubview:self];
    
    UIImageView *from = imageV;
    UIImage *imageForPreview = from.image;
    CGFloat corners = from.layer.cornerRadius;
    
    UIView *bView = [[UIView alloc] initWithFrame:self.bounds];
    bView.backgroundColor = [UIColor blackColor];
    [self addSubview:bView];
    
    backgroundView = bView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.contentSize = self.bounds.size;
    [scrollView setMaximumZoomScale:self.maximumZoomScale];
    
    if (!self.removeOnTap) {
        // :)
        [scrollView setMinimumZoomScale:(self.minimumZoomScale-0.1)];
    }
    
    scrollView.delegate = self;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
    [self addSubview:scrollView];
    
    if (self.removeOnTap) {
        
        UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapToClose.numberOfTapsRequired = 1;
        tapToClose.numberOfTouchesRequired = 1;
        
        [scrollView addGestureRecognizer:tapToClose];
    }
    
    CGRect overMe = [scrollView convertRect:from.frame fromView:from.superview];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:overMe];
    imgView.userInteractionEnabled = YES;
    imgView.image = imageForPreview;
    imgView.backgroundColor = from.backgroundColor;
    imgView.layer.cornerRadius = corners;
    imgView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin);
    imgView.contentMode = from.contentMode;
    imgView.layer.masksToBounds = YES;
    [scrollView addSubview:imgView];
    
    imageView = imgView;
    
    CGFloat maxWidthAllowed = self.maximumWidthAllowed;
    CGFloat maxHeightAllowed = self.maximumHeightAllowed;
    
    CGFloat imageWidth = imageForPreview.size.width;
    CGFloat imageHeight = imageForPreview.size.height;
    CGFloat whRatio = (imageWidth/imageHeight);
    
    if (whRatio >= 1.0) {
        
        //Width is greater than OR equal to height.
        if (imageWidth > maxWidthAllowed) {
            imageWidth = maxWidthAllowed;
        }
        
        imageHeight = (imageWidth/whRatio);
    }else {
        
        //Width is smaller than height.
        if (imageHeight > maxHeightAllowed) {
            imageHeight = maxHeightAllowed;
        }
        
        imageWidth = (whRatio*imageHeight);
        if (imageWidth > maxWidthAllowed) {
            
            imageWidth = maxWidthAllowed;
            imageHeight = (imageWidth/whRatio);
        }
    }
    
    CGRect newFrame = CGRectMake(0, 0, imageWidth, imageHeight);
    
    newFrame.origin.x = (scrollView.frame.size.width - newFrame.size.width)/2.0f;
    newFrame.origin.y = (scrollView.frame.size.height - newFrame.size.height)/2.0f;
    
    [scrollView setContentSize:newFrame.size];
    backgroundView.alpha = 0;
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = self.animationDuration;
    animation.fromValue = [NSNumber numberWithInt:corners];
    animation.toValue = [NSNumber numberWithInt:5];
    [imageView.layer addAnimation:animation forKey:@"movingInAnimation"];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        
        imageView.layer.cornerRadius = 5;
        imageView.frame = newFrame;
        backgroundView.alpha = 0.8;
    }];
    
    animatedFromImageView = from;
}

- (void)viewTapped:(UITapGestureRecognizer*)gesture {
    
    CGPoint overImageView = [gesture locationInView:imageView];
    if (!CGRectContainsPoint(imageView.frame, overImageView)) {
        [self dismiss];
    }
}

-(void)dismiss {
    
    UIView *from = animatedFromImageView;
    if (from) {
        
        CGFloat corners = animatedFromImageView.layer.cornerRadius;
        
        imageView.layer.cornerRadius = corners;
        
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.duration = self.animationDuration;
        animation.fromValue = [NSNumber numberWithInt:5];
        animation.toValue = [NSNumber numberWithInt:corners];
        [imageView.layer addAnimation:animation forKey:@"movingOutAnimation"];
        
        [UIView animateWithDuration:self.animationDuration animations:^{
            
            backgroundView.alpha = 0;
            imageView.frame = [imageView.superview convertRect:from.frame fromView:from.superview];
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }else {
        
        //If we don't have final state of animation don't animate.
        [self removeFromSuperview];
    }
}

#pragma mark UIScrollViewDelegate's

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    imageView.center = CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height/2);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if ((scale < self.minimumZoomScale) && !self.removeOnTap) {
        
        [self dismiss];
    }
}

@end
