//
//  estimateAppDelegate.h
//  estimate
//
//  Created by Gemma Barlow on 8/26/11.
//  Copyright 2011 gem* Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface estimateAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
