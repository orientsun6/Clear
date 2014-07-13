//
//  ToDoItem.h
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic) BOOL completed;

- (id)initWithText: (NSString *)text;

+ (id)toDoItemWithText: (NSString *)text;

@end
