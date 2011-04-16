//
//  SKTableViewDataSourceTests.h
//  SKTableViewDataSourceTests
//
//  Created by Bruce Ricketts on 3/31/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SKTableViewDataSource.h"
#import "Dude.h"

@interface SKTableViewDataSourceTests : SenTestCase {
@private
    SKTableViewDataSource *dataSource;
    NSMutableArray *objects;
    
    Dude *emily;
    Dude *tom;
    Dude *emilysTwin;
    Dude *tomsTwin;
}

@end
