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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	
	EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
	event.startDate = [NSDate date]; 
	event.endDate = [NSDate date];
	event.title = @"Test";
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



@end
