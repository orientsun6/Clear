//
//  ViewController.h
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItemTableViewCellDelegate.h"
#import "toDoTableView.h"
#import "toDoTableViewDragAddNew.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet toDoTableView *tableView;

@end
