//
//  TodoItemTableViewCellDelegate.h
//  Clear
//
//  Created by Charles Liu on 2014-07-27.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@class ToDoItemCell;

@protocol TodoItemTableViewCellDelegate <NSObject>

-(void)toDoItemDeleted: (ToDoItem *)todoItem;

// Indicates that the edit process has begun for the given cell
-(void)cellDidBeginEditing:(ToDoItemCell *)cell;

// Indicates that the edit process has committed for the given cell
-(void)cellDidEndEditing:(ToDoItemCell *)cell;


@end
