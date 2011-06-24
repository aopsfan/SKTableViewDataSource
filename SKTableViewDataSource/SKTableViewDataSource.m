#import "SKTableViewDataSource.h"

@implementation SKTableViewDataSource
@synthesize sortSelector, sectionOrderAscending, rowOrderAscending, target, tableViewInfo;

#pragma mark Private

- (NSSet *)objectsFromSet:(NSSet *)set predicateFilterIfAny:(SKDataFilter *)predicateFilter {
    NSMutableSet *filteredSet = [NSMutableSet set];
    
    if (predicateFilter) {
        for (id object in set) {
            if ([predicateFilter matchesObject:object]) {
                [filteredSet addObject:object];
            }
        }
    } else {
        [filteredSet setSet:set];
    }
    
    return filteredSet;
}

- (NSMutableSet *)objectsFromFetchRequest:(NSFetchRequest *)fetchRequest
                   inManagedObjectContext:(NSManagedObjectContext *)context
                     predicateFilterIfAny:(SKDataFilter *)predicateFilter {
    NSError *error = nil;
    NSMutableSet *set = [NSMutableSet setWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    if (set == nil) {
        NSException *exception = [NSException exceptionWithName:@"Entity name/context should be valid"
                                                         reason:[NSString stringWithFormat:@"Error is %@", error]
                                                       userInfo:nil];
        [exception raise];
    }
    
    return [[self objectsFromSet:set predicateFilterIfAny:predicateFilter] mutableCopy];
}

- (NSMutableSet *)objectsFromEntityName:(NSString *)entityName
                 inManagedObjectContext:(NSManagedObjectContext *)context
                   predicateFilterIfAny:(SKDataFilter *)predicateFilter {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:entityDescription];
    
    return [self objectsFromFetchRequest:fetchRequest inManagedObjectContext:context predicateFilterIfAny:predicateFilter];
}

- (void)setObjectsWithCoreDataOptions:(NSArray *)coreDataOptions predicateFilterIfAny:(SKDataFilter *)predicateFilter {
    id fetchType = [coreDataOptions objectAtIndex:0];
    
    if ([fetchType isKindOfClass:[NSString class]]) {
        [self setObjects:[self objectsFromEntityName:(NSString *)fetchType
                              inManagedObjectContext:(NSManagedObjectContext *)[coreDataOptions objectAtIndex:1]
                                predicateFilterIfAny:predicateFilter]];
    } else {
        [self setObjects:[self objectsFromFetchRequest:(NSFetchRequest *)fetchType
                                inManagedObjectContext:(NSManagedObjectContext *)[coreDataOptions objectAtIndex:1]
                                  predicateFilterIfAny:predicateFilter]];
    }
}

#pragma mark Protocol Stuff

- (void)contentUpdated {
    if ([target respondsToSelector:@selector(contentUpdated)]) {
        [target contentUpdated];
    }
}

- (void)objectAdded:(id)anObject {
    if ([target respondsToSelector:@selector(objectAdded:)]) {
        [target objectAdded:anObject];
    }
}

- (void)objectDeleted:(id)anObject {
    if ([target respondsToSelector:@selector(objectDeleted:)]) {
        [target objectDeleted:anObject];
    }
}

#pragma mark Data

- (NSSet *)allObjects {
    return [NSSet setWithSet:[objects allObjects]];
}

- (NSSet *)displayedObjects {
    return [NSSet setWithSet:[objects unfilteredObjects]];
}

#pragma mark Content Updating

- (id)init {
    if ((self = [super init])) {
        objects = [[SKFilteredSet alloc] init];
        tableViewInfo = [[SKTableViewInfo alloc] init];
        sectionOrderAscending = YES;
        rowOrderAscending = YES;
        shouldReloadDictionary = NO;
        currentDiff = [[SKCollectionDiff alloc] initWithAddedObjects:[NSSet set] deletedObjects:[NSSet set]];
    }
    
    return self;
}

- (id)initWithSet:(NSSet *)initialObjects {
    if ((self = [self init])) {
        [currentDiff addDiff:[SKCollectionDiff diffWithAddedObjects:initialObjects deletedObjects:[NSSet set]]];
        [objects addObjectsFromArray:[initialObjects allObjects]];
        
        shouldReloadDictionary = YES;
    }
    
    return self;
}

- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget {
    if ((self = [self initWithSet:initialObjects])) {
        target = aTarget;
    }
    
    return self;
}

- (id)initWithSortSelector:(SEL)aSortSelector options:(NSDictionary *)options {
    if ((self = [self init])) {
        sortSelector = aSortSelector;
        [self setObjectsWithOptions:options];
    }
    
    return self;
}

- (void)setObjects:(NSSet *)newObjects {
    [currentDiff addDiff:[SKCollectionDiff diffWithOldObjects:[objects allObjects] newObjects:newObjects]];
    [objects submitDiff:currentDiff];
    
    [self contentUpdated];
    
    shouldReloadDictionary = YES;
}

