//
//  toDoTableView.m
//  Clear
//
//  Created by Charles Liu on 2014-07-30.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "toDoTableView.h"

@implementation toDoTableView{
    NSMutableSet *_reuseCells;
    Class _cellClass;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        _reuseCells = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    self.scrollView.frame = self.frame;
    [self refreshView];
}



// based on the current location to recycle off-screen cells and
// creates new ones

- (void)refreshView {
    if (CGRectIsNull(self.scrollView.frame)) return;
    
    //set the scrollview height
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, [_dataSource numberOfRows] * TODO_ROW_HEIGHT);
    
    //remove cells that are no visible
    for (UIView *cell in [self cellSubviews]){
        if (cell.frame.origin.y + cell.frame.size.height < self.scrollView.contentOffset.y ){
            [self recycleCell:cell];
            //NSLog(@"1");
        }
        
        if (cell.frame.origin.y > self.scrollView.contentOffset.y + self.scrollView.frame.size.height) {
            [self recycleCell:cell];
            //NSLog(@"1");
        }
    }
    
    //ensure you have a cell for each row
    int firstVisibleIndex = MAX(0, floor(self.scrollView.contentOffset.y/ TODO_ROW_HEIGHT));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisibleIndex + 1 + ceil(self.scrollView.frame.size.height/ TODO_ROW_HEIGHT));
    
    //add the cells
    for (int row = firstVisibleIndex; row < lastVisibleIndex; row++) {
        UIView *cell = [self cellForRow:row];
        if (!cell) {
            //set its location
            UIView *cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row  * TODO_ROW_HEIGHT;
            CGRect frame = CGRectMake(0, topEdgeForRow, self.scrollView.frame.size.width, TODO_ROW_HEIGHT);
            cell.frame = frame;
            // add to the view
            [self.scrollView insertSubview:cell atIndex:0];
        }
    }
}

// recycle the cell
- (void)recycleCell:(UIView *)cell {
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

// return the cell for given row, or nil if it doesn't exist
- (UIView *)cellForRow:(NSInteger)row {
    float topEdgeForNow = row * TODO_ROW_HEIGHT;
    for (UIView *cell in [self cellSubviews]){
        if (cell.frame.origin.y == topEdgeForNow){
            return cell;
        }
    }
    return nil;
}

- (NSArray *)cellSubviews {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[ToDoItemCell class]]){
            [cells addObject:subView];
        }
    }
    return cells;
}

- (NSArray *)visibleCells {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UIView *subView in [self cellSubviews]){
        [cells addObject:subView];
    }
    
    NSArray *sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView *view1 = (UIView *)obj1;
        UIView *view2 = (UIView *)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.){
            return NSOrderedAscending;
        }
        else if (result < 0.0) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
        
    }];
    return sortedCells;
}

- (void)reloadData{
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

#pragma mark -- reuse cell

- (void)registerClassForCells:(Class)cellClass {
    _cellClass = cellClass;
}

- (UIView *)dequeueReusableCell {
    //obtain a cell from reuse pool
    UIView *cell = [_reuseCells anyObject];
    if (cell){
        NSLog(@"Returning a cell from the pool");
        [_reuseCells removeObject:cell];
    }
    
    if (!cell){
        NSLog(@"Creating a new cell");
        cell = [[_cellClass alloc] init];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
    //forward the delegate method
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - forwarding UIScrollView delegate
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]){
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]){
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}


#pragma mark - property setters
- (void)setDataSource:(id<toDoTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
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
