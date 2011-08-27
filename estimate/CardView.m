//
//  CardView.m
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import "CardView.h"

@implementation CardView

@synthesize estimationValue = estimationValue_;
@synthesize image = image_;

- (id)initWithImage:(UIImage*)image
{
    self = [super init];
    if (self) 
    {
      [self setImage:image];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:image_];
      [self addSubview:imageView];
      [imageView release];
    }
    return self;
}

-(void) setImage:(UIImage*)image
{
  image_ = [image retain];
}

- (void)dealloc
{
    [super dealloc];
    if(image_) 
    {
      [image_ release];
    }
}

@end
