//
//  ViewController.m
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "ViewController.h"
#import "ToDoItemCell.h"
#import "tableViewPinchToAdd.h"


@interface ViewController () <TodoItemTableViewCellDelegate, toDoTableViewDataSource>
{
    float _editingOffset;
    toDoTableViewDragAddNew *_dragAddNew;
    tableViewPinchToAdd *_pinchAddNew;
}
//array of todo list items
@property (strong, nonatomic) NSMutableArray *toDoItems;

@end

@implementation ViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    /*
    //old tableview
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor blackColor];
    
    [self.tableview registerClass:[ToDoItemCell class] forCellReuseIdentifier:@"cell"];
    
     */
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClassForCells:[ToDoItemCell class]];
    
    _toDoItems = [[NSMutableArray alloc] init];
    NSArray *items = @[@"Feed the cat", @"Buy eggs", @"Pack the bags for WWDC", @"Rule the web", @"Buy a new iPhone",
                       @"Find missing socks", @"Write a new tutorial", @"Master Objective-C", @"Remember your wedding anniversary!",
                       @"Drink less beer", @"Learn to draw", @"Take the car to the garage", @"Sell things on eBay", @"Learn to juggle",
                       @"Give up"];
    for (NSString *item in items){
        ToDoItem *todoItem = [[ToDoItem alloc] initWithText:item];
        [_toDoItems addObject:todoItem];
    }
    
    _dragAddNew = [[toDoTableViewDragAddNew alloc] initWithTableView:self.tableView];
    _pinchAddNew = [[tableViewPinchToAdd alloc] initWithTableView:self.tableView];
    //NSLog(_toDoItems.description);
    
    //long press gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
}


#pragma mark -- Long Press
- (IBAction)longPressGestureRecognized:(id)sender {
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = 
    
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (index) {
                <#statements#>
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -- New datasource
- (NSInteger)numberOfRows {
    return _toDoItems.count;
}

- (ToDoItemCell *)cellForRow:(NSInteger)row{
    ToDoItemCell *cell = (ToDoItemCell *)[self.tableView dequeueReusableCell];
    ToDoItem *item = _toDoItems[row];
    cell.toDoItem = item;
    cell.delegate = self;
    cell.backgroundColor = [self colorForIndex:row];
    return cell;
}

- (void)itemAdded {
    //create a new item
    [self itemAddedAtIndex:0];

}

- (void)itemAddedAtIndex:(NSUInteger)index{
    
    ToDoItem *toDoItem = [[ToDoItem alloc] init];
    [_toDoItems insertObject:toDoItem atIndex:index];
    
    [_tableView reloadData];
    ToDoItemCell *editCell;
    for (ToDoItemCell *cell in [_tableView visibleCells]){
        if (cell.toDoItem == toDoItem) {
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
}

#pragma mark -- delegate method

- (void)toDoItemDeleted:(ToDoItem *)todoItem{
 
    //use tableview to animate the removal of row
    NSUInteger index = [self.toDoItems indexOfObject:todoItem];
    //[self.tableView beginUpdates];
    [self.toDoItems removeObjectAtIndex:index];
    //[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
     
    
    float delay = 0.;
    [_toDoItems removeObject:todoItem];
    
    //find the visible cells
    NSArray *visibleCells = [self.tableView visibleCells];
    
    UIView *lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    //iterate over all of the cells
    for (ToDoItemCell *cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 if (cell == lastView){
                                     [self.tableView reloadData];
                                 }
                             }];
            delay += 0.03;
        }
        if (cell.toDoItem == todoItem){
            startAnimating = YES;
            cell.hidden = YES;
        }
    }
    
}


- (void)cellDidBeginEditing:(ToDoItemCell *)editingCell {
    _editingOffset = self.tableView.scrollView.contentOffset.y - editingCell.frame.origin.y;
    for (ToDoItemCell *cell in [self.tableView visibleCells]){
        [UIView animateWithDuration:0.3 animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
            if (cell != editingCell) {
                cell.alpha = 0.3;
            }
        }];
    }
}

- (void)cellDidEndEditing:(ToDoItemCell *)editingCell {
    for (ToDoItemCell *cell in [self.tableView visibleCells]){
        [UIView animateWithDuration:0.3 animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
            if (cell != editingCell) {
                cell.alpha = 1.;
            }
        }];
    }
}




#pragma mark -- cell styling


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

- (UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.toDoItems.count - 1;
    float val = ((float)index) / ((float)itemCount) * 0.6;
    return [UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.];
}


/*

#pragma mark -- datasource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ident = @"cell";
    
    ToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[ToDoItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ToDoItem *item = self.toDoItems[indexPath.row];
    
    //cell.textLabel.text = item.text;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.toDoItem = item;
    
    return cell;
    
}

*/

@end
