//
//  ToDoItemCell.h
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"
#import "TodoItemTableViewCellDelegate.h"

@interface ToDoItemCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic) ToDoItem *toDoItem;

@property (nonatomic, assign) id <TodoItemTableViewCellDelegate> delegate;

@end
