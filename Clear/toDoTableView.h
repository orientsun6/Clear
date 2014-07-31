//
//  toDoTableView.h
//  Clear
//
//  Created by Charles Liu on 2014-07-30.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toDoTableViewDataSource.h"

@interface toDoTableView : UIView

@property (nonatomic, assign) id <toDoTableViewDataSource> dataSource;

@end
