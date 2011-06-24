#import <UIKit/UIKit.h>
#import "SKTableViewDataSource.h"

@interface SKTestTableViewController : UITableViewController {
    NSSet *data;
    SKTableViewDataSource *dataSource;
}

@end
