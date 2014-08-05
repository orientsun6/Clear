//
//  toDoTableView.m
//  Clear
//
//  Created by Charles Liu on 2014-07-30.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "toDoTableView.h"

@implementation toDoTableView{
    // the scroll view that hosts the cells
    UIScrollView *_scrollView;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    _scrollView.frame = self.frame;
    [self refreshView];
}

const float TODO_ROW_HEIGHT = 50.f;

- (void)refreshView {
    //set the scrollview height
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * TODO_ROW_HEIGHT);
    
    //add the cells
    for (int row = 0; row < [_dataSource numberOfRows]; row++) {
        UIView *cell = [_dataSource cellForRow:row];
        //set its location
        float topEdgeForRow = row  * TODO_ROW_HEIGHT;
        CGRect frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, TODO_ROW_HEIGHT);
        cell.frame = frame;
        // add to the view
        [_scrollView addSubview:cell];
    }
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
