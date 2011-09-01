//
//  EventDetailViewController.h
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface EventDetailViewController : UIViewController {
    UIView *contents;
    UIView *touchDetector;
    MKMapView *map;
    UIImageView *shadow;
    
    
}

@property (nonatomic, retain) IBOutlet UIImageView *shadow;
@property (nonatomic, retain) IBOutlet UIView *touchDetector;
@property (nonatomic, retain) IBOutlet UIView *contents;
@property (nonatomic, retain) IBOutlet MKMapView *map;

@end
