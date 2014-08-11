//
//  tableViewPinchToAdd.m
//  Clear
//
//  Created by Charles Liu on 2014-08-11.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "tableViewPinchToAdd.h"
#import "ToDoItemCell.h"

//represent the upper and lower points of a pinch
struct touchPoints {
    CGPoint upper;
    CGPoint lower;
};

typedef struct touchPoints touchPoints;

@implementation tableViewPinchToAdd{
    toDoTableView *_tableView;
    ToDoItemCell *_placeholderCell;
    int _pointOneCellIndex;
    int _pointTwoCellIndex;
    
    touchPoints _initialTouchPoints;
    BOOL _pinchInProgress;
    BOOL _pinchExceededRequiredDistance;
    
}

- (id)initWithTableView:(toDoTableView *)tableView{
    self = [super init];
    if (self) {
        _placeholderCell = [[ToDoItemCell alloc] init];
        _placeholderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        //add pinch gesture
        UIGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_tableView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self pinchStarted:recognizer];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (_pinchInProgress && recognizer.numberOfTouches == 2) {
                [self pinchChanged:recognizer];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [self pinchEnded:recognizer];
        }
            break;
        default:
            break;
    }
}

- (void)pinchStarted:(UIGestureRecognizer *)recognizer{
    _initialTouchPoints = [self getNormalizedTouchPoints:recognizer];
    
    _pointOneCellIndex = -1;
    _pointTwoCellIndex = -1;
    NSArray *visibleCells = [_tableView visibleCells];
    for (int i = 0; i < visibleCells.count; i++) {
        UIView *cell = (UIView *)visibleCells[i];
        if ([self viewContainsPoint:cell withPoint:_initialTouchPoints.upper]){
            _pointOneCellIndex = i;
            //cell.backgroundColor = [UIColor purpleColor];
        }
        
        if ([self viewContainsPoint:cell withPoint:_initialTouchPoints.lower]) {
            _pointTwoCellIndex = i;
            //cell.backgroundColor = [UIColor purpleColor];
        }
    }
    
    //check if they are neighbors
    if (abs(_pointTwoCellIndex - _pointOneCellIndex) == 1) {
        _pinchInProgress = YES;
        _pinchExceededRequiredDistance = NO;
        
        //show placeholder cell
        ToDoItemCell *precedingCell = (ToDoItemCell *)([_tableView visibleCells][_pointOneCellIndex]);
        _placeholderCell.frame = CGRectOffset(precedingCell.frame, 0.0f, TODO_ROW_HEIGHT / 2.0f ); // /2.0f
        [_tableView.scrollView insertSubview:_placeholderCell atIndex:0];
    }
    
}

- (void)pinchChanged:(UIGestureRecognizer *)recognizer {
    touchPoints currentTouchPoints = [self getNormalizedTouchPoints:recognizer];

    //determine by how much each touch point has changed, and take the minimum delta
    float upperDelta = currentTouchPoints.upper.y - _initialTouchPoints.upper.y;
    float lowerDelta = _initialTouchPoints.lower.y - currentTouchPoints.lower.y;
    float delta = - MIN(0, MIN(upperDelta, lowerDelta));
    
    NSArray *visibleCells = [_tableView visibleCells];
    for (int i = 0; i < visibleCells.count; i++) {
        UIView *cell = (UIView *)visibleCells[i];
        if (i <= _pointOneCellIndex) {
            cell.transform = CGAffineTransformMakeTranslation(0, -delta); //move them up
        }
        if (i >= _pointTwoCellIndex) {
            cell.transform = CGAffineTransformMakeTranslation(0, delta); // move them down
        }
    }
    
    float gapSize = delta * 2;
    float cappedGapSize = MIN(gapSize, TODO_ROW_HEIGHT);
    _placeholderCell.transform = CGAffineTransformMakeScale(1.0f, cappedGapSize / TODO_ROW_HEIGHT);
    _placeholderCell.label.text = gapSize > TODO_ROW_HEIGHT ? @"Release to Add Item" : @"Pull to Add Item";
    _placeholderCell.alpha = MIN(1.0f, gapSize/ TODO_ROW_HEIGHT);
    
    _pinchExceededRequiredDistance = gapSize > TODO_ROW_HEIGHT;
    
}

- (void)pinchEnded:(UIGestureRecognizer *)recognizer {
    _pinchInProgress = NO;
    
    //remove the placeholder cell
    _placeholderCell.transform = CGAffineTransformIdentity;
    [_placeholderCell removeFromSuperview];
    
    if (_pinchExceededRequiredDistance) {
        //add a new item
        int indexOffset = floor(_tableView.scrollView.contentOffset.y / TODO_ROW_HEIGHT);
        [_tableView.dataSource itemAddedAtIndex:_pointTwoCellIndex + indexOffset];
    }
    else{
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             NSArray *visibleCells = [_tableView visibleCells];
                             for ( ToDoItemCell *cell in visibleCells) {
                                 cell.transform = CGAffineTransformIdentity;
                             }
                         }
                         completion:nil];
    }
    
}

//returns the two points, ordering them to ensure that upper and lower
// are correctly identified.

- (touchPoints) getNormalizedTouchPoints:(UIGestureRecognizer *)recognizer {
    CGPoint pointOne = [recognizer locationOfTouch:0 inView:_tableView];
    CGPoint pointTwo = [recognizer locationOfTouch:1 inView:_tableView];
    pointOne.y += _tableView.scrollView.contentOffset.y;
    pointTwo.y += _tableView.scrollView.contentOffset.y;
    
    if (pointOne.y > pointTwo.y) {
        CGPoint temp = pointOne;
        pointOne = pointTwo;
        pointTwo = temp;
    }
    
    touchPoints points = {pointOne, pointTwo};
    return points;
}

- (BOOL) viewContainsPoint:(UIView *)view withPoint:(CGPoint)point {
    CGRect frame = view.frame;
    return (frame.origin.y < point.y) && (frame.origin.y + frame.size.height) > point.y;
}

@end
