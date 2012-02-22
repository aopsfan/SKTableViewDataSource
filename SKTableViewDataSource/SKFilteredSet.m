#import "SKFilteredSet.h"

@implementation SKFilteredSet
@synthesize filteredDiff;

#pragma mark Initializers

- (id)init {
    self = [super init];
    if (self) {
        filters = [[NSMutableSet alloc] init];
        objects = [[NSMutableArray alloc] init];
        filteredDiff = [[SKCollectionDiff alloc] init];
    }
    return self;
}


- (id)initWithObjects:(id)firstObject, ...
{
    if ((self = [super init])) {
        NSMutableSet *set = [NSMutableSet set];
        
        va_list args;
        va_start(args, firstObject);
        
        for (id arg = firstObject; arg != nil; arg = va_arg(args, id))
        {
            [set addObject:arg];
        }
        va_end(args);
        
        [self setObjects:set];
    }
    
    return self;
}

- (id)initWithObjects:(NSSet *)newObjects predicateFilter:(SKDataFilter *)predicateFilter {
    if ((self = [self init])) {
        [self setObjects:newObjects predicateFilter:predicateFilter];
    }

    return self;
}


#pragma mark Getting Data

- (NSSet *)displayedObjects {    
    NSMutableSet *set = [NSMutableSet set];
    
    for (id object in objects) {
        if ([self filtersMatchObject:object]) {
            [set addObject:object];
        }
    }
        
    return [NSSet setWithSet:set];
}

- (NSSet *)hiddenObjects {
    NSMutableSet *set = [NSMutableSet set];
    
    for (id object in objects) {
        if (![self filtersMatchObject:object]) {
            [set addObject:object];
        }
    }
    
    return [NSSet setWithSet:set];
}

- (NSSet *)allObjects {
    return [NSSet setWithArray:objects];
}

- (NSSet *)filters {
    return [NSSet setWithSet:filters];
}

- (BOOL)filtersMatchObject:(id)object {
    if ([filters count] > 0) {
        for (SKDataFilter *filter in filters) {
            if (![filter matchesObject:object]) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark Managing Objects

- (void)setObjects:(NSSet *)newObjects predicateFilter:(SKDataFilter *)filter {
    NSMutableSet *filteredNewObjects = [NSMutableSet set];
    
    for (id object in newObjects) {
        if ([self filtersMatchObject:object] && (!filter || [filter matchesObject:object])) {
            [filteredNewObjects addObject:object];
        }
    }
    
    [filteredDiff addDiff:[SKCollectionDiff diffWithOldObjects:[self displayedObjects] newObjects:filteredNewObjects]];        
    
    [objects setArray:[filteredNewObjects allObjects]];
}

- (void)setObjects:(NSSet *)newObjects {
    [self setObjects:newObjects predicateFilter:nil];
}

- (void)addObject:(id)object {
    if ([self filtersMatchObject:object]) {
        [filteredDiff.addedObjects addObject:object];
    }
    
    [objects addObject:object];
}

- (void)removeObject:(id)object {
    if ([self filtersMatchObject:object]) {
        [filteredDiff.deletedObjects addObject:object];
    }
    
    [objects removeObject:object];
}

- (void)addObjectsFromArray:(NSArray *)array {
    for (id object in array) {
        [self addObject:object];
    }
}

- (void)removeAllObjects {
    NSSet *set = [NSSet setWithSet:self.displayedObjects];
    
    for (id object in set) {
        [filteredDiff.deletedObjects setSet:set];
    }
}

- (void)removeHiddenObjects {
    for (id object in [self hiddenObjects]) {
        [objects removeObject:object];
    }
}

#pragma mark Filter Actions

- (void)addFilter:(SKDataFilter *)filter {
    for (id object in [self displayedObjects]) {
        if (![filter matchesObject:object]) {
            [filteredDiff.deletedObjects addObject:object];
        }
    }
        
    [filters addObject:filter];
}

- (void)removeFilter:(SKDataFilter *)filter {
    NSSet *hiddenObjects = [self hiddenObjects];
    [filters removeObject:filter];
    
    for (id object in hiddenObjects) {
        if ([self filtersMatchObject:object]) {
            [filteredDiff.addedObjects addObject:object];
        }
    }
}

- (void)removeAllFilters {
    [filteredDiff.addedObjects addObjectsFromArray:[[self hiddenObjects] allObjects]];
    
    [filters removeAllObjects];
}

@end
