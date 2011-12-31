//
//  IngredientTableViewCell.m
//  Artisan Bakeshop
//
//  Created by George Shank on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngredientTableViewCell.h"

@implementation IngredientTableViewCell
@synthesize disclosureLabel, label, detailLabel, categoryImage, priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        label = [[UILabel alloc] init];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        
        detailLabel = [[UILabel alloc] init];
        detailLabel.textAlignment = UITextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:8];
        
        disclosureLabel = [[UILabel alloc] init]; 
        disclosureLabel.textAlignment = UITextAlignmentRight;
        [disclosureLabel setBackgroundColor:[UIColor clearColor]];
        [disclosureLabel setTextColor:[UIColor grayColor]];
        
        priceLabel = [[UILabel alloc] init]; 
        priceLabel.textAlignment = UITextAlignmentRight;
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextColor:[UIColor grayColor]];
        
        categoryImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:disclosureLabel];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:categoryImage];
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
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    

    //self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, 140, self.textLabel.frame.size.height);
    
    frame= CGRectMake(boundsX+100 ,5, 200, 25);
    label.frame = frame;
    
    frame= CGRectMake(boundsX+100 ,30, 100, 15);
    detailLabel.frame = frame;
    
    frame = CGRectMake(235, 16, 80, 35);
    disclosureLabel.frame = frame;
    
    frame = CGRectMake(232, 21, 20, 20);
    categoryImage.frame = frame;
    
    frame = CGRectMake(162, 16, 65, 35);
    priceLabel.frame = frame;
}

@end
