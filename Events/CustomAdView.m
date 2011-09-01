//
//  CustomAdView.m
//  Events
//
//  Created by George Shank on 8/29/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CustomAdWebView.h"
#import "CustomAdView.h"
#import "HTTPRequest.h"
#import "JSON.h"

@implementation CustomAdView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //NSLog(@"Custom ad was initiated");
        self.userInteractionEnabled = YES;
        adImage = [[UIImageView alloc] init];
        adImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        adButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [adButton addTarget:self action:@selector(loadAdPage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:adImage];
        [self addSubview:adButton];
        
        adTime = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getAdFromServer) userInfo:nil repeats:YES];
        [self getAdFromServer];
        
    }
    return self;
}


- (void)loadAdPage:(NSString *)url {
   if([[self delegate] respondsToSelector:@selector(loadAdPage:)]) {
       [[self delegate] loadAdPage:@"http://www.google.com"];
	}
   // CustomAdWebView *webView = [[CustomAdWebView alloc] initWithNibName:@"CustomAdWebView" bundle:nil webSite:[NSURL URLWithString:@"http://www.google.com"]];
}

- (void)getAdFromServer {
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:@"http://www.google.com" animated:NO];
    //[request release];
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
        HTTPRequest *response = (HTTPRequest *)request;
    if (response.type == HTTPRequestAdImage) {
        adImage.image = [UIImage imageWithData:response.buffer];
       
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding];
        //NSDictionary *results = [jsonString JSONValue];
        NSLog(@"%@", jsonString);
        [self loadAdImageWithURL:@"http://cdn.macrumors.com/article/2010/07/01/123339-nissan_iad_banner.jpg"];
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
