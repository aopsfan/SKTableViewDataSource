#import "SKDataFilterTests.h"
#import "SKDataFilter.h"

@implementation SKDataFilterTests

- (void)setUp {
    [super setUp];
    heightFilter = [[SKDataFilter where:@"height" isGreaterThan:[NSNumber numberWithInt:67]] retain];
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

- (void)testPredicateFilter {
    SKDataFilter *dataFilter = [SKDataFilter where:@"name" isEqualTo:@"Bruce Young Ricketts"];
    SKFilteredSet *set = [[[SKFilteredSet alloc] initWithObjects:[NSSet setWithArray:objects] predicateFilter:dataFilter] autorelease];
    NSUInteger count = [[set allObjects] count];
    
    STAssertTrue(count == 1, @"you have %i objects", count);
}

@end
