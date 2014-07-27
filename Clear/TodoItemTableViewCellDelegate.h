//
//  TodoItemTableViewCellDelegate.h
//  Clear
//
//  Created by Charles Liu on 2014-07-27.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@protocol TodoItemTableViewCellDelegate <NSObject>

-(void)toDoItemDeleted: (ToDoItem *)todoItem;

@end
