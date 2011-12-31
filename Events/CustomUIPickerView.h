//
//  CustomUIPickerView.h
//  Events
//
//  Created by George Shank on 12/7/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUIPickerView : UIView
{
    UILabel *title;
    UIImageView *icon;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIImageView *icon;

@end
