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
    SKCollectionDiff *diff = [[SKCollectionDiff alloc] initWithAddedObjects:added deletedObjects:deleted];
    return diff;
}

- (id)initWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects {
    if ((self = [self init])) {
        NSMutableSet *commonObjects = [[NSMutableSet alloc] init];
        
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
    SKCollectionDiff *diff = [[SKCollectionDiff alloc] initWithOldObjects:oldObjects newObjects:newObjects];
    return diff;
}

- (void)setDiff:(SKCollectionDiff *)diff {
    [self.addedObjects setSet:diff.addedObjects];
    [self.deletedObjects setSet:diff.deletedObjects];
}

- (void)addDiff:(SKCollectionDiff *)diff {
    for (id object in diff.addedObjects) {
        if ([self.deletedObjects containsObject:object]) {
            [self.deletedObjects removeObject:object];
        } else {
            [self.addedObjects addObject:object];
        }
    }
    
    for (id deletedObject in diff.deletedObjects) {
        if ([self.addedObjects containsObject:deletedObject]) {
            [self.addedObjects removeObject:deletedObject];
        } else {
            [self.deletedObjects addObject:deletedObject];
        }
    }
}

+ (SKCollectionDiff *)diff {
    return [SKCollectionDiff diffWithAddedObjects:[NSSet set] deletedObjects:[NSSet set]];
}

- (void)addObject:(id)object {
    if ([self.deletedObjects containsObject:object]) {
        [self.deletedObjects removeObject:object];
    } else {
        [self.addedObjects addObject:object];
    }
}

- (void)deleteObject:(id)object {
    if ([self.addedObjects containsObject:object]) {
        [self.addedObjects removeObject:object];
    } else {
        [self.deletedObjects addObject:object];
    }    
}


#pragma mark Property overrides

- (void)setAddedObjects:(NSMutableSet *)newAddedObjects {
    for (id object in newAddedObjects) {
        if ([self.deletedObjects containsObject:object]) {
            [self.deletedObjects removeObject:object];
        } else {
            [self.addedObjects addObject:object];
        }
    }
}

- (void)setDeletedObjects:(NSMutableSet *)newDeletedObjects {
    for (id object in newDeletedObjects) {
        if ([self.addedObjects containsObject:object]) {
            [self.addedObjects removeObject:object];
        } else {
            [self.deletedObjects addObject:object];
        }
    }
}

#pragma mark Logging

- (NSString *)description {
    return [NSString stringWithFormat:@"SKCollectionDiff %@: addedObjects = %@, deletedObjects = %@", [super description], self.addedObjects, self.deletedObjects];
}

#pragma mark NSCopying Protocol

- (id)copyWithZone:(NSZone *)zone {
    return [[SKCollectionDiff alloc] initWithAddedObjects:self.addedObjects deletedObjects:self.deletedObjects];
}

@end