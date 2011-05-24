//
//  SKTableViewInfo.h
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 5/23/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKTableViewInfo : NSObject {
    NSMutableDictionary *dictionary;
}

#pragma mark Data
- (NSMutableSet *)objectsForIdentifier:(id)identifier;
- (NSSet *)allIdentifiers;

#pragma mark Actions

- (void)setObjects:(NSSet *)objects forIdentifier:(id)identifier;
- (void)removeObjectsForIdentifier:(id)identifier;
- (void)log;

@end
