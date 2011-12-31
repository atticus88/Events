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
#import "EventsLocationSettingsViewController.h"
#import "CustomUIPickerView.h"

#define pickerExposedX 0
#define pickerExposedY 156
#define pickerWidth 320
#define pickerHeight 260

#define pickerHiddenX 0
#define pickerHiddenY 416

#define earth_radius 6371 // Radius of the earth in km
#define PIx 3.141592653589793
#define metersToMiles 0.000621371192

@interface EventsViewController : UIViewController <UITableViewDelegate, MyCLControllerDelegate, HTTPRequestDelegate, ADBannerViewDelegate, EventsLocationSettingsDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    MyCLController *locationController;
    CustomAdView *customAd;
    ADBannerView *bannerView;
    UISearchBar *search;
    NSMutableArray *list;
    UITableView *eventList;
    NSString *currentLocation;
    BOOL locationUpdated;
    BOOL alertShownAlready;
    BOOL useLocation;
    //EventsAppDelegate *eventDelegate;
    
    CLLocation *currentGPS;
    
    //Parameters
    NSNumber *distance;
    NSString *category;
    NSNumber *price;
    
    //Date stuff
    int numOfDifferentDates;
    NSMutableArray *dateSets;
    
    //Picker View Elements
    UIView *pickerView;
    UIPickerView *picker;
    UIBarButtonItem *pickerDoneButton;
    UILabel *pickerLabel;
    NSString *pickerType;
    
    //Buttons
    UIButton *categoryButton;
    UIButton *priceButton;
    UIButton *distanceButton;
    
    //Table Date Data
    NSMutableArray *dateHeaders;
    NSDateFormatter *dateFormatter;
    NSDateComponents *comps;
}

@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) IBOutlet UITableView *eventList;
@property (nonatomic, retain) IBOutlet NSString *currentLocation;
@property (nonatomic, retain) IBOutlet CustomAdView *customAd;
@property (nonatomic, retain) IBOutlet CLLocation *currentGPS;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSMutableArray *dateSets;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pickerDoneButton;
@property (nonatomic, retain) IBOutlet UIButton *categoryButton;
@property (nonatomic, retain) IBOutlet UIButton *priceButton;
@property (nonatomic, retain) IBOutlet UIButton *distanceButton;
@property (nonatomic, retain) IBOutlet UILabel *pickerLabel;
@property (nonatomic, retain) NSString *pickerType;
@property (nonatomic, retain) NSMutableArray *dateHeaders;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateComponents *comps;
//@property (nonatomic, retain) EventsAppDelegate *eventDelegate;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
- (void)loadAdPage:(NSString *)url;
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
-(void)calculateDates;

-(void)showPicker;
-(void)hidePicker;

-(IBAction)scopeChanged:(id)sender;

-(IBAction)categoryButtonPushed:(id)sender;
-(IBAction)priceButtonPushed:(id)sender;
-(IBAction)distanceButtonPushed:(id)sender;

-(IBAction)doneWithPicker:(id)sender;

-(void)goToLocationSettings;

-(void)locationSettingsChanged:(BOOL)useLocation;


-(double)milesFromLocation:(CLLocation *) place2;
@end
