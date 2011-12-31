//
//  EventDetailViewController.h
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "EventsAppDelegate.h"


@interface EventDetailViewController : UIViewController <MKMapViewDelegate> {
    UIView *contents;
    UIView *touchDetector;
    MKMapView *map;
    UIImageView *shadow;
    NSString *temp;
    UILabel *name;
    UILabel *description;
    UILabel *address;
    //MKAnnotation
    NSDictionary *eventInfo;
    
    UIButton *urlButton;
    NSURL *url;
    
    //EventsAppDelegate *eventDelegate;
}

@property (nonatomic, retain) IBOutlet UIImageView *shadow;
@property (nonatomic, retain) IBOutlet UIView *touchDetector;
@property (nonatomic, retain) IBOutlet UIView *contents;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UILabel *address;

@property (nonatomic, retain) NSDictionary *eventInfo;
@property (nonatomic, retain) IBOutlet UIButton *urlButton;
@property (nonatomic, retain) NSURL *url;
//@property (nonatomic, retain) EventsAppDelegate *eventDelegate;

- (IBAction)calButtonPressed:(id)sender;
- (IBAction)launchWebPage:(id)sender;
@end
