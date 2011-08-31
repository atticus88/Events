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

@interface EventsViewController : UIViewController <UITableViewDelegate, MyCLControllerDelegate, HTTPRequestDelegate, ADBannerViewDelegate> {
    MyCLController *locationController;
    ADBannerView *bannerView;
    UISearchBar *search;
}

@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;


@end
