//
//  ToDoItemCell.m
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "ToDoItemCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ToDoItemCell{
    CAGradientLayer *_gradientLayer;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                                  (id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;                                        
}


@end