- (void)setObjectsWithOptions:(NSDictionary *)options {
    NSArray *keys = [options allKeys];
    NSMutableSet *acceptedKeys = [NSMutableSet setWithObjects:
                                  @"objects", @"entityName",
                                  @"fetchRequest",
                                  @"target", nil];
    NSUInteger objectOptionsCount = [keys containsObject:@"objects"] + [keys containsObject:@"entityName"] + [keys containsObject:@"fetchRequest"];
    NSManagedObjectContext *context = nil;
    
    if ([keys containsObject:@"managedObjectContext"]) {
        context = [[(NSManagedObjectContext *)[options objectForKey:@"managedObjectContext"] retain] autorelease];
    }
    
    if (objectOptionsCount > 1) {
        NSException *exc = [NSException exceptionWithName:@"There should be at least 1 way to store objects"
                                                   reason:[NSString stringWithFormat:
                                                           @"You have provided %i options to store objects in the following options dictionary:",
                                                           objectOptionsCount, options] userInfo:nil];
        [exc raise];
    }
    
    for (NSString *key in acceptedKeys) {
        if ([keys containsObject:key]) {
            if (key == @"objects") {
                [self setObjects:[self objectsFromSet:(NSSet *)[options objectForKey:key]
                                 predicateFilterIfAny:(SKDataFilter *)[options objectForKey:@"predicateFilter"]]];
            } else if (key == @"entityName" || key == @"fetchRequest") {
                if (!context) {
                    NSException *contextException = [NSException exceptionWithName:@"@\"context\" should be a key in the options dictionary"
                                                                            reason:@"You passed in an entityName or fetchRequest without specifying a context"
                                                                          userInfo:nil];
                    [contextException raise];
                }
                
                NSArray *coreDataOptions = [NSArray arrayWithObjects:[options objectForKey:key], context, nil];
                [self setObjectsWithCoreDataOptions:coreDataOptions predicateFilterIfAny:[options objectForKey:@"predicateFilter"]]; 
            } else if (key == @"target" ) {
                target = [options objectForKey:key];
            }
        }
    }
}

- (void)addObject:(id)anObject {
    [currentDiff addDiff:[SKCollectionDiff diffWithAddedObjects:[NSSet setWithObject:anObject] deletedObjects:[NSSet set]]];
    [objects addObject:anObject];
    
    [self contentUpdated];
    [self objectAdded:anObject];
    
    shouldReloadDictionary = YES;
}

- (void)deleteObject:(id)anObject {
    [currentDiff addDiff:[SKCollectionDiff diffWithAddedObjects:[NSSet set] deletedObjects:[NSSet setWithObject:anObject]]];
    [objects removeObject:anObject];
    
    [self contentUpdated];
    [self objectDeleted:anObject];
    
    shouldReloadDictionary = YES;
}

- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    id identifier = [self identifierForSection:indexPath.section];
    BOOL retVal = [[self.tableViewInfo objectsForIdentifier:identifier] count] == 1;
    
    [self deleteObject:[self objectForIndexPath:indexPath]];
    
    return retVal;
}

- (void)removeFilteredObjects {
    [objects removeFilteredObjects];
}

- (void)dealloc {
    [objects release];
    [tableViewInfo release];
    [target release];
    [currentDiff release];
    
    [super dealloc];
}

#pragma mark Filtering Objects

- (void)addFilter:(SKDataFilter *)filter {
    NSSet *old = [objects unfilteredObjects];
    [objects addFilter:filter];
    NSSet *new = [objects unfilteredObjects];
    
    [currentDiff addDiff:[SKCollectionDiff diffWithOldObjects:old newObjects:new]];
    shouldReloadDictionary = YES;
}

- (void)removeFilter:(SKDataFilter *)filter {
    NSSet *old = [objects unfilteredObjects];
    [objects removeFilter:filter];
    NSSet *new = [objects unfilteredObjects];
    
    SKCollectionDiff *diff = [SKCollectionDiff diffWithOldObjects:old newObjects:new];
    [currentDiff addDiff:diff];
    shouldReloadDictionary = YES;
}


#pragma mark Property overrides

