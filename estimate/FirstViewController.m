//
//  FirstViewController.m
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () 
- (void) releaseViews;
- (void) scrollToCard:(int)cardIndex;
- (int)  determineCurrentCard;
- (void) cardImageTapped;
- (void) setupEstimationDeckImages;
-(void) showConfirmationWithMessage:(NSString*)confirmationMessage;

@property (nonatomic,retain) CardView* leftCardView;
@property (nonatomic,retain) CardView* currentCardView;
@property (nonatomic,retain) CardView* rightCardView;
@end

@implementation FirstViewController


@synthesize leftCardView;
@synthesize currentCardView;
@synthesize rightCardView;


-(void)setupEstimationDeckImages 
{
  if(!estimationCardImages_) 
  {
    estimationCardImages_ = [[NSMutableArray alloc] initWithCapacity:kTotalCardsInEstimationDeck];
    
    for(int i=0; i<kTotalCardsInEstimationDeck; i++) 
    {
      [estimationCardImages_ addObject:[UIImage imageNamed:@"images/card.png"]];
    }
  }
}

-(void)setupEstimationDeckValues 
{
  if(!estimationCardValues_) 
  {
    estimationCardValues_ = [NSArray arrayWithObjects:0,0.5,1,2,3,5,8,13,20,40,100,0,0,nil];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
  [self releaseViews];
  [super viewDidUnload];
}


- (void)dealloc
{
  [self releaseViews];
  [estimationDeck_ release];
  [super dealloc];
}

- (void)releaseViews
{
  [pageControl_ release];
  [estimationCardImages_ release];
  [estimationDeck_ release];
  [tapRecognizer_ release];  
  [leftCardView_ release];
  [currentCardView_ release];
  [rightCardView_ release];
}

- (void)imageFrameSize:(CardView*)view withIndex:(int)index
{
  CGRect viewFrame = view.frame;
  viewFrame.origin.x = index * kCardDisplayWidth;
  view.frame = viewFrame;
}

- (CardView*)newNextPageNumbered:(int)page
{
  UIImage *nextCardImage = [estimationCardImages_ objectAtIndex:page];
  
  CardView *nextCard = [[CardView alloc] initWithImage:nextCardImage];
  [nextCard setEstimationValue:[[estimationCardValues_ objectAtIndex:page]intValue]];
  [self imageFrameSize:nextCard withIndex:page];
  [estimationDeck_ addSubview:nextCard];
  return nextCard;
}

- (void)navRightWithNewImage:(CardView*)newView
{
  [[self leftCardView] removeFromSuperview];
  [self setLeftCardView:[self currentCardView]];
  [self setRightCardView:[self rightCardView]];
  [self setRightCardView:newView];
}

// as above but to the left, rotating right
- (void)navLeftWithNewImage:(CardView*)newView
{
  [[self rightCardView] removeFromSuperview];
  [self setRightCardView:[self currentCardView]];
  [self setCurrentCardView:[self leftCardView]];
  [self setLeftCardView:newView];
}

- (void)setupForNextScroll
{
  int card = [self determineCurrentCard];
  
  if(card > previousCard_)
  {
    CardView* newRightView = nil;
    if((card + 1) < [pageControl_ numberOfPages])
    {
      newRightView = [self newNextPageNumbered:card + 1];
    }
    [self navRightWithNewImage:newRightView];
    previousCard_ = card;
  }
  else if(card < previousCard_)
  {
    // moving to the left
    CardView* newLeftView = nil;
    if((card - 1) >= 0)
    {
      newLeftView = [self newNextPageNumbered:card - 1];
    }
    [self navLeftWithNewImage:newLeftView];
    previousCard_ = card;
  }
}

-(int) determineCurrentCard 
{
  CGPoint offset = [estimationDeck_ contentOffset];
  return ((offset.x + 1.f) / kCardDisplayWidth);  
}

- (void)positionChange
{
  int page = [pageControl_ currentPage];
  [estimationDeck_ scrollRectToVisible:CGRectMake(page * kCardDisplayWidth, 0, kCardDisplayWidth, kCardDisplayHeight) animated:YES];
  [self setupForNextScroll];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self setupForNextScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGPoint offset = [scrollView contentOffset];
  [pageControl_ setCurrentPage:(offset.x / kCardDisplayWidth)];
}

#pragma mark -
#pragma mark View controller methods

- (void)loadView
{ 
  [self setupEstimationDeckImages];
  
  [[self navigationController] setWantsFullScreenLayout:YES];
  
  // scrollView displays one image at a time, so should have dimensions of the image being displayed
  float xOffset = (320. - kCardDisplayWidth) / 2.;
  float yOffset = (480. - kTabBarHeight - kCardDisplayHeight) / 2.;
  CGRect cardImageDimensions = CGRectMake(xOffset, yOffset, kCardDisplayWidth, kCardDisplayHeight);
  estimationDeck_ = [[UIScrollView alloc] initWithFrame:cardImageDimensions];
  [estimationDeck_ setBackgroundColor:[UIColor clearColor]];
  [estimationDeck_ setContentSize:CGSizeMake(kCardDisplayWidth * [estimationCardImages_ count], kCardDisplayHeight)];
  [estimationDeck_ setPagingEnabled:YES];
  [estimationDeck_ setBounces:YES];
  [estimationDeck_ setShowsHorizontalScrollIndicator:NO];
  [estimationDeck_ setDelegate:self];
  
  pageControl_ = [[UIPageControl alloc] init];
  
  [pageControl_ setFrame:CGRectMake(0, 480. - 3*kTabBarHeight, kCardDisplayWidth, 16.f)];
  [pageControl_ setNumberOfPages:[estimationCardImages_ count]];
  [pageControl_ addTarget:self action:@selector(positionChange) forControlEvents:UIControlEventValueChanged];
  
  UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCardDisplayWidth, kCardDisplayHeight)];
  [baseView setBackgroundColor:[UIColor blackColor]];
  
  [baseView addSubview:estimationDeck_];
  [baseView addSubview:pageControl_];
  [self setView:baseView];
  [baseView release];
  
  [[self view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  
  tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageTapped)];
  [tapRecognizer_ setDelegate:self];
  [tapRecognizer_ setNumberOfTapsRequired:1];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [rightCardView_ removeFromSuperview];
  [self setRightCardView:nil];
  
  [currentCardView_ removeFromSuperview];
  [self setCurrentCardView:nil];
  
  [leftCardView_ removeFromSuperview];
  [self setLeftCardView:nil];
  
  [super viewDidDisappear:animated];
}

