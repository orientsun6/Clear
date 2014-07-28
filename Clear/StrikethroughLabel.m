//
//  StrikethroughLabel.m
//  Clear
//
//  Created by Charles Liu on 2014-07-27.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "StrikethroughLabel.h"

@implementation StrikethroughLabel{
    CALayer *_strikethroughLayer;
}

const float STRIKEOUT_THICKNESS = 2.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self resizeStrikeThrough];
}

//resize the strikethought layer to match the current label text
- (void)resizeStrikeThrough {
    CGSize textSize = [self.text sizeWithFont:self.font];
    _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKEOUT_THICKNESS);
}

#pragma mark -- property setter
- (void) setStrikethrough:(BOOL)strikethrough{
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
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
