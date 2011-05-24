#import "CollectionDefs.h"
#import "SKCollectionDiff.h"

@implementation NSArray (Diff)

- (NSArray *)arrayBySubmittingDiff:(SKCollectionDiff *)diff {
    NSMutableArray *array = [[self arrayByAddingObjectsFromArray:[diff.addedObjects allObjects]] mutableCopy];
    
    for (id object in diff.deletedObjects) {
        if ([array containsObject:object]) {
            [array removeObject:object];
        } else {
            NSLog(@"WARNING: attempt to remove object %@ from array %@ failed because the object is not in the array", object, array);
        }
    }
    
    return [NSArray arrayWithArray:array];
}

@end

@implementation NSMutableArray (Diff)

- (void)submitDiff:(SKCollectionDiff *)diff {
    [self addObjectsFromArray:[diff.addedObjects allObjects]];
    
    for (id object in diff.deletedObjects) {
        if ([self containsObject:object]) {
            [self removeObject:object];
        } else {
            NSLog(@"WARNING: attempt to remove object %@ from array %@ failed because the object is not in the array", object, self);
        }
    }
}

@end

@implementation NSSet (Diff)

- (NSSet *)setBySubmittingDiff:(SKCollectionDiff *)diff {
    NSMutableSet *set = [[self setByAddingObjectsFromArray:[diff.addedObjects allObjects]] mutableCopy];
    
    for (id object in diff.deletedObjects) {
        if ([set containsObject:object]) {
            [set removeObject:object];
        } else {
            NSLog(@"WARNING: attempt to remove object %@ from set %@ failed because the object is not in the array", object, set);
        }
    }
    
    return [NSSet setWithSet:set];
}

@end

@implementation NSMutableSet (Diff)

- (void)submitDiff:(SKCollectionDiff *)diff {
    [self addObjectsFromArray:[diff.addedObjects allObjects]];
    
    for (id object in diff.deletedObjects) {
        if ([self containsObject:object]) {
            [self removeObject:object];
        } else {
            NSLog(@"WARNING: attempt to remove object %@ from set %@ failed because the object is not in the array", object, self);
        }
    }
}

@end