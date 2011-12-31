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
//#import "CustomAdView.h"
#import "CustomAdWebView.h"
#import "IngredientTableViewCell.h"

#define hiddenAd CGRectMake(0, 416, 320, 50)
#define showAd CGRectMake(0, 366, 320, 50)

@implementation EventsViewController
@synthesize search, bannerView, eventList, currentLocation, customAd, currentGPS, price, category, distance, dateSets, picker, pickerView, pickerDoneButton, distanceButton, priceButton, categoryButton, pickerLabel, pickerType, dateHeaders, dateFormatter, comps;//, eventDelegate;


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
//    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"Bongo";
    
    self.comps = [[NSDateComponents alloc] init];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateHeaders = [[NSMutableArray alloc] init];
    category = [[NSString alloc] initWithString:@"All"];
    pickerType = [[NSString alloc] initWithString:@""];
    currentGPS = nil;
    distance = [[NSNumber alloc] initWithInt:30];
    price = [[NSNumber alloc] initWithDouble:1000000.00];
    
    
    //Settings button
    [[self.navigationController navigationBar] setTintColor:[UIColor brownColor]];
    UIImage* image3 = [UIImage imageNamed:@"settings.png"];
    
    UIBarButtonItem *settingsbutton =[[UIBarButtonItem alloc] initWithImage:image3 style:UIBarButtonItemStyleBordered target:self action:@selector(goToLocationSettings)];

    self.navigationItem.rightBarButtonItem=settingsbutton;
    
    locationUpdated = NO;
    alertShownAlready = NO;
    useLocation =  YES;
    
    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];	
    
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:41.5708840 longitude:-85.0515683];
//    [locationController locationManager:locationController.locationManager didUpdateToLocation:location fromLocation:nil];
    list = [[NSMutableArray alloc] init];

   // eventDelegate = (EventsAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self eventDelegate].test = @"I am testing this thing";
    
    [super viewDidLoad];
    
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?price=%@&category=all", price, category] animated:YES];
    [request release];
    
    [self.eventList setAlwaysBounceVertical:YES];
}

- (void)locationUpdate:(CLLocation *)location {
    if(useLocation)
    {
        [self setCurrentGPS:location];
        
        NSString *locationString = [NSString stringWithFormat:@"lat=%.6f&long=%.6f", location.coordinate.latitude, location.coordinate.longitude];
        [self setCurrentLocation:locationString];
        NSLog(@"%@", locationString);
        
        
        if(!locationUpdated)
        {
            locationUpdated = YES;
            HTTPRequest *request = [[HTTPRequest alloc] init];
            [request setDelegate:self];
            [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?%@&distance=%@&price=%@&category=%@", currentLocation, distance, price, category] animated:YES];
            [request release];
        }
    }
    //else
        //Do nothing
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
    [dateHeaders removeAllObjects];
    HTTPRequest *response = (HTTPRequest *)request;
    NSString *jsonString = [[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding];
	NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", results);
    list = [[results objectForKey:@"results"] copy];
    [self calculateDates];
    [eventList reloadData];
    [jsonString release];
}

- (void)locationError:(NSError *)error {
    if(!alertShownAlready)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Area" message:@"Unable to use your location. Showing all events instead." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self setCurrentLocation:@""];
        
        useLocation = NO;
    }
    
     alertShownAlready = NO;
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

-(void)calculateDates
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *curDate = [NSDate date];

    //Roll date back to beginning
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&curDate interval:nil forDate:curDate];
    NSDate *comparisonDate = curDate;
    

    [comps setDay:1];
    
    for(int i = 0; i < [list count]; i++)
    {
        NSDate *date = [dateFormatter dateFromString:[[list objectAtIndex:i] objectForKey:@"begin"]];
        
        NSLog(@"%@", date);
        //Sets to beginning of day
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date interval:nil forDate:date];
        if([comparisonDate isEqualToDate:date])
        {
            //Set somehow
            if([curDate isEqualToDate:date])
            {
                if([dateHeaders count] == 0)
                {
                    NSMutableArray *currentDateEvents = [[NSMutableArray alloc] init];
                    [dateHeaders addObject:currentDateEvents];
                }
                    
                [[dateHeaders objectAtIndex:0] addObject:[list objectAtIndex:i]];

            }
            else
            {
                [[dateHeaders lastObject] addObject:[list objectAtIndex:i]];
            }
        }
        if(![comparisonDate isEqualToDate:date])
        {
            if([dateHeaders count] == 0 || [[dateHeaders lastObject] count] != 0)
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [dateHeaders addObject:array];
            }
            i--;
            comparisonDate = [calendar dateByAddingComponents:comps toDate:comparisonDate options:0];
        }

    }

}
#pragma mark -
#pragma mark UITableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [dateHeaders count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *curDate = [NSDate date];

    NSDate *comparisonDate = [dateFormatter dateFromString:[[[dateHeaders objectAtIndex:section] lastObject] objectForKey:@"begin"]];
    
    //Roll date back to beginning
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&curDate interval:nil forDate:curDate];
    NSLog(@"%@", comparisonDate);
    
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&comparisonDate interval:nil forDate:comparisonDate]; 
    
    [comps setDay:1];
    
    if([curDate isEqualToDate:comparisonDate])
    {
        return @"Today";
    }
    curDate = [calendar dateByAddingComponents:comps toDate:curDate options:0];
    
    if([curDate isEqualToDate:comparisonDate])
    {
        return @"Tomorrow";
    }
    else
    {
        NSDateFormatter *newFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [newFormatter setDateFormat:@"EEEE MMM d, yyyy"];
        return [newFormatter stringFromDate:comparisonDate];
    }

}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
   return [[dateHeaders objectAtIndex:section] count];
}

