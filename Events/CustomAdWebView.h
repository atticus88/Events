//
//  CustomAdWebView.h
//  Events
//
//  Created by Klint Holmes on 8/31/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAdWebView : UIViewController {
    UIWebView *web;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webSite:(NSURL *)url;

@property (nonatomic, retain) IBOutlet UIWebView *web;

-(IBAction)dismiss:(id)sender;

@end
