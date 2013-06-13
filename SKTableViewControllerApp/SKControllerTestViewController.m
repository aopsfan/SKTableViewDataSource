#import "SKControllerTestViewController.h"
#import "Dude.h"

@implementation SKControllerTestViewController

- (id)init {
    self = [super init];
    if (self) {
        Dude *emily      = [[Dude alloc] initWithName:@"Emily Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
        Dude *tom        = [[Dude alloc] initWithName:@"Tom Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
        Dude *emilysTwin = [[Dude alloc] initWithName:@"Ylime Simpson Miller" hairColor:[UIColor grayColor] height:[NSNumber numberWithInt:67]];
        Dude *tomsTwin   = [[Dude alloc] initWithName:@"Mot Charles Simpson" hairColor:[UIColor brownColor] height:[NSNumber numberWithInt:83]];
        Dude *guy        = [[Dude alloc] initWithName:@"Guy Moron Idiot" hairColor:[UIColor blackColor] height:[NSNumber numberWithInt:67]];
        
        [dataSource setObjects:[NSSet setWithObjects:emily, tom, emilysTwin, tomsTwin, guy, nil]];
        dataSource.sortSelector = @selector(height);
        
        self.title = @"Dudes";
    }
    
    return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = [(NSNumber *)[dataSource identifierForSection:section] stringValue];
    return [NSString stringWithFormat:@"Height is %@", string];
}

- (UITableViewCell *)cellForObject:(id)object {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = [(Dude *)object name];
    
    return cell;    
}

@end