/*-(NSInteger)add:(NSInteger)val1 secondValue:(NSInteger)val2 {
    NSInteger total = val1 + val2;
    return total;
}*/

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    CLLocationDistance distance = 0.0;
    
    if(currentGPS != nil)
    {
        CLLocationDegrees destLat = [[[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"lat"] doubleValue];
        CLLocationDegrees destLon = [[[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"lon"] doubleValue];
        
        CLLocation *destination = [[CLLocation alloc] initWithLatitude:destLat longitude:destLon];
        
        distance = [self milesFromLocation:destination];
    }
    
    
	//NSInteger section = [indexPath section];
	static NSString *TableID = @"MyCell";
	
	// *cell = ( *)[tableView dequeueReusableCellWithIdentifier:TableID];
	IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
	if (cell == nil) {
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
		
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableID];
		cell = [[[IngredientTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableID] autorelease];
	}
    //cell.contentView.backgroundColor = [UIColor whiteColor];
    //cell.textLabel.backgroundColor = [UIColor whiteColor];
    // NSLog(@"%@", [[list objectAtIndex:0] objectForKey:@"name"]);
	cell.textLabel.text = [[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",[[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"city"], [[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"state_prefix"]];
    
    if(useLocation)
        ((IngredientTableViewCell *)cell).disclosureLabel.text = [NSString stringWithFormat:@"%.1f mi", distance];//[NSString stringWithFormat:@"$%@", [[list objectAtIndex:row] objectForKey:@"price"]];
    else
        ((IngredientTableViewCell *)cell).disclosureLabel.text = @"";
    
    //Set category image
    cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"category"]]];
    
    if(![[[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"price"] isEqualToString:@"0.00"])
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [[[dateHeaders objectAtIndex:section] objectAtIndex:row] objectForKey:@"price"]];
    else
        cell.priceLabel.text = @"Free";
        
	return cell;
}


