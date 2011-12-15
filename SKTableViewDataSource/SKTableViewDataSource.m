#import "SKTableViewDataSource.h"

@implementation SKTableViewDataSource
@synthesize target, tableViewInfo, editingStyleInsertRowAnimation, editingStyleDeleteRowAnimation, tableView;

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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
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
    return [NSSet setWithSet:[objects displayedObjects]];
}

- (NSSet *)filters {
    return [NSSet setWithSet:[objects filters]];
}

#pragma mark Content Updating

- (id)init {
    if ((self = [super init])) {
        objects = [[SKFilteredSet alloc] init];
        tableViewInfo = [[SKTableViewInfo alloc] init];
        sectionOrderAscending = YES;
        rowOrderAscending = YES;
        editingStyleDeleteRowAnimation = UITableViewRowAnimationNone;
        editingStyleInsertRowAnimation = UITableViewRowAnimationNone;
        shouldReloadDictionary = NO;
        tableView = [[UITableView alloc] init];
    }
    
    return self;
}

- (id)initWithSet:(NSSet *)initialObjects {
    if ((self = [self init])) {
        [self setObjects:initialObjects];
//        [objects addObjectsFromArray:[initialObjects allObjects]];
        
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

- (id)initWithSortSelector:(SEL)aSortSelector optionKeys:(SKOptionKeys *)optionKeys {
    if ((self = [self init])) {
        sortSelector = aSortSelector;
        [self setObjectsWithOptionKeys:optionKeys];
    }
    
    return self;
}

- (void)setObjects:(NSSet *)newObjects {
    [objects setObjects:newObjects];
    
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
        context = (NSManagedObjectContext *)[options objectForKey:@"managedObjectContext"];
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
                                                                            reason:@"You passed in an entityName or fetchRequest without specifying an NSManagedObjectContext."
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

- (void)setObjectsWithOptionKeys:(SKOptionKeys *)optionKeys {
    if (optionKeys.objectOptionsCount > 1) {
        NSException *exc = [NSException exceptionWithName:@"There should be at least 1 way to store objects"
                                                   reason:[NSString stringWithFormat:
                                                           @"You have provided %i options to store objects in the following SKOptionKeys instance: %@",
                                                           optionKeys.objectOptionsCount, optionKeys] userInfo:nil];
        [exc raise];
    }
    
    if ((optionKeys.entityName || optionKeys.fetchRequest) && !optionKeys.managedObjectContext) {
        NSException *contextException = [NSException exceptionWithName:@"@\"context\" should be in the option keys"
                                                                reason:@"You passed in an entityName or fetchRequest without specifying an NSManagedObjectContext."
                                                              userInfo:nil];
        [contextException raise];
    }
    
    if (optionKeys.objects) {
        [self setObjects:optionKeys.objects];
    } else if (optionKeys.entityName) {
        NSArray *coreDataOptions = [NSArray arrayWithObjects:optionKeys.entityName, optionKeys.managedObjectContext, nil];
        [self setObjectsWithCoreDataOptions:coreDataOptions predicateFilterIfAny:optionKeys.predicateFilter]; 
    } else if (optionKeys.fetchRequest) {
        NSArray *coreDataOptions = [NSArray arrayWithObjects:optionKeys.fetchRequest, optionKeys.managedObjectContext, nil];
        [self setObjectsWithCoreDataOptions:coreDataOptions predicateFilterIfAny:optionKeys.predicateFilter]; 
    }
    
    if (optionKeys.target) {
        self.target = optionKeys.target;
    }
}

- (void)addObject:(id)anObject { 
    [objects addObject:anObject];
    
    [self contentUpdated];
    [self objectAdded:anObject];
    
    shouldReloadDictionary = YES;
}

- (void)addObject:(id)anObject updateTable:(BOOL)updateTable {
    BOOL createSection = ![[self.tableViewInfo allIdentifiers] containsObject:[anObject performSelector:sortSelector]];
    [self addObject:anObject];
        
    if (updateTable) {
        if (createSection) {
            [tableView insertSections:[NSIndexSet indexSetWithIndex:[self sectionForSectionIdentifier:[anObject performSelector:sortSelector]]]
                     withRowAnimation:editingStyleInsertRowAnimation];
        } else {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[self indexPathForObject:anObject]]
                             withRowAnimation:editingStyleInsertRowAnimation];
        }
    }
}

- (void)deleteObject:(id)anObject {
    [objects removeObject:anObject];
    
    [self contentUpdated];
    [self objectDeleted:anObject];
    
    shouldReloadDictionary = YES;
}

- (void)deleteObject:(id)anObject updateTable:(BOOL)updateTable {
    id identifier = [anObject performSelector:sortSelector];
    BOOL deleteSection = [[self.tableViewInfo objectsForIdentifier:identifier] count] == 1;
    NSIndexPath *indexPath = [self indexPathForObject:anObject];
    
    [self deleteObject:anObject];
    
    if (updateTable) {
        if (deleteSection) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:editingStyleDeleteRowAnimation];
        } else {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]                                                
                             withRowAnimation:editingStyleDeleteRowAnimation];
        }
    }
    
}

- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    id identifier = [self identifierForSection:indexPath.section];
    BOOL deleteSection = [[self.tableViewInfo objectsForIdentifier:identifier] count] == 1;
    
    [self deleteObject:[self objectForIndexPath:indexPath]];
    
    return deleteSection;
}

- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTable:(BOOL)updateTable {
    id identifier = [self identifierForSection:indexPath.section];
    BOOL deleteSection = [[self.tableViewInfo objectsForIdentifier:identifier] count] == 1;
    
    [self deleteObject:[self objectForIndexPath:indexPath] updateTable:YES];
    
    return deleteSection;
}

- (void)removeHiddenObjects {
    [objects removeHiddenObjects];
}

- (void)reloadData {
    if (!sortSelector) {
        NSException *exc = [NSException exceptionWithName:@"sortSelector should not be null" reason:[NSString stringWithFormat:@"Your sortSelector for the following instance of SKTableViewDataSource is null: %@", self] userInfo:nil];
        [exc raise];
    }
    
    [tableViewInfo removeAllData];
    
    for (id object in [objects displayedObjects]) {
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
}


#pragma mark Filtering Objects

- (void)addFilter:(SKDataFilter *)filter {
    [objects addFilter:filter];
    
    shouldReloadDictionary = YES;
}

- (void)removeFilter:(SKDataFilter *)filter {
    [objects removeFilter:filter];
    
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
    
    for (id object in objects.filteredDiff.addedObjects) {
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
    
    for (id deleteObject in objects.filteredDiff.deletedObjects) {        
        NSMutableSet *set = [tableViewInfo objectsForIdentifier:[deleteObject performSelector:sortSelector]];
        
        [set removeObject:deleteObject];
        
        if ([set count] == 0) {
            [tableViewInfo removeObjectsForIdentifier:[deleteObject performSelector:sortSelector]];
        } else {
            [tableViewInfo setObjects:set forIdentifier:[deleteObject performSelector:sortSelector]];
        }
    }
    
    shouldReloadDictionary = NO;
    [objects setFilteredDiff:[SKCollectionDiff diff]];
    
    return tableViewInfo;
}

- (void)setSortSelector:(SEL)newSortSelector {
    sortSelector = newSortSelector;
    
    shouldReloadDictionary = YES;
}

- (SEL)sortSelector {
    return sortSelector;
}

- (void)setRowOrderAscending:(BOOL)newRowOrderAscending {
    rowOrderAscending = newRowOrderAscending;
    
    shouldReloadDictionary = YES;
}

- (BOOL)rowOrderAscending {
    return rowOrderAscending;
}

- (void)setSectionOrderAscending:(BOOL)newSectionOrderAscending {
    sectionOrderAscending = newSectionOrderAscending;
    
    shouldReloadDictionary = YES;
}

- (BOOL)sectionOrderAscending {
    return sectionOrderAscending;
}

#pragma mark Table View Management

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[self orderedObjectsForSection:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return [[self.tableViewInfo allIdentifiers] count];
}

#pragma mark UITableViewDataSource protocol

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(cellForObject:)]) {
        return [target cellForObject:[self objectForIndexPath:indexPath]];
    }
    
    if ([target respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [target tableView:aTableView cellForRowAtIndexPath:indexPath];
    }
    
    NSException *exc = [NSException exceptionWithName:
                        @"You should implement either cellForObject (SKTableViewDataSource) or cellForRowAtIndexPath (UITableViewDataSource)"
                                               reason:
                        [NSString stringWithFormat:@"You don't implement either of the above methods in your controller, %@", target]
                                             userInfo:nil];
    [exc raise];
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView {
    if ([target respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [target sectionIndexTitlesForTableView:aTableView];
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [target tableView:aTableView canEditRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [target tableView:aTableView canMoveRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([target respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [target tableView:aTableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([target respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [target tableView:aTableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([target respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [target tableView:aTableView sectionForSectionIndexTitle:title atIndex:index];
    }
    
    return index;
}

- (NSString *)tableView:(UITableView *)aTableView titleForFooterInSection:(NSInteger)section {
    if ([target respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [target tableView:aTableView titleForFooterInSection:section];
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    if ([target respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [target tableView:aTableView titleForHeaderInSection:section];
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
