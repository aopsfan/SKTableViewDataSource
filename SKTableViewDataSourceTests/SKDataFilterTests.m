#import "SKDataFilterTests.h"
#import "SKDataFilter.h"

@implementation SKDataFilterTests

- (void)setUp {
    [super setUp];
    
    heightFilter = [[SKDataFilter alloc] initWithSelector:@selector(height) comparisonObject:[NSNumber numberWithInt:67]
                                               filterType:SKDataFilterTypeIncludeOnly comparisonOperator:SKDataFilterComparisonOperatorGreaterThan];    
    nameFilter   = [[SKDataFilter alloc] initWithSelector:@selector(name) comparisonObject:@"Michael Jordan"];
}

- (void)testAddFilter {    
    [dataSource addFilter:heightFilter];
    
    STAssertTrue([[dataSource allObjects] count] == 8, @"you have numberOfObjects = %i", [[dataSource allObjects] count]);
    STAssertTrue([[dataSource displayedObjects] count] == 4, @"you have %i unfiltered objects", [[dataSource displayedObjects] count]);
    
    [dataSource removeFilter:heightFilter];
}

- (void)testRemoveFilter {
    [dataSource addFilter:heightFilter];
    [dataSource addFilter:nameFilter];
    
    STAssertTrue([[dataSource displayedObjects] count] == 1, @"you have %i unfiltered objects", [[dataSource displayedObjects] count]);
    
    [dataSource removeFilter:nameFilter];
    
    STAssertTrue([[dataSource displayedObjects] count] == 4, @"you have %i unfiltered objects", [[dataSource displayedObjects] count]);
    
    [dataSource removeFilter:heightFilter];
}

@end
