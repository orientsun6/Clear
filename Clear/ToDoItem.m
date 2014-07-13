//
//  ToDoItem.m
//  Clear
//
//  Created by Charles Liu on 2014-07-13.
//  Copyright (c) 2014 Charles Liu. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (id)initWithText: (NSString *)text{
    if (self = [super init]){
        self.text = text;
    }
    return self;
   
}

+ (id)toDoItemWithText: (NSString *)text{
    return [[ToDoItem alloc] initWithText:text];
}




@end



