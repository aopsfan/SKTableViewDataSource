//
//  SKAdvancedTestTableViewController.h
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 4/13/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionDataSource.h"

@interface SKAdvancedTestTableViewController : UITableViewController <SKTableViewDataSource>
{
    NSSet *data;
    TransactionDataSource *dataSource;
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
}

@end
