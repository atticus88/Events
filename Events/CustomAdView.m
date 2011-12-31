//
//  CustomAdView.m
//  Events
//
//  Created by George Shank on 8/29/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#define adUrl @"http://davideugenepeterson.com/php-login/other/admin/testing/api/ads.php";

#import "CustomAdWebView.h"
#import "CustomAdView.h"
#import "HTTPRequest.h"
#import "JSON.h"

@implementation CustomAdView
@synthesize delegate, adImage, adButton, results;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        results = [[NSDictionary alloc] init];
        // Initialization code
        //NSLog(@"Custom ad was initiated");
        self.userInteractionEnabled = YES;
        adImage = [[UIImageView alloc] init];
        adImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        adButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [adButton addTarget:self action:@selector(loadAdPage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:adImage];
        [self addSubview:adButton];
        
        adTime = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(getAdFromServer) userInfo:nil repeats:YES];
        [self getAdFromServer];
        //adImage.image = [UIImage imageNamed:@"test.jpg"];
        
    }
    return self;
}


- (void)loadAdPage:(NSString *)url {
   if([[self delegate] respondsToSelector:@selector(loadAdPage:)]) {
       [[self delegate] loadAdPage:[results objectForKey:@"ad_url"]];// stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
	}
   // CustomAdWebView *webView = [[CustomAdWebView alloc] initWithNibName:@"CustomAdWebView" bundle:nil webSite:[NSURL URLWithString:@"http://www.google.com"]];
}

- (void)getAdFromServer {
    adTime = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(getAdFromServer) userInfo:nil repeats:YES];
    
    adImage = [[UIImageView alloc] init];
    adImage.frame = CGRectMake(0, 0, 320, 50);
    adButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [adButton addTarget:self action:@selector(loadAdPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:adImage];
    [self addSubview:adButton];
    
    //adImage.image = [UIImage imageNamed:@"test.jpg"];
    
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:@"http://davideugenepeterson.com/php-login/other/admin/testing/api/ads.php" animated:NO];
    //[request release];
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
        HTTPRequest *response = (HTTPRequest *)request;
    if (response.type == HTTPRequestAdImage) {
        adImage.image = [UIImage imageWithData:response.buffer];
       
    } else {
        NSString *jsonString = [[[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding] autorelease];
        self.results = [jsonString JSONValue];
        NSLog(@"%@", results);
        [self loadAdImageWithURL:[results objectForKey:@"ad_file"]];
    }
}

- (void)loadAdImageWithURL:(NSString *)url {
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:url animated:NO];
    [request setType:HTTPRequestAdImage];
    //[request release];
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
