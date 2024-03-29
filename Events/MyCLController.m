#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager, delegate;

- (id) init {
	if (self == [super init]) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self; // send loc updates to myself
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
	}
	return self;
}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self.delegate locationUpdate:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)dealloc {
	[self.locationManager release];
    [super dealloc];
}

@end
