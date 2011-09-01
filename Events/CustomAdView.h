//
//  CustomAdView.h
//  Events
//
//  Created by George Shank on 8/29/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAdViewDelegate <NSObject>
@optional
- (void)loadAdPage:(NSString *)url;
@end


@interface CustomAdView : UIView {
    id <CustomAdViewDelegate> delegate;
    UIImageView *adImage;
    UIButton *adButton;
    NSTimer *adTime;
}

@property (retain) id delegate;

- (void)getAdFromServer;
- (void)loadAdImageWithURL:(NSString *)url;

@end
