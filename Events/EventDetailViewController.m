//
//  EventDetailViewController.m
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "EventDetailViewController.h"

#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>


@implementation EventDetailViewController
@synthesize contents, map, shadow, touchDetector, /*eventDelegate*/eventInfo, name, description, urlButton, url, address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if(url != nil)
    {
        urlButton.alpha = 1;
        [urlButton setTitle:[eventInfo objectForKey:@"link"] forState:UIControlStateNormal];
    }
    else
        urlButton.alpha = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Grabbing event delegate
   // eventDelegate = (EventsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *eventName = [eventInfo objectForKey:@"name"];//[[self eventDelegate].selectedEvent  objectForKey:@"name"];
    NSString *eventDescription = [eventInfo objectForKey:@"description"]; //[[self eventDelegate].selectedEvent  objectForKey:@"description"];
    

    self.title = eventName;
    self.address.text = [NSString stringWithFormat:@"%@, %@", [eventInfo objectForKey:@"address"], [eventInfo objectForKey:@"zip"]];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *eventDate = [dateFormatter dateFromString:[eventInfo objectForKey:@"begin"]];
    
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *time = [dateFormatter stringFromDate:eventDate];
    [dateFormatter setDateFormat:@"EEEE MMM d, yyyy"];
    name.text = [NSString stringWithFormat:@"%@ on %@", time, [dateFormatter stringFromDate:eventDate]];
    description.text = eventDescription;
    
    //Hacky way of top-aligning description label
    description.numberOfLines = 0;
    description.frame = CGRectMake(20, 81, 280, 107);
    [description sizeToFit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView DataSource

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }*/

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
	return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSInteger row = [indexPath row];
	//NSInteger section = [indexPath section];
	static NSString *TableID = @"MyCell";
	
	// *cell = ( *)[tableView dequeueReusableCellWithIdentifier:TableID];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
	if (cell == nil) {
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
		
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableID];
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:TableID] autorelease];
	}
	
	cell.textLabel.text = @"Label";
    
	return cell;
}

- (void)createEvent {
    NSString *address = [[NSString alloc] initWithFormat:@"%@, %@", [eventInfo objectForKey:@"address"], [eventInfo objectForKey:@"zip"]];
    
	EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
	
	EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //2011-11-17 00:00:00
    event.startDate = [dateFormatter dateFromString:[eventInfo objectForKey:@"begin"]]; 
	event.endDate = [dateFormatter dateFromString:[eventInfo objectForKey:@"end"]];
	event.title = [eventInfo objectForKey:@"name"];
    event.location = [eventInfo objectForKey:@"address"];
	//event.location = appDelegate.apCreator.testingCenter.NAME;
	NSArray *alarmArray = [[NSArray alloc] initWithObjects:[EKAlarm alarmWithRelativeOffset:-1*60*60], nil];
	event.alarms = alarmArray;
	EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
	controller.eventStore = eventStore;
	controller.editViewDelegate = self;
	controller.event = event;
	[alarmArray release];
	//[appDelegate.appointmentAdd pushViewController:controller animated:YES];
	[self presentModalViewController:controller animated:YES];
    
    [dateFormatter release];
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	if (action == EKEventEditViewActionSaved) {
		//[self saveAppointment];
        [self dismissModalViewControllerAnimated:YES];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}



-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self createEvent];
}

-(NSInteger)add:(NSInteger)val1 secondValue:(NSInteger)val2 {
    NSInteger total = val1 + val2;
    return total;
}

/*
 -(NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section {
 return @"";	
 }*/

/*
 -(CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return 44;
 }*/

#pragma -
#pragma UITableView Customizations

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 }*/

/*- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 
 }*/

- (void)receivedTouches:(NSSet *)touches withEvent:event {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
    if (CGRectContainsPoint(contents.frame, location)) {
        [self makeMapLittle];
    } else { 
        [self makeMapBig];
    }

}

- (void)makeMapLittle {
    touchDetector.hidden = NO;
    [UIView beginAnimations:@"hideBanner" context:NULL];
    [UIView setAnimationDuration:.7];
    self.contents.frame = CGRectMake(0, 0, 320, 301);//CGRectMake(0, 416, 320, 50);
    self.map.frame = CGRectMake(0, 301, 320, 116);
    self.shadow.frame = CGRectMake(0, 301, 320, 18);
    [UIView commitAnimations];
}

- (void)makeMapBig {
    touchDetector.hidden = YES;
    [UIView beginAnimations:@"hideBanner" context:NULL];
    [UIView setAnimationDuration:.7];
    self.contents.frame = CGRectMake(0, 0, 320, 92);//CGRectMake(0, 416, 320, 50);
    self.map.frame = CGRectMake(0, 92, 320, 324);
    self.shadow.frame = CGRectMake(0, 92, 320, 18);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self receivedTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (IBAction)calButtonPressed:(id)sender
{
    [self makeMapLittle];
    [self createEvent];
}

//Delegate method for mapview
- (void)viewWillAppear:(BOOL)animated {  
    // 1
    //Assigning coordinates
    CLLocationCoordinate2D zoomLocation;
    
    //NSLog(@"Lat:%@ Lng:%@ floatLat:%f floatLng:%f",[eventInfo objectForKey:@"lat"], [eventInfo objectForKey:@"lon"], [[eventInfo objectForKey:@"lat"]floatValue], [[eventInfo objectForKey:@"lon"] floatValue]);
    
    zoomLocation.latitude = [[eventInfo objectForKey: @"lat"] floatValue];
    zoomLocation.longitude = [[eventInfo objectForKey: @"lon"] floatValue];

    // 2
    //:Assigning viewing region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 100, 100);
    // 3
    //adjusting map
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];                
    // 4
    //zooming map in
    [map setRegion:adjustedRegion animated:YES]; 
    
    //dropping a pin in.
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:zoomLocation];
                                     
    [self.map addAnnotation:annotation];
    [annotation release];
}

- (IBAction)launchWebPage:(id)sender
{
    [[UIApplication sharedApplication] openURL:url];
}
@end
