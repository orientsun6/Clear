//
//  toDoTableViewDataSource.h
//  Clear
//
//  Created by Charles Liu on 2014-07-30.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol toDoTableViewDataSource <NSObject>

- (NSInteger)numberOfRows;

- (UIView *)cellForRow:(NSInteger)row;

- (void)itemAdded;

- (void)itemAddedAtIndex:(NSUInteger)index;


@end


