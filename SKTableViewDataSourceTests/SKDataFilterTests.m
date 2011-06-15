#import "SKDataFilterTests.h"
#import "SKDataFilter.h"

@implementation SKDataFilterTests

- (void)testFilter {
    SKDataFilter *dataFilter = [[[SKDataFilter alloc] init] autorelease];
    dataFilter.selector = @selector(height);
    dataFilter.filterType = SKDataFilterTypeExclude;
    dataFilter.comparisonOperator = SKDataFilterComparisonOperatorEquals;
    dataFilter.comparisonObject = [NSNumber numberWithInt:67];
    
    [dataSource addFilter:dataFilter];
    [dataSource removeFilteredObjects];
    
    STAssertTrue([dataSource numberOfObjects] == 4, @"You have %i objects", [dataSource numberOfObjects]);
}

@end