-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Grab row value of selected row
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    //Set delegate's selected event to the selected row's event
    //[self eventDelegate].selectedEvent = [list objectAtIndex:row];
    
    //Instantiate EventDetailViewController and push on to navigation controller stack. Exit
    //search if engaged
    EventDetailViewController *detail = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
    [detail setEventInfo:[[dateHeaders objectAtIndex:section] objectAtIndex:row]];
    
    if(![[[detail eventInfo] objectForKey:@"link"] isEqualToString:@""])
    {
        [[detail urlButton] setTitle:@"Test" forState:UIControlStateNormal];
        [detail setUrl:[NSURL URLWithString:[[detail eventInfo] objectForKey:@"link"]]];
    }
        
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
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

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText 
//{
//    
//    
//    NSString *dbCall = [[[NSString alloc] init] autorelease];
//    NSInteger index =  searchBar.selectedScopeButtonIndex;
//    if(index == 0)
//    {
//        dbCall = [NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?name=%@&%@",searchText, currentLocation];
//    }
//    else if(index == 1)
//    {
//        dbCall = [NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?category=%@&%@",searchText, currentLocation];
//    }
//    else if(index == 2)
//    {
//        dbCall = [NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?price=%@&%@",searchText, currentLocation];
//    }
//    
//    HTTPRequest *request = [[HTTPRequest alloc] init];
//    [request setDelegate:self];
//    [request startRequest:dbCall animated:YES];
//    [request release];
//    NSLog(@"%@, %d", dbCall, index);
//	//[dbCall release];
//}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
//    //NSString *searchText = search.text;
//    
//    [searchBar setText:@""];
//    HTTPRequest *request = [[HTTPRequest alloc] init];
//    [request setDelegate:self];
//    [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?%@&distance=%@", currentLocation, distance] animated:YES];
//    [request release];
//    
//    //NSLog(@"%@, %d", searchText, selectedScope);
//}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"Show iAd");
    [UIView beginAnimations:@"showBanner" context:NULL];
    [UIView setAnimationDuration:.7];
    self.bannerView.frame = showAd;//CGRectMake(0, 366, 320, 50);
    self.customAd.frame = hiddenAd;
    [UIView commitAnimations];
    
    //Pull from superview/release 
    //[customAd removeFromSuperview];
    //[customAd release];
    //customAd = nil;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error receiving iAd");
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
    //if (!customAd) {
        //customAd = [[CustomAdView alloc] init];
        customAd.delegate = self;
        customAd.backgroundColor = [UIColor whiteColor];
        ///customAd.frame = hiddenAd;//CGRectMake(0, 416, 320, 50);
        //[self.view addSubview:customAd];
        [customAd getAdFromServer];
        [UIView beginAnimations:@"showCustomAd" context:NULL];
        [UIView setAnimationDuration:.7];
        self.customAd.frame = showAd;//CGRectMake(0, 0, 320, 50);
        [UIView commitAnimations];
        
        
    //}
}

- (void)loadAdPage:(NSString *)url  {
    CustomAdWebView *webView = [[CustomAdWebView alloc] initWithNibName:@"CustomAdWebView" bundle:nil ];//webSite:[NSURL URLWithString:url]];//[NSURL URLWithString:@"http://www.google.com"]];
    NSLog(url);
    [webView setUrl:[NSURL URLWithString:url]];
    [self presentModalViewController:webView animated:YES];
    [webView release];
}

#pragma mark - Location Based Functions

