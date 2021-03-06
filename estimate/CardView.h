//
//  CardView.h
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardView : UIView {
  UIImage   *image_;
  float estimationValue_;
}

@property float estimationValue;
@property (nonatomic,retain) UIImage *image;

- (id)initWithImage:(UIImage*)image;

@end
