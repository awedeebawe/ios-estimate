//
//  CardView.m
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import "CardView.h"


@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // TODO : Initialization code
    }
    return self;
}

-(void) setImage:(UIImage*)image
{
  image_ = [image retain];
}

-(void)setEstimationValue:(NSInteger)estimationValue 
{
  estimationValue_ = estimationValue;
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
