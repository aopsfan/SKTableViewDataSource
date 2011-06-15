#import "SKFilteredSet.h"

@implementation SKFilteredSet

#pragma mark Object Management

- (id)init {
    if ((self = [super init])) {
        filters         = [[NSMutableSet alloc] init];
        allObjects      = [[NSMutableSet alloc] init];
        filteredObjects = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [filters release];
    [allObjects release];
    [filteredObjects release];
    
    [super dealloc];
}

#pragma mark Getting Objects

- (NSSet *)filteredObjects {
    return [NSSet setWithSet:filteredObjects];
}

- (NSSet *)unfilteredObjects {
    NSMutableSet *unfilteredObjects = [NSMutableSet setWithSet:allObjects];
    
    for (id object in [self filteredObjects]) {
        [unfilteredObjects removeObject:object];
    }
    
    return [NSSet setWithSet:unfilteredObjects];
}

- (NSSet *)allObjects {
    return [NSSet setWithSet:allObjects];
}

#pragma mark Managing Objects

- (void)addObject:(id)object {
    [allObjects addObject:object];
}

- (void)addObjectsFromArray:(NSArray *)array {
    [allObjects addObjectsFromArray:array];
}

- (void)removeObject:(id)object {
    [allObjects removeObject:object];
}

- (void)removeAllObjects {
    [allObjects removeAllObjects];
}

- (void)removeFilteredObjects {
    for (id object in filteredObjects) {[allObjects removeObject:object];}
    [filteredObjects removeAllObjects];
    [filters removeAllObjects];
}


#pragma mark Filter Actions

- (void)deleteFilteredObjects {
    NSMutableSet *objectsToDelete = [NSMutableSet set];
    
    for (id object in allObjects) {
        if (![[self filteredObjects] containsObject:object]) {
            [objectsToDelete addObject:object];
        }
    }
    
    for (id deleteObject in objectsToDelete) {
        [allObjects removeObject:deleteObject];
    }
}

- (void)addFilter:(SKDataFilter *)filter {
    [filters addObject:filter];
    NSMutableSet *unfilteredObjects = [NSMutableSet setWithSet:[self unfilteredObjects]];
    NSComparisonResult result;
    
    for (id object in unfilteredObjects) {
        if ([[object performSelector:filter.selector] respondsToSelector:@selector(compare:)]) {
            result = [[object performSelector:filter.selector] compare:filter.comparisonObject];
            
            if (((result == filter.comparisonOperator) && (filter.filterType == SKDataFilterTypeExclude)) ||
                ((result != filter.comparisonOperator) && (filter.filterType == SKDataFilterTypeIncludeOnly))) {
                [filteredObjects addObject:object];
            }
        } else {
            NSException *exception = [NSException exceptionWithName:@"Object should respond to compare:"
                                                             reason:[NSString stringWithFormat:@"The following object does not implement @selector(compare:), therefore I can't add filter %@: %@", [filter performSelector:filter.selector], object]
                                                           userInfo:nil];
            [exception raise];
        }
    }
}

- (void)removeFilter:(SKDataFilter *)filter {
    [filters removeObject:filter];
    NSArray *allFilters = [filters allObjects];
    [filters removeAllObjects];
    [filteredObjects setSet:[NSSet set]];
    
    for (SKDataFilter *filter in allFilters) {
        [self addFilter:filter];
    }
}

@end
