//
//  EventsLocationSettingsViewController.h
//  Events
//
//  Created by George Shank on 11/21/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsLocationSettingsDelegate <NSObject>
@required
-(void)locationSettingsChanged:(BOOL)useLocation;

@end

@interface EventsLocationSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    BOOL usingLocation;
    
    UILabel *contact;
    
    id <EventsLocationSettingsDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain) id delegate;
@property (nonatomic, retain) IBOutlet UILabel *contact;

@property (readwrite) BOOL usingLocation;
-(void)switchChanged;
-(IBAction)contactDeveloper:(id)sender;
@end
