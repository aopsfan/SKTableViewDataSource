#import "SKTableViewController.h"

@implementation SKTableViewController

- (id)init {
    if ((self = [super init])) {
        dataSource = [[SKTableViewDataSource alloc] initWithSet:[NSSet set] target:self];
        self.tableView.dataSource = dataSource;
        dataSource.tableView = self.tableView;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [dataSource takeTableViewSnapshot];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

@end