- (void) scrollToCard:(int)card;
{
  for (UIView * subview in [estimationDeck_ subviews])
  {
    [subview removeFromSuperview];
  }
  previousCard_ = card;
  [pageControl_ setCurrentPage:previousCard_];
  
  [self setCurrentCardView:[self newNextPageNumbered:previousCard_]];
  
  if((previousCard_ + 1) < [estimationCardImages_ count])
  {
    int rightIndex = previousCard_ + 1;
    [self setRightCardView:[self newNextPageNumbered:rightIndex]];
  }
  
  if(previousCard_ > 0)
  {
    int leftIndex = previousCard_ - 1;
    [self setLeftCardView:[self newNextPageNumbered:leftIndex]];
  }
  
  [estimationDeck_ scrollRectToVisible:CGRectMake(previousCard_ * kCardDisplayWidth, 0, kCardDisplayWidth, kCardDisplayHeight) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [estimationDeck_ addGestureRecognizer:tapRecognizer_];
  [self scrollToCard:0];
  [super viewWillAppear:animated];
}

-(void) cardImageTapped
{
  int currentlySelectedEstimate = 3;
  NSString *confirmationOfEstimateMsg = [NSString stringWithFormat:@"Set selected estimate of %d for this task?", currentlySelectedEstimate];
  [self showConfirmationWithMessage:confirmationOfEstimateMsg];
  }

#pragma mark -
#pragma mark UIAlertViewDelegate

-(void) showConfirmationWithMessage:(NSString*)confirmationMessage 
{
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Estimate Selected"  
                                                    message:confirmationMessage 
                                                   delegate:nil  
                                          cancelButtonTitle:@"Cancel"  
                                          otherButtonTitles:@"Set", nil];  
  
  [message show];  
  
  [message release];    
}

@end
