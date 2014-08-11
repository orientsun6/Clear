//
//  toDoTableView.h
//  Clear
//
//  Created by Charles Liu on 2014-07-30.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toDoTableViewDataSource.h"
#import "ToDoItemCell.h"


@interface toDoTableView : UIView <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) id <toDoTableViewDataSource> dataSource;
@property (nonatomic, assign) id <UIScrollViewDelegate> delegate;

- (UIView *)dequeueReusableCell;

- (void)registerClassForCells:(Class)cellClass;

- (NSArray *)visibleCells;

- (void)reloadData;

@end
