//
//  CustomAdView.m
//  Events
//
//  Created by George Shank on 8/29/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CustomAdView.h"
#import "HTTPRequest.h"
#import "JSON.h"

@implementation CustomAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)getAdFromServer
{
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:@"http://www.google.com" animated:NO];
    [request release];
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
    HTTPRequest *response = (HTTPRequest *)request;
    NSString *jsonString = [[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding];
	//NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", jsonString);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
