//
//  SKOptionKeys.h
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 6/24/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKOptionKeys : NSObject

+ (NSString *)objectsOption;
+ (NSString *)entityNameOption;
+ (NSString *)fetchRequestOption;
+ (NSString *)targetOption;
+ (NSString *)managedObjectContextOption;
+ (NSString *)predicateFilterOption;

@end
