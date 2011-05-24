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

- (void)testTableViewInfoHasOutput
{
    STAssertNotNil(dataSource.tableViewInfo, @"info (%@) should contain objects", dataSource.tableViewInfo);
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
    
    STAssertEqualObjects([dataSource indexPathForObject:bruce], testIndexPath, @"index path is %@", [dataSource indexPathForObject:bruce]);
}

- (void)testAddObject {
    Dude *newDude = [Dude dudeWithName:@"Dude" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:83]];
    [dataSource addObject:newDude];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    STAssertEqualObjects([dataSource indexPathForObject:newDude], indexPath, @"index path is %@", [dataSource indexPathForObject:newDude]);
    
    [dataSource deleteObject:newDude];
}

- (void)testDeleteObject {
    [dataSource deleteObject:emilysTwin];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    STAssertEqualObjects([dataSource objectForIndexPath:indexPath], bruce, @"object is %@", [dataSource objectForIndexPath:indexPath]);
    
    [dataSource addObject:emilysTwin];
}

- (void)testSetObjects {
    Dude *dude1 = [Dude dudeWithName:@"Dude1" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:67]];
    Dude *dude2 = [Dude dudeWithName:@"Dude2" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:83]];
    NSSet *newObjects = [NSSet setWithObjects:emilysTwin, tomsTwin, brucesTwin, dude1, dude2, nil];
    [dataSource setObjects:newObjects];
    NSArray *testArrayInSectionZero = [NSArray arrayWithObjects:dude1, emilysTwin, brucesTwin, nil];
    NSArray *testArrayInSectionOne  = [NSArray arrayWithObjects:dude2, tomsTwin, nil];
    
    STAssertEqualObjects([dataSource orderedObjectsForSection:0], testArrayInSectionZero, @"");
    STAssertEqualObjects([dataSource orderedObjectsForSection:1], testArrayInSectionOne, @"");
    
    [dataSource setObjects:[NSSet setWithArray:objects]];
}

@end
