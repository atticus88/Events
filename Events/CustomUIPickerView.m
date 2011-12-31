//
//  CustomUIPickerView.m
//  Events
//
//  Created by George Shank on 12/7/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import "CustomUIPickerView.h"

@implementation CustomUIPickerView
@synthesize title, icon;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        title = [[UILabel alloc] init];
        title.textAlignment = UITextAlignmentLeft;

        title.font = [UIFont boldSystemFontOfSize:24];
        
                
        icon = [[UIImageView alloc] init];
        
        [self addSubview:title];
        [self addSubview:icon];
        [title setBackgroundColor:[UIColor clearColor]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame= CGRectMake(boundsX+5 ,5, 200, 35);
    title.frame = frame;
    
    frame = CGRectMake(boundsX+270, 11, 20, 20);
    icon.frame = frame;
}

@end
