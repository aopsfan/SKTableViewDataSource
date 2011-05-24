#import <UIKit/UIKit.h>
#import "SKTableViewDataSource.h"

@interface SKTableViewController : UITableViewController <SKTableViewDataSource> {
    SKTableViewDataSource *dataSource;
}

@end
