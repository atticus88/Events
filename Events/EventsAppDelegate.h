//
//  EventsAppDelegate.h
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class EventsViewController;

@interface EventsAppDelegate : NSObject <UIApplicationDelegate> {
    NSString *test;
    NSMutableArray *selectedEvent;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *viewController;

@property (nonatomic, retain) NSString *test;

@property (nonatomic, retain) NSMutableArray *selectedEvent;

@end
