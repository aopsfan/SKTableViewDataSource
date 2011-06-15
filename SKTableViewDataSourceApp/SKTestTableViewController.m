#import "SKTestTableViewController.h"
#import "Dude.h"

@implementation SKTestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        Dude *emily        = [[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
        Dude *bruce        = [[Dude alloc] initWithName:@"Bruce Young Ricketts" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:67]];
        Dude *tom          = [[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
        Dude *michael      = [[Dude alloc] initWithName:@"Michael Jordan" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:100]];
        Dude *emilysTwin   = [[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
        Dude *brucesTwin   = [[Dude alloc] initWithName:@"Ecurb Young Ricketts" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:67]];
        Dude *tomsTwin     = [[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
        Dude *michaelsTwin = [[Dude alloc] initWithName:@"Sleahcim Jordan" hairColor:[UIColor clearColor] height:[NSNumber numberWithInt:100]];
        data = [[NSSet alloc] initWithObjects:emily, bruce, tom, michael, emilysTwin, brucesTwin, tomsTwin, michaelsTwin, nil];
        
        dataSource = [[SKTableViewDataSource alloc] initWithSet:data target:self sortSelector:@selector(height)];
        SKDataFilter *dataFilter = [[[SKDataFilter alloc] initWithSelector:@selector(height)
                                                          comparisonObject:[NSNumber numberWithInt:100]
                                                                filterType:SKDataFilterTypeExclude
                                                        comparisonOperator:SKDataFilterComparisonOperatorLessThan] autorelease];
        [dataSource addFilter:dataFilter];
        [dataSource removeFilter:dataFilter];
        
        self.tableView.dataSource = dataSource;
        
        self.title = @"Dudes";
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [dataSource release];
    
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSNumber *)[dataSource identifierForSection:section] stringValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
    cell.textLabel.text = dude.name;
    
    // Configure the cell...
    
    return cell;
}

@end
