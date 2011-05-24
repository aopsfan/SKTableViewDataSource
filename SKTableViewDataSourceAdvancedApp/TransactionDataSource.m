//
//  TransactionDataSource.m
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 4/18/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "TransactionDataSource.h"
#import "Transaction.h"

@implementation TransactionDataSource

- (NSArray *)orderedSectionsForTableView {
    NSMutableArray *initialSections = [NSMutableArray arrayWithArray:[super orderedSectionsForTableView]];
    NSMutableArray *newSections = [NSMutableArray arrayWithCapacity:[initialSections count]-1];
    NSDate *deleteThisDate = nil;
    
    for (NSDate *date in initialSections) {
        if ([date isEqualToDate:[[NSDate date] dateWithoutTime]]) {
            [newSections addObject:[date dateWithoutTime]];
            deleteThisDate = [NSDate dateWithTimeInterval:0 sinceDate:[date dateWithoutTime]];
        }
    }
    
    if (deleteThisDate) {
        [initialSections removeObject:deleteThisDate];
    }
    
    [newSections addObjectsFromArray:initialSections];
    return newSections;
}

@end
