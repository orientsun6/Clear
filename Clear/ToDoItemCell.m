//
//  ToDoItemCell.m
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "ToDoItemCell.h"
#import "StrikethroughLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation ToDoItemCell{
    CAGradientLayer *_gradientLayer;
    CGPoint _originCenter;
    BOOL _deleteOnDragRelease;
    StrikethroughLabel *_label;
    CALayer *_itemCompleteLayer;
    BOOL _markCompleteOnDragRelease;
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
        
        //add a layer renders a green background when an item is complete
        _itemCompleteLayer = [CALayer layer];
        _itemCompleteLayer.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
        _itemCompleteLayer.hidden = YES;
        [self.contentView.layer addSublayer:_itemCompleteLayer];
        
        //create label renders to-do item text
        _label = [[StrikethroughLabel alloc] initWithFrame:CGRectNull];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        //remove the default blue highlight for the selected cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        //gesture
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

const float LABEL_LEFT_MARGIN = 15.0f;

- (void)layoutSubviews {
    [super layoutSubviews];
    //ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0, self.bounds.size.width - LABEL_LEFT_MARGIN, self.bounds.size.height);
}


- (void)setToDoItem:(ToDoItem *)toDoItem {
    _toDoItem = toDoItem;
    _label.text = toDoItem.text;
    _label.strikethrough = toDoItem.completed;
    _itemCompleteLayer.hidden = !toDoItem.completed;
}

#pragma mark -- horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    //check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    
    return NO;
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            _originCenter = self.center;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [recognizer translationInView:self];
            self.center = CGPointMake(_originCenter.x + translation.x, _originCenter.y);
            _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width/2;
            _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width/2;
            
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
            if (!_deleteOnDragRelease){
                [UIView animateWithDuration:0.2 animations:^{
                    self.frame = originalFrame;
                }];
            }
            else {
                [self.delegate toDoItemDeleted:self.toDoItem];
            }
            
            if (_markCompleteOnDragRelease){
                self.toDoItem.completed = YES;
                _itemCompleteLayer.hidden = NO;
                _label.strikethrough = YES;
            }
            

        }
            
            break;
        default:
            break;
    }
}

@end
