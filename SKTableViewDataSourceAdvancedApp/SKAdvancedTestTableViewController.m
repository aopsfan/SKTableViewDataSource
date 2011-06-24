#import "SKAdvancedTestTableViewController.h"
#import <CoreData/CoreData.h>
#import "Transaction.h"
#import "SKOptionKeys.h"

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
        
        NSDate *date = [[NSDate dateWithTimeIntervalSinceNow:-86400] dateWithoutTime];
        SKDataFilter *pFilter = [SKDataFilter where:@"displayableDate" isNotEqualTo:date];
        
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:description];
        
        dataSource = [[TransactionDataSource alloc] initWithSortSelector:@selector(displayableDate)
                                                                 options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          @"Transaction", [SKOptionKeys entityNameOption],
                                                                          context       , [SKOptionKeys managedObjectContextOption],
                                                                          self          , [SKOptionKeys targetOption],
                                                                          pFilter       , [SKOptionKeys predicateFilterOption], nil]];
        
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
