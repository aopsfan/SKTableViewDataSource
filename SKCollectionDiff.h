//
//  SKCollectionDiff.h
//  SKCollectionDiff
//
//  Created by Bruce Ricketts on 5/18/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionDefs.h"

@interface SKCollectionDiff : NSObject {
    NSMutableSet *addedObjects;
    NSMutableSet *deletedObjects;
}

@property (nonatomic, retain)NSMutableSet *addedObjects;
@property (nonatomic, retain)NSMutableSet *deletedObjects;

- (id)initWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted;
+ (SKCollectionDiff *)diffWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted;
- (id)initWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects;
+ (SKCollectionDiff *)diffWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects;
- (void)setDiff:(SKCollectionDiff *)diff;
- (void)addDiff:(SKCollectionDiff *)diff;
+ (SKCollectionDiff *)diff;

@end