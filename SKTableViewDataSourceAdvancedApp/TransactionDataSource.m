#import "TransactionDataSource.h"
#import "Transaction.h"

@implementation TransactionDataSource

- (NSArray *)orderedSectionsForTableViewInfo:(SKTableViewInfo *)info {
    NSMutableArray *initialSections = [NSMutableArray arrayWithArray:[super orderedSectionsForTableViewInfo:info]];
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
