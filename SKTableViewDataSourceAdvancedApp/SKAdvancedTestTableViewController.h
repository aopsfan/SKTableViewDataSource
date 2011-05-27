#import <UIKit/UIKit.h>
#import "TransactionDataSource.h"

@interface SKAdvancedTestTableViewController : UITableViewController
{
    TransactionDataSource *dataSource;
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
    NSManagedObjectContext *context;
}

- (id)initWithStyle:(UITableViewStyle)style context:(NSManagedObjectContext *)aContext;

@end
