#import "SKControllerTestViewController.h"
#import "Dude.h"

@implementation SKControllerTestViewController

- (id)init {
    self = [super init];
    if (self) {
        Dude *emily      = [[[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tom        = [[[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *emilysTwin = [[[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]] autorelease];
        Dude *tomsTwin   = [[[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]] autorelease];
        Dude *guy        = [[[Dude alloc] initWithName:@"Guy Moron Idiot" hairColor:[UIColor blackColor] height:[NSNumber numberWithInt:67]] autorelease];
        
        [dataSource setObjects:[NSSet setWithObjects:emily, tom, emilysTwin, tomsTwin, guy, nil]];
        dataSource.sortSelector = @selector(height);
        
        self.title = @"Dudes";
    }
    
    return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSNumber *)[dataSource identifierForSection:section] stringValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Dude *dude = (Dude *)[dataSource objectForIndexPath:indexPath];
    cell.textLabel.text = dude.name;
    
    return cell;
}

@end
