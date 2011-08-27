//
//  FirstViewController.h
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

#define kCardDisplayWidth 91.
#define kCardDisplayHeight 127.
#define kTotalCardsInEstimationDeck 13
#define kTabBarHeight 40.

@interface FirstViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
  UIPageControl *pageControl_;
  UITapGestureRecognizer *tapRecognizer_;
  UIScrollView *estimationDeck_;
  
  NSMutableArray *estimationCardImages_;
  NSArray *estimationCardValues_;
  
  CardView *leftCardView_;
  CardView *currentCardView_;
  CardView *rightCardView_;
  
  int previousCard_;
}

@end
