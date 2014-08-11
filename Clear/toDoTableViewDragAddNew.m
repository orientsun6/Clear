//
//  toDoTableViewDragAddNew.m
//  Clear
//
//  Created by Charles Liu on 2014-08-10.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "toDoTableViewDragAddNew.h"
#import "ToDoItemCell.h"


@implementation toDoTableViewDragAddNew{
    ToDoItemCell* _placeHolderCell;
    BOOL _pullDownInProgress;
    toDoTableView *_tableView;
    
}

- (id)initWithTableView:(toDoTableView *)tableView {
    self = [super init];
    if (self){
        _placeHolderCell = [[ToDoItemCell alloc] init];
        _placeHolderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        _tableView.delegate = self;
    }
    return self;
}

/*
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        _placeHolderCell = [[ToDoItemCell alloc] init];
        _placeHolderCell.backgroundColor = [UIColor redColor];
    }
    return self;
}
*/
 
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [_tableView insertSubview:_placeHolderCell atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[_tableView scrollViewDidScroll:scrollView];
    
    if (_pullDownInProgress && _tableView.scrollView.contentOffset.y <= 0.0f){
        //maintain the location of the placeholder
        _placeHolderCell.frame = CGRectMake(0, -_tableView.scrollView.contentOffset.y - TODO_ROW_HEIGHT, _tableView.frame.size.width, TODO_ROW_HEIGHT);
        _placeHolderCell.label.text = -_tableView.scrollView.contentOffset.y > TODO_ROW_HEIGHT ? @"Release to Add Item" : @"Pull to Add Item";
        _placeHolderCell.alpha = MIN(1.0f, -_tableView.scrollView.contentOffset.y/ TODO_ROW_HEIGHT);
    }
    else {
        _pullDownInProgress = false;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullDownInProgress && -_tableView.scrollView.contentOffset.y > TODO_ROW_HEIGHT) {
        // add a new Item
        [_tableView.dataSource itemAdded];
    }
    _pullDownInProgress = false;
    [_placeHolderCell removeFromSuperview];
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
