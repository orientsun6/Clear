//
//  ViewController.m
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "ViewController.h"
#import "ToDoItemCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, TodoItemTableViewCellDelegate>
//array of todo list items
@property (strong, nonatomic) NSMutableArray *toDoItems;

@end

@implementation ViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor blackColor];
    
    [self.tableview registerClass:[ToDoItemCell class] forCellReuseIdentifier:@"cell"];
    
    _toDoItems = [[NSMutableArray alloc] init];
    NSArray *items = @[@"Feed the cat", @"Buy eggs", @"Pack the bags for WWDC", @"Rule the web", @"Buy a new iPhone",
                       @"Find missing socks", @"Write a new tutorial", @"Master Objective-C", @"Remember your wedding anniversary!",
                       @"Drink less beer", @"Learn to draw", @"Take the car to the garage", @"Sell things on eBay", @"Learn to juggle",
                       @"Give up"];
    for (NSString *item in items){
        ToDoItem *todoItem = [[ToDoItem alloc] initWithText:item];
        [_toDoItems addObject:todoItem];
    }
    
    
    
    
    //NSLog(_toDoItems.description);
    
}

#pragma mark -- delegate method

- (void)toDoItemDeleted:(ToDoItem *)todoItem{
    //use tableview to animate the removal of row
    NSUInteger index = [self.toDoItems indexOfObject:todoItem];
    [self.tableview beginUpdates];
    [self.toDoItems removeObjectAtIndex:index];
    [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableview endUpdates];
}

#pragma mark -- cell styling

- (UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.toDoItems.count - 1;
    float val = ((float)index) / ((float)itemCount) * 0.6;
    return [UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}


#pragma mark -- datasource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ident = @"cell";
    
    ToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    ToDoItem *item = self.toDoItems[indexPath.row];
    
    cell.textLabel.text = item.text;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.toDoItem = item;
    
    return cell;
    
}



@end
