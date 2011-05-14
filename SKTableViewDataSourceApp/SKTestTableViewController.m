#import "SKTestTableViewController.h"
#import "Dude.h"

@implementation SKTestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        Dude *emily      = [[[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tom        = [[[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *emilysTwin = [[[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tomsTwin   = [[[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *guy        = [[[Dude alloc] initWithName:@"Guy Moron Idiot" hairColor:[UIColor blackColor] height:[NSNumber numberWithInt:67]] autorelease];
        data = [[NSSet alloc] initWithObjects:emily, tom, emilysTwin, tomsTwin, guy, nil];
        
        dataSource = [[SKTableViewDataSource alloc] initWithSet:data target:self];
        dataSource.sortSelector = @selector(initial);
        
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

#pragma mark - SKTableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[dataSource identifierForSection:section];
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
