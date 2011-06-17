#import "SKFilteredSet.h"

@implementation SKFilteredSet
@synthesize ignoresFilters;

#pragma mark Object Management

- (id)init {
    if ((self = [super init])) {
        filterData      = [[NSMutableDictionary alloc] init];
        allObjects      = [[NSMutableSet alloc] init];
        filteredObjects = [[NSMutableSet alloc] init];
        ignoresFilters  = NO;
        
        shouldReloadObjects = NO;
    }
    
    return self;
}

- (void)dealloc {
    [filterData release];
    [allObjects release];
    [filteredObjects release];
    
    [super dealloc];
}

#pragma mark Property Overrides

- (NSMutableSet *)filteredObjects {
    if (!shouldReloadObjects) {
        return [NSMutableSet setWithSet:filteredObjects];
    }
    
    [filteredObjects removeAllObjects];
        
    for (id object in allObjects) {
        for (SKDataFilter *filter in [filterData allKeys]) {
            if (![filter matchesObject:object]) {
                [filteredObjects addObject:object];
                break;
            }
        }
    }
    
    shouldReloadObjects = NO;
    
    return filteredObjects;
}

#pragma mark Getting Objects

- (NSSet *)unfilteredObjects {
    if (ignoresFilters) {
        return [NSSet setWithSet:allObjects];
    }
    
    NSMutableSet *unfilteredObjects = [NSMutableSet setWithSet:allObjects];
    
    for (id object in self.filteredObjects) {
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
    
    shouldReloadObjects = YES;
}

- (void)addObjectsFromArray:(NSArray *)array {
    [allObjects addObjectsFromArray:array];
    
    shouldReloadObjects = YES;
}

- (void)removeObject:(id)object {
    [allObjects removeObject:object];
    
    shouldReloadObjects = YES;
}

- (void)removeAllObjects {
    [allObjects removeAllObjects];
}

- (void)removeFilteredObjects {
    [allObjects setSet:[self unfilteredObjects]];
    [filteredObjects setSet:[NSSet set]];
    
    shouldReloadObjects = YES;
}


#pragma mark Filter Actions

- (void)addFilter:(SKDataFilter *)filter {
    [filterData setObject:[filter setWithObjects:allObjects] forKey:filter];
    
    shouldReloadObjects = YES;
}

- (void)removeFilter:(SKDataFilter *)filter {
    [filterData removeObjectForKey:filter];
    
    shouldReloadObjects = YES;
}

@end
