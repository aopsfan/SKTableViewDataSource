//
//  SKCollectionDiff.m
//  SKCollectionDiff
//
//  Created by Bruce Ricketts on 5/18/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKCollectionDiff.h"

@implementation SKCollectionDiff
@synthesize addedObjects, deletedObjects;

- (id)init {
    if ((self = [super init])) {
        addedObjects = [[NSMutableSet alloc] init];
        deletedObjects = [[NSMutableSet alloc] init];
    }
    
    return self;
}


- (id)initWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted {
    if ((self = [super init])) {
        addedObjects = [[NSMutableSet alloc] initWithSet:added];
        deletedObjects = [[NSMutableSet alloc] initWithSet:deleted];
    }
    
    return self;
}


+ (SKCollectionDiff *)diffWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted {
    SKCollectionDiff *diff = [[[SKCollectionDiff alloc] initWithAddedObjects:added deletedObjects:deleted] autorelease];
    return diff;
}

- (id)initWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects {
    if ((self = [self init])) {
        NSMutableSet *commonObjects = [[[NSMutableSet alloc] init] autorelease];
        
        for (id object in oldObjects) {
            if ([newObjects containsObject:object]) {
                [commonObjects addObject:object]; // If the object is in both new and old, add it to the common objects
            } else {
                [deletedObjects addObject:object]; // If the object is in the old version but not in the new, that object has been deleted
            }
        }
        
        [addedObjects addObjectsFromArray:[newObjects allObjects]]; // Start out addedObjects by adding every object from the new set
        
        for (id object in commonObjects) {
            [addedObjects removeObject:object]; // Delete the object from the added set if it was already in the old set
        }
    }
    
    return self;
}

+ (SKCollectionDiff *)diffWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects {
    SKCollectionDiff *diff = [[[SKCollectionDiff alloc] initWithOldObjects:oldObjects newObjects:newObjects] autorelease];
    return diff;
}

- (void)setDiff:(SKCollectionDiff *)diff {
    [self.addedObjects setSet:diff.addedObjects];
    [self.deletedObjects setSet:diff.deletedObjects];
}

- (void)addDiff:(SKCollectionDiff *)diff {
    [self.addedObjects addObjectsFromArray:[diff.addedObjects allObjects]];
    [self.deletedObjects addObjectsFromArray:[diff.deletedObjects allObjects]];
}

+ (SKCollectionDiff *)diff {
    return [SKCollectionDiff diffWithAddedObjects:[NSSet set] deletedObjects:[NSSet set]];
}

- (void)dealloc {
    [addedObjects release];
    [deletedObjects release];
    
    [super dealloc];
}

@end