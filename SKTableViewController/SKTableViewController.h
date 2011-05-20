//
//  SKTableViewController.h
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 5/20/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTableViewDataSource.h"

@interface SKTableViewController : UITableViewController <SKTableViewDataSource> {
    SKTableViewDataSource *dataSource;
}

@end
