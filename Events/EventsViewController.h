//
//  EventsViewController.h
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import <CoreLocation/CoreLocation.h>
#import "HTTPRequest.h"
#import <iAd/iAd.h>
#import "CustomAdView.h"
#import "EventsAppDelegate.h"

@interface EventsViewController : UIViewController <UITableViewDelegate, MyCLControllerDelegate, HTTPRequestDelegate, ADBannerViewDelegate> {
    MyCLController *locationController;
    CustomAdView *customAd;
    ADBannerView *bannerView;
    UISearchBar *search;
    NSMutableArray *list;
    UITableView *eventList;
    EventsAppDelegate *eventDelegate;
}

@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) IBOutlet UITableView *eventList;
@property (nonatomic, retain) EventsAppDelegate *eventDelegate;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
- (void)loadAdPage:(NSString *)url;

-(IBAction)scopeChanged:(id)sender;

@end
