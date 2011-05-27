#import "SKAdvancedTestTableViewController.h"
#import <CoreData/CoreData.h>
#import "Transaction.h"

@implementation SKAdvancedTestTableViewController

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
        
        dataSource = [[TransactionDataSource alloc] initWithEntityName:@"Transaction"
                                                inManagedObjectContext:context
                                                                target:self];
        dataSource.sortSelector = @selector(displayableDate);
        dataSource.sectionOrderAscending = NO;
        
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
        [context deleteObject:[dataSource objectForIndexPath:indexPath]];
        BOOL shouldDeleteSection = [dataSource deleteObjectAtIndexPath:indexPath];
        
        if (shouldDeleteSection) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                          withRowAnimation:YES];
        } else {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
