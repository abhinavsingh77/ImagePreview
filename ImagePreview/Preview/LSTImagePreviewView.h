//
//  LSTImagePreviewView.h
//  ImagePreview
//
//  Created by Abhinav Singh on 06/04/16.
//  Copyright © 2016 Abhinav Singh. All rights reserved.
//

@import UIKit;

@interface LSTImagePreviewView : UIView <UIScrollViewDelegate>{
    
}

@property(nonatomic, assign) CGFloat maximumZoomScale;
@property(nonatomic, assign) CGFloat minimumZoomScale;

@property(nonatomic, assign) CGFloat maximumWidthAllowed;
@property(nonatomic, assign) CGFloat maximumHeightAllowed;

@property(nonatomic, assign) CGFloat animationDuration;

@property(nonatomic, assign) BOOL removeOnTap;

-(void)showPreviewForImageView:(UIImageView *)imageV;

@end
