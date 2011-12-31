//
//  IngredientTableViewCell.h
//  Artisan Bakeshop
//
//  Created by George Shank on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientTableViewCell : UITableViewCell
{
    UILabel *label;
    UILabel *detalLabel;
    UILabel *disclosureLabel;
    UIImageView *categoryImage;
    UILabel *priceLabel;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UILabel *disclosureLabel;
@property (nonatomic, retain) UIImageView *categoryImage;
@property (nonatomic, retain) UILabel *priceLabel;

@end
