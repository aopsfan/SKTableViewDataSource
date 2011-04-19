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
    NSDate *deleteThisDate;
    
    for (NSDate *date in initialSections) {
        if ([date isEqualToDate:[[NSDate date] dateWithoutTime]]) {
            [newSections addObject:date];
            deleteThisDate = date;
        }
    }
    
    [initialSections removeObject:deleteThisDate];
    [newSections addObjectsFromArray:initialSections];
    return newSections;
}

@end