-(void)goToLocationSettings
{
    EventsLocationSettingsViewController *settings = [[EventsLocationSettingsViewController alloc] initWithNibName:@"EventsLocationSettingsViewController" bundle:nil];
    [settings setDelegate:self];
    [settings setUsingLocation:useLocation];
    
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

-(void)locationSettingsChanged:(BOOL)useLocation
{
    self->useLocation = useLocation;
    
    if(!useLocation)
    {
        [locationController.locationManager stopUpdatingLocation];
        [self setCurrentLocation:@""];
        HTTPRequest *request = [[HTTPRequest alloc] init];
        [request setDelegate:self];
        [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?price=%@&category=%@", price, category] animated:YES];
        [request release];
    }
    else
    {
        [locationController.locationManager startUpdatingLocation];
        locationUpdated = NO;
    }
        
}

double convertToRadians(double val) {
    
    return val * PIx / 180;
}

-(double)milesFromLocation:(CLLocation *) place2 
{
    return (metersToMiles * [currentGPS distanceFromLocation:place2]);
//    double dlon = convertToRadians(place2.longitude - currentGPS.longitude);
//    double dlat = convertToRadians(place2.latitude - currentGPS.latitude);
//    
//    double a = ( pow(sin(dlat / 2), 2) + cos(convertToRadians(currentGPS.latitude))) * cos(convertToRadians(place2.latitude)) * pow(sin(dlon / 2), 2);
//    double angle = 2 * asin(sqrt(a));
//    
//    double distanceInKM = angle * earth_radius;
//    return distanceInKM * kmToMiles;
}

#pragma mark - Picker Stuff

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerType isEqualToString:@"Category"])
    {
        switch (row)
        {
            case 0:
                [categoryButton setTitle:@"All Categories" forState:UIControlStateNormal];
                [self setCategory:@"All"];
                break;
            case 1:
                [categoryButton setTitle:@"Concerts" forState:UIControlStateNormal];
                [self setCategory:@"Concerts"];
                break;
            case 2:
                [categoryButton setTitle:@"Dancing" forState:UIControlStateNormal];
                [self setCategory:@"Dancing"];
                break;
            case 3:
                [categoryButton setTitle:@"Holiday" forState:UIControlStateNormal];
                [self setCategory:@"Holiday"];
                break;
            case 4:
                [categoryButton setTitle:@"Music" forState:UIControlStateNormal];
                [self setCategory:@"Music"];
                break;
            case 5:
                [categoryButton setTitle:@"Sports" forState:UIControlStateNormal];
                [self setCategory:@"Sports"];
                break;
            case 6:
                [categoryButton setTitle:@"Theater" forState:UIControlStateNormal];
                [self setCategory:@"Theater"];
                break;
            case 7:
                [categoryButton setTitle:@"Other" forState:UIControlStateNormal];
                [self setCategory:@"Other"];
                break;
            default:
                [categoryButton setTitle:@"Oops" forState:UIControlStateNormal];
                [self setCategory:@"Oops"];
                break;
        }
    }
    else if([pickerType isEqualToString:@"Price"])
    {
        switch (row) 
        {
            case 0:
                [priceButton setTitle:@"All Prices" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:1000000.00]];
                break;
            case 1:
                [priceButton setTitle:@"<$30" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:30.00]];
                break;
            case 2:
                [priceButton setTitle:@"<$15" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:15.00]];
                break;
            case 3:
                [priceButton setTitle:@"<$5" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:5.00]];
                break;
            case 4:
                [priceButton setTitle:@"Free" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:0.00]];
                break;
            default:
                [priceButton setTitle:@"Oops" forState:UIControlStateNormal];
                [self setPrice:[NSNumber numberWithDouble:0.00]];
                break;
        }
    }
    else if([pickerType isEqualToString:@"Distance"])
    {
        switch (row) 
        {
            case 0:
                [distanceButton setTitle:@"< 100 Miles" forState:UIControlStateNormal];
                [self setDistance:[NSNumber numberWithDouble:100.00]];
                break;
            case 1:
                [distanceButton setTitle:@"< 30 Miles" forState:UIControlStateNormal];
                [self setDistance:[NSNumber numberWithDouble:30.00]];
                break;
            case 2:
                [distanceButton setTitle:@"< 15 Miles" forState:UIControlStateNormal];
                [self setDistance:[NSNumber numberWithDouble:15.00]];
                break;
            case 3:
                [distanceButton setTitle:@"< 5 Miles" forState:UIControlStateNormal];
                [self setDistance:[NSNumber numberWithDouble:5.00]];
                break;
        }
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerType isEqualToString:@"Category"])
        return 8;
    else if([pickerType isEqualToString:@"Price"])
        return 5;
    else if([pickerType isEqualToString:@"Distance"])
        return 4;
    else
        return 1;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CustomUIPickerView *pickerRow = (CustomUIPickerView *)view;
    
    if(pickerRow == nil)
        pickerRow = [[CustomUIPickerView alloc] init];
    
    pickerRow.icon.image = [UIImage imageNamed:@"Other.png"];
    
    if([pickerType isEqualToString:@"Category"])
    {
        switch (row) 
        {
            case 0:
                pickerRow.title.text = @"All Categories";
                break;
            case 1:
                pickerRow.title.text = @"Concerts";
                pickerRow.icon.image = [UIImage imageNamed:@"Concerts.png"];
                break;
            case 2:
                pickerRow.title.text = @"Dancing";
                pickerRow.icon.image = [UIImage imageNamed:@"Dancing.png"];
                break;
            case 3:
                pickerRow.title.text = @"Holiday";
                pickerRow.icon.image = [UIImage imageNamed:@"Holiday.png"];
                break;
            case 4:
                pickerRow.title.text = @"Music";
                pickerRow.icon.image = [UIImage imageNamed:@"Music.png"];
                break;
            case 5:
                pickerRow.title.text = @"Sports";
                pickerRow.icon.image = [UIImage imageNamed:@"Sports.png"];
                break;
            case 6:
                pickerRow.title.text = @"Theater";
                pickerRow.icon.image = [UIImage imageNamed:@"Theater.png"];
                break;
            case 7:
                pickerRow.title.text = @"Other";
                pickerRow.icon.image = [UIImage imageNamed:@"Other.png"];
                break;
            default:
                return @"Oops";
                break;
        }
    }
    else if([pickerType isEqualToString:@"Price"])
    {
        switch (row)
        {
            case 0:
                pickerRow.title.text = @"All Prices";
                break;
            case 1:
                pickerRow.title.text = @"<$30";
                break;
            case 2:
                pickerRow.title.text = @"<$15";
                break;
            case 3:
                pickerRow.title.text = @"<$5";
                break;
            case 4:
                pickerRow.title.text = @"Free";
                break;
            default:
                pickerRow.title.text = @"oops";
                break;
        }
    }
    else if([pickerType isEqualToString:@"Distance"])
    {
        switch (row) 
        {
            case 0:
                pickerRow.title.text = @"< 100 Miles";
                break;
            case 1:
                pickerRow.title.text = @"< 30 Miles";
                break;
            case 2:
                pickerRow.title.text = @"< 15 Miles";
                break;
            case 3:
                pickerRow.title.text = @"< 5 Miles";
                break;
            default:
                pickerRow.title.text = @"Oops";
                break;
        }
    }
    else
        pickerRow.title.text = @"Oops";
    
    return pickerRow;

}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    /*
    Concerts
    Dancing
    Holiday
    Music
    Sports
    Theater
    Other
    */
    if([pickerType isEqualToString:@"Category"])
    {
        switch (row) 
        {
            case 0:
                return @"All Categories";
                break;
            case 1:
                return @"Concerts";
                break;
            case 2:
                return @"Dancing";
                break;
            case 3:
                return @"Holiday";
                break;
            case 4:
                return @"Music";
                break;
            case 5:
                return @"Sports";
                break;
            case 6:
                return @"Theater";
                break;
            case 7:
                return @"Other";
                break;
            default:
                return @"Oops";
                break;
        }
    }
    else if([pickerType isEqualToString:@"Price"])
    {
        switch (row)
        {
            case 0:
                return @"All Prices";
                break;
            case 1:
                return @"<$30";
                break;
            case 2:
                return @"<$15";
                break;
            case 3:
                return @"<$5";
                break;
            case 4:
                return @"Free";
                break;
            default:
                return @"oops";
                break;
        }
    }
    else if([pickerType isEqualToString:@"Distance"])
    {
        switch (row) 
        {
            case 0:
                return @"< 100 Miles";
                break;
            case 1:
                return @"< 30 Miles";
                break;
            case 2:
                return @"< 15 Miles";
                break;
            case 3:
                return @"< 5 Miles";
                break;
            default:
                return @"Oops";
                break;
        }
    }
    else
        return @"Oops";
}

