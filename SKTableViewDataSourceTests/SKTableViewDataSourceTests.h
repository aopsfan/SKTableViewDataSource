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
    Dude *bruce;
    Dude *tom;
    Dude *michael;
    Dude *emilysTwin;
    Dude *tomsTwin;
    Dude *michaelsTwin;
    Dude *brucesTwin;
}

@end
