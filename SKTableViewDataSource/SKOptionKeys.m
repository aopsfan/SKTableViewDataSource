//
//  SKOptionKeys.m
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 6/24/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKOptionKeys.h"


@implementation SKOptionKeys

+ (NSString *)objectsOption {
    return @"objects";
}

+ (NSString *)entityNameOption {
    return @"entityName";
}

+ (NSString *)fetchRequestOption {
    return @"fetchRequest";
}

+ (NSString *)targetOption {
    return @"target";
}

+ (NSString *)managedObjectContextOption {
    return @"managedObjectContext";
}

+ (NSString *)predicateFilterOption {
    return @"predicateFilter";
}


@end
