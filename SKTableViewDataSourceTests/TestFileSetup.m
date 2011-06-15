#import "TestFileSetup.h"

@implementation TestFileSetup

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

@end
