#import "SKAdvancedTestTableViewController.h"
#import <CoreData/CoreData.h>
#import "Transaction.h"
#import "SKOptionKeys.h"

@implementation SKAdvancedTestTableViewController

- (void)didPressAdd:(id)sender {
    Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
    transaction.date = [NSDate date];
    transaction.title = @"New Transaction";
    transaction.price = [NSNumber numberWithFloat:2.99];
    
    [context save:nil];
    
    [dataSource addObject:transaction updateTable:YES];
}

- (id)initWithStyle:(UITableViewStyle)style context:(NSManagedObjectContext *)aContext
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization        
        context = aContext;
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSDate *date = [[NSDate dateWithTimeIntervalSinceNow:-86400] dateWithoutTime];
        SKDataFilter *pFilter = [SKDataFilter where:@"displayableDate" isNotEqualTo:date];
        
        SKOptionKeys *optionKeys = [[[SKOptionKeys alloc] init] autorelease];
        optionKeys.entityName = [@"Transaction" mutableCopy];
        optionKeys.managedObjectContext = context;
        optionKeys.target = self;
        optionKeys.predicateFilter = pFilter;
        dataSource = [[TransactionDataSource alloc] initWithSortSelector:@selector(displayableDate)
                                                              optionKeys:optionKeys];
        
        dataSource.sortSelector = @selector(displayableDate);
        dataSource.sectionOrderAscending = NO;
        dataSource.tableView = self.tableView;
        dataSource.editingStyleInsertRowAnimation = UITableViewRowAnimationRight;
        dataSource.editingStyleDeleteRowAnimation = UITableViewRowAnimationLeft;
        
        self.tableView.dataSource = dataSource;
        
        self.title = @"Transactions";
    }
    return self;
}

- (void)dealloc
{
    [dataSource release];
    [dateFormatter release];
    [numberFormatter release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAdd:)] autorelease];
    [self.navigationItem setRightBarButtonItem:addButton animated:YES];
}

#pragma mark - SKTableViewDataSource (protocol)

- (void)objectDeleted:(id)object {
    [context deleteObject:object];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [dateFormatter stringFromDate:(NSDate *)[dataSource identifierForSection:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Transaction *transaction = (Transaction *)[dataSource objectForIndexPath:indexPath];
    cell.textLabel.text = transaction.title;
    cell.detailTextLabel.text = [numberFormatter stringFromNumber:transaction.price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource deleteObjectAtIndexPath:indexPath updateTable:YES];
        
        NSError *error = nil;
        [context save:&error];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
