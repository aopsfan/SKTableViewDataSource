//
//  SKTableViewDataSourceTests.m
//  SKTableViewDataSourceTests
//
//  Created by Bruce Ricketts on 3/31/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKTableViewDataSourceTests.h"


@implementation SKTableViewDataSourceTests

- (void)setUp
{
    [super setUp];
    
    emily        = [[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
    bruce        = [[Dude alloc] initWithName:@"Bruce Young Ricketts" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:67]];
    tom          = [[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
    michael      = [[Dude alloc] initWithName:@"Michael Jordan" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:100]];
    emilysTwin   = [[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
    brucesTwin   = [[Dude alloc] initWithName:@"Ecurb Young Ricketts" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:67]];
    tomsTwin     = [[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
    michaelsTwin = [[Dude alloc] initWithName:@"Sleahcim Jordan" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:100]];
    
    
    objects                          = [[NSMutableArray alloc] initWithObjects:emily, bruce, tom, michael, emilysTwin, brucesTwin, tomsTwin, michaelsTwin, nil];
    dataSource                       = [[SKTableViewDataSource alloc] initWithSet:[NSSet setWithArray:objects]];
    dataSource.sortSelector          = @selector(height);
    dataSource.sectionOrderAscending = YES;
    dataSource.rowOrderAscending     = YES;
}

- (void)tearDown
{
    [dataSource release];
    [objects release];
    [emily release];
    [bruce release];
    [tom release];
    [michael release];
    [emilysTwin release];
    [tomsTwin release];
    [brucesTwin release];
    [michaelsTwin release];
    
    [super tearDown];
}

- (void)testDictionaryHasOutput
{
    STAssertNotNil(dataSource.dictionary, @"dictionary (%@) should contain objects", dataSource.dictionary);
}

- (void)testSectionOrderAscending {
    dataSource.sectionOrderAscending = YES;
    NSNumber *height = (NSNumber *)[[dataSource orderedSectionsForTableView] objectAtIndex:0];
    NSNumber *testHeight = [NSNumber numberWithInt:67];
    
    STAssertEqualObjects(height, testHeight, @"The first object in the ordered sections should be 67, it is %@", height);
}

- (void)testRowOrderAscending {
    dataSource.rowOrderAscending = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
    NSString *testName = @"Emily Simpson Miller";
    
    STAssertTrue([dude.name isEqualToString:testName], @"You have %@", dude.name);
}

- (void)testRowOrderDescending {
    dataSource.rowOrderAscending = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
    NSString *testName = @"Ylime Simpson Miller";
    
    STAssertTrue([dude.name isEqualToString:testName], @"You have %@", dude.name);
    dataSource.rowOrderAscending = YES;
}


- (void)testSectionOrderDescending {
    dataSource.sectionOrderAscending = NO;
    NSNumber *height = (NSNumber *)[[dataSource orderedSectionsForTableView] objectAtIndex:1];
    NSNumber *testHeight = [NSNumber numberWithInt:83];
    
    STAssertEqualObjects(height, testHeight, @"The second object in the ordered sections should be 83, it is %@", height);
    
    dataSource.sectionOrderAscending = YES;
}

- (void)testObjectsInSection {
    NSSet *someObjects = [NSSet setWithArray:[dataSource orderedObjectsForSection:0]];
    NSSet *testObjects = [NSSet setWithObjects:emily, emilysTwin, bruce, brucesTwin, nil];
    
    STAssertEqualObjects(someObjects, testObjects, @"In section 0, you have %@ instead of %@", someObjects, testObjects);
}

- (void)testOrderOfObjectsInSectionZero {
    Dude *dude = (Dude *)[[dataSource orderedObjectsForSection:0] objectAtIndex:0];
    
    STAssertEqualObjects(dude, emily, @"dude (%@) should be emily (%@)", dude.name, emily.name);
}

- (void)testSectionForSectionIdentifier {
    STAssertTrue([dataSource sectionForSectionIdentifier:[NSNumber numberWithInt:83]] == 1,
                 @"section is %i", [dataSource sectionForSectionIdentifier:[NSNumber numberWithInt:83]]);
}

- (void)testIndexPathOfObject {
    NSIndexPath *testIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    STAssertEqualObjects([dataSource indexPathForObject:bruce], testIndexPath, @"index path is %@", [dataSource indexPathForObject:tom]);
}

@end
