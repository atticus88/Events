//
//  CustomAdWebView.h
//  Events
//
//  Created by Klint Holmes on 8/31/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAdView.h"

@interface CustomAdWebView : UIViewController<CustomAdViewDelegate> {
    UIWebView *web;
    NSURL *url;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webSite:(NSURL *)url;

@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) NSURL *url;

-(IBAction)dismiss:(id)sender;
-(void)loadAdPage:(NSString *)url;
@end