- (SKTableViewInfo *)tableViewInfo {
    if (!shouldReloadDictionary) {
        return tableViewInfo;
    }
    
    if (!sortSelector) {
        NSException *exc = [NSException exceptionWithName:@"sortSelector should not be null" reason:[NSString stringWithFormat:@"Your sortSelector for the following instance of SKTableViewDataSource is null: %@", self] userInfo:nil];
        [exc raise];
    }
    
    for (id object in currentDiff.addedObjects) {
        if (![object respondsToSelector:sortSelector]) {
            NSException *exception = [NSException exceptionWithName:@"Objects should respond to your sortSelector"
                                                             reason:[NSString stringWithFormat:@"The following object doesn't respond to your sortSelector (%@): %@", NSStringFromSelector(sortSelector), object]
                                                           userInfo:nil];
            [exception raise];
        }
        if (![tableViewInfo objectsForIdentifier:[object performSelector:sortSelector]]) {
            [tableViewInfo setObjects:[NSSet setWithObject:object]
                        forIdentifier:[object performSelector:sortSelector]];
        } else {
            NSMutableSet *tempObjects = [NSMutableSet setWithSet:[tableViewInfo objectsForIdentifier:[object performSelector:sortSelector]]];
            [tempObjects addObject:object];
            [tableViewInfo setObjects:[NSSet setWithSet:tempObjects]
                        forIdentifier:[object performSelector:sortSelector]];
        }
    }
    
    for (id deleteObject in currentDiff.deletedObjects) {        
        NSMutableSet *set = [tableViewInfo objectsForIdentifier:[deleteObject performSelector:sortSelector]];
                
        [set removeObject:deleteObject];
        
        if ([set count] == 0) {
            [tableViewInfo removeObjectsForIdentifier:[deleteObject performSelector:sortSelector]];
        }
    }
    
    shouldReloadDictionary = NO;
    [currentDiff setDiff:[SKCollectionDiff diff]];
    
    return tableViewInfo;
}


- (void)setSortSelector:(SEL)newSortSelector {
    sortSelector = newSortSelector;
    
    shouldReloadDictionary = YES;
}

- (void)setRowOrderAscending:(BOOL)newRowOrderAscending {
    rowOrderAscending = newRowOrderAscending;
    
    shouldReloadDictionary = YES;
}

- (void)setSectionOrderAscending:(BOOL)newSectionOrderAscending {
    sectionOrderAscending = newSectionOrderAscending;
    
    shouldReloadDictionary = YES;
}

#pragma mark Table View Management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self orderedObjectsForSection:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.tableViewInfo allIdentifiers] count];
}

#pragma mark UITableViewDataSource protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(cellForObject:)]) {
        return [target cellForObject:[self objectForIndexPath:indexPath]];
    }
    
    if ([target respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [target tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSException *exc = [NSException exceptionWithName:
                        @"You should implement either cellForObject (SKTableViewDataSource) or cellForRowAtIndexPath (UITableViewDataSource)"
                                               reason:
                        [NSString stringWithFormat:@"You don't implement either of the above methods in your controller, %@", target]
                                             userInfo:nil];
    [exc raise];
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([target respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [target sectionIndexTitlesForTableView:tableView];
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [target tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [target tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [target tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([target respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [target tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([target respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [target tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([target respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [target tableView:tableView titleForFooterInSection:section];
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([target respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [target tableView:tableView titleForHeaderInSection:section];
    }
    
    return nil;
}

#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section {    
    id identifier = [self identifierForSection:section];
    NSSet *set = [self.tableViewInfo objectsForIdentifier:identifier];
    
    for (id object in set) {
        if (![object respondsToSelector:@selector(compare:)]) {
            NSException *exception = [NSException exceptionWithName:@"Object should respond to compare:"
                                                             reason:[NSString stringWithFormat:@"The following object does not implement @selector(compare:), therefore I can't order your objects in section %i: %@", section, object]
                                                           userInfo:nil];
            [exception raise];
        }
    }
    
    NSArray *newArray = [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    if (!rowOrderAscending) {
        newArray = [[newArray reverseObjectEnumerator] allObjects];
    }
    
    return newArray;
}

- (NSArray *)orderedSectionsForTableView {
    for (id object in [self.tableViewInfo allIdentifiers]) {
        if (![object respondsToSelector:@selector(compare:)]) {
            NSException *exception = [NSException exceptionWithName:@"Object should respond to compare:"
                                                             reason:[NSString stringWithFormat:@"The following section identifier does not implement @selector(compare:), therefore I can't order your sections: %@", object]
                                                           userInfo:nil];
            [exception raise];
        }
    }
    NSArray *retVal = [[[self.tableViewInfo allIdentifiers] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    if (!sectionOrderAscending) {
        retVal = [[retVal reverseObjectEnumerator] allObjects];
    }
    
    return retVal;
}

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section {
    return [[self orderedSectionsForTableView] objectAtIndex:section];    
}

- (NSUInteger)sectionForSectionIdentifier:(id)identifier {
    for (id key in [self.tableViewInfo allIdentifiers]) {
        if ([key isEqual:identifier]) {
            return [[self orderedSectionsForTableView] indexOfObject:key];
        }
    }
    
    return 0;
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self orderedObjectsForSection:indexPath.section];
    
    return [array objectAtIndex:indexPath.row];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    id identifier = [object performSelector:sortSelector];
    NSUInteger section = [self sectionForSectionIdentifier:identifier];
    NSArray *array = [self orderedObjectsForSection:section];
    NSUInteger row;
    
    for (id anObject in array) {
        if ([object isEqual:anObject]) {
            row = [array indexOfObject:anObject];
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    
    return nil;
}

@end
