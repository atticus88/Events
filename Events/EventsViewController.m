//
//  EventsViewController.m
//  Events
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "EventsViewController.h"
#import "EventDetailViewController.h"
#import "MyCLController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "CustomAdView.h"
#import "CustomAdWebView.h"

#define hiddenAd CGRectMake(0, 416, 320, 50)
#define showAd CGRectMake(0, 366, 320, 50)

@implementation EventsViewController
@synthesize search, bannerView, eventList;//, eventDelegate;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];	
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    [locationController locationManager:locationController.locationManager didUpdateToLocation:location fromLocation:nil];
    list = [[NSMutableArray alloc] init];

   // eventDelegate = (EventsAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self eventDelegate].test = @"I am testing this thing";
    
    [super viewDidLoad];
}

- (void)locationUpdate:(CLLocation *)location {
    NSString *locationString = [NSString stringWithFormat:@"%.6f,%.6f", location.coordinate.latitude, location.coordinate.longitude];
    NSLog(@"%@", locationString);
    
   // dataReady = NO;
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:@"http://icarus.cs.weber.edu/~kh93145/event.php" animated:YES];
    [request release];
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
    HTTPRequest *response = (HTTPRequest *)request;
    NSString *jsonString = [[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding];
	NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", results);
    list = [[results objectForKey:@"results"] copy];
    [eventList reloadData];
   
}

- (void)locationError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Area" message:@"Unable to use your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
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
   return [list count];
}

/*-(NSInteger)add:(NSInteger)val1 secondValue:(NSInteger)val2 {
    NSInteger total = val1 + val2;
    return total;
}*/

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
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
    //cell.contentView.backgroundColor = [UIColor whiteColor];
    //cell.textLabel.backgroundColor = [UIColor whiteColor];
    // NSLog(@"%@", [[list objectAtIndex:0] objectForKey:@"name"]);
	cell.textLabel.text = [[list objectAtIndex:row] objectForKey:@"name"];
	return cell;
}


-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Grab row value of selected row
    NSInteger row = [indexPath row];
    
    //Set delegate's selected event to the selected row's event
    //[self eventDelegate].selectedEvent = [list objectAtIndex:row];
    
    //Instantiate EventDetailViewController and push on to navigation controller stack. Exit
    //search if engaged
    EventDetailViewController *detail = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
    [detail setEventInfo:[list objectAtIndex:row]];
    [self.navigationController pushViewController:detail animated:YES];
    [search resignFirstResponder];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    search.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   NSInteger index =  searchBar.selectedScopeButtonIndex;
    NSLog(@"%@, %d", searchText, index);	
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSString *searchText = search.text;
    NSLog(@"%@, %d", searchText, selectedScope);
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    //NSLog(@"Show");
    [UIView beginAnimations:@"showBanner" context:NULL];
    [UIView setAnimationDuration:.7];
    self.bannerView.frame = showAd;//CGRectMake(0, 366, 320, 50);
    [UIView commitAnimations];
    
    //Pull from superview/release 
    [customAd removeFromSuperview];
    [customAd release];
    customAd = nil;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    //NSLog(@"Error");
    [UIView beginAnimations:@"hideBanner" context:NULL];
    [UIView setAnimationDuration:.7];
    self.bannerView.frame = hiddenAd;//CGRectMake(0, 416, 320, 50);
    [UIView commitAnimations];
    
    /*Instantiating Custom ad view
    / George written code so watch out!
    */
    //customAd = [[CustomAdView alloc] init];
    
    //Klint written code should work.
    // This will make your init statment print 
    if (!customAd) {
        customAd = [[CustomAdView alloc] initWithFrame:hiddenAd];
        customAd.delegate = self;
        customAd.backgroundColor = [UIColor whiteColor];
        ///customAd.frame = hiddenAd;//CGRectMake(0, 416, 320, 50);
        [self.view addSubview:customAd];
        
        [UIView beginAnimations:@"showCustomAd" context:NULL];
        [UIView setAnimationDuration:.7];
        customAd.frame = showAd;//CGRectMake(0, 366, 320, 50);
        [UIView commitAnimations];
        
        
    }
}

- (void)loadAdPage:(NSString *)url  {
    CustomAdWebView *webView = [[CustomAdWebView alloc] initWithNibName:@"CustomAdWebView" bundle:nil webSite:[NSURL URLWithString:@"http://www.google.com"]];
    [self presentModalViewController:webView animated:YES];
}



@end