-(void)showPicker
{
    [self.pickerLabel setText:[self pickerType]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.pickerView.frame = CGRectMake(pickerExposedX, pickerExposedY, pickerWidth, pickerHeight);
    [UIView commitAnimations];
}

-(void)hidePicker
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.pickerView.frame = CGRectMake(pickerHiddenX, pickerHiddenY, pickerWidth, pickerHeight);
    [UIView commitAnimations];
}

-(IBAction)categoryButtonPushed:(id)sender
{
    int row = 0;
    
    if([[[categoryButton titleLabel] text] isEqualToString:@"Concerts"])
        row = 1;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Dancing"])
        row = 2;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Holiday"])
        row = 3;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Music"])
        row = 4;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Sports"])
        row = 5;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Theater"])
        row = 6;
    else if([[[categoryButton titleLabel] text] isEqualToString:@"Other"])
        row = 7;
    
    [self setPickerType:@"Category"];
    [picker reloadAllComponents];
    //[picker selectRow:row inComponent:0 animated:YES];
    [self showPicker];
}

-(IBAction)priceButtonPushed:(id)sender
{
    int row = 0;
    
    if([[[priceButton titleLabel] text] isEqualToString:@"<$30"])
        row = 1;
    else if([[[priceButton titleLabel] text] isEqualToString:@"<$15"])
        row = 2;
    else if([[[priceButton titleLabel] text] isEqualToString:@"<$5"])
        row = 3;
    else if([[[priceButton titleLabel] text] isEqualToString:@"Free"])
        row = 4;
    
    [self setPickerType:@"Price"];
    [picker reloadAllComponents];
    [picker selectRow:row inComponent:0 animated:YES];
    [self showPicker];
}

-(IBAction)distanceButtonPushed:(id)sender
{
    int row = 0;
    
    if([[[distanceButton titleLabel] text] isEqualToString:@"< 30 Miles"])
        row = 1;
    if([[[distanceButton titleLabel] text] isEqualToString:@"< 15 Miles"])
        row = 2;
    else if([[[distanceButton titleLabel] text] isEqualToString:@"< 5 Miles"])
        row = 3;
    
    [self setPickerType:@"Distance"];
    [picker reloadAllComponents];
    [picker selectRow:row inComponent:0 animated:YES];
    [self showPicker];
}

-(IBAction)doneWithPicker:(id)sender
{
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    if(useLocation)
        [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?%@&distance=%@&category=%@&price=%@", currentLocation, distance, category, price] animated:YES];
    else
        [request startRequest:[NSString stringWithFormat:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/test.php?price=%@&category=%@", price, category] animated:YES];
    [request release];
    [self hidePicker];
}
@end
