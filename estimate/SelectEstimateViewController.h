//
//  SelectEstimateViewController.h
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

#define kCardDisplayWidth 91.
#define kCardDisplayHeight 127.
#define kEstimationButtonWidth 200.
#define kEstimationButtonHeight 40.

#define kTotalCardsInEstimationDeck 13
#define kTabBarHeight 40.

@interface SelectEstimateViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
  UIPageControl *pageControl_;
  UITapGestureRecognizer *tapRecognizer_;
  UIScrollView *estimationDeck_;
  
  UIButton *revealEstimateButton_;
    
  NSMutableArray *estimationCardImages_;
  NSArray *estimationCardValues_;
  
  CardView *leftCardView_;
  CardView *currentCardView_;
  CardView *rightCardView_;
  
  int previousCard_;
}

@end
