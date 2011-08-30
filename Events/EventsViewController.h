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
#import <iAd/iAd.h>
#import "HTTPRequest.h"

@interface EventsViewController : UIViewController <UITableViewDelegate, MyCLControllerDelegate, HTTPRequestDelegate> {
    MyCLController *locationController;
    UISearchBar *search;
}

@property (nonatomic, retain) IBOutlet UISearchBar *search;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;


@end
