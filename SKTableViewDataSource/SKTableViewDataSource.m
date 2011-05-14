//
//  SKTableViewFormatter.m
//  SKTableViewFormatter
//
//  Created by Bruce Ricketts on 3/29/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKTableViewDataSource.h"

@implementation SKTableViewDataSource
@synthesize sortSelector, sectionOrderAscending, rowOrderAscending, target, dictionary;

#pragma mark Object Management

- (id)init {
    if ((self = [super init])) {
        objects = [[NSMutableSet alloc] init];
        dictionary = [[NSMutableDictionary alloc] init];
        sectionOrderAscending = YES;
        rowOrderAscending = YES;
        shouldReloadDictionary = YES;
    }
    
    return self;
}

- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget {
    if ((self = [self init])) {
        [objects addObjectsFromArray:[initialObjects allObjects]];
        target = aTarget;
    }
    
    return self;
}

- (void)setObjects:(NSSet *)newObjects {
    [objects removeAllObjects];
    [objects addObjectsFromArray:[newObjects allObjects]];
    
    shouldReloadDictionary = YES;
}

- (void)addObject:(id)anObject {
    [objects addObject:anObject];
    
    shouldReloadDictionary = YES;
}

- (void)deleteObject:(id)anObject {
    [objects removeObject:anObject];
    
    shouldReloadDictionary = YES;
}

- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    id key = [self identifierForSection:indexPath.section];
    BOOL retVal = [[self.dictionary objectForKey:key] count] == 1;
    
    [objects removeObject:[self objectForIndexPath:indexPath]];
    shouldReloadDictionary = YES;
    
    return retVal;
}

- (void)dealloc {
    [objects release];
    [dictionary release];
    [target release];
    
    [super dealloc];
}


#pragma mark Property overrides

- (NSMutableDictionary *)dictionary {
    if (!shouldReloadDictionary) {
        return [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    
    [dictionary removeAllObjects];
    
    for (id object in objects) {
        if (![object respondsToSelector:sortSelector]) {
            NSException *exception = [NSException exceptionWithName:@"Objects should respond to your sortSelector"
                                                             reason:[NSString stringWithFormat:@"The following object doesn't respond to your sortSelector (%@): %@", NSStringFromSelector(sortSelector), object]
                                                           userInfo:nil];
            [exception raise];
        }
        if (![dictionary objectForKey:[object performSelector:sortSelector]]) {
            [dictionary setObject:[NSMutableArray arrayWithObject:object]
                           forKey:[object performSelector:sortSelector]];
        } else {
            NSMutableArray *tempObjects = [dictionary objectForKey:[object performSelector:sortSelector]];
            [tempObjects addObject:object];
            [dictionary setObject:tempObjects
                           forKey:[object performSelector:sortSelector]];
        }
    }
    
    shouldReloadDictionary = NO;
    
    return dictionary;
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
    return [[self.dictionary allKeys] count];
}

#pragma mark SKTableViewDataSource protocol -- required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [target tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark SKTableViewDataSource protocol -- optional

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
    id key = [self identifierForSection:section];
    NSArray *array = (NSArray *)[self.dictionary objectForKey:key];
    
    for (id object in array) {
        if (![object respondsToSelector:@selector(compare:)]) {
            NSException *exception = [NSException exceptionWithName:@"Object should respond to compare:"
                                                             reason:[NSString stringWithFormat:@"The following object does not implement @selector(compare:), therefore I can't order your objects in section %i: %@", section, object]
                                                           userInfo:nil];
            [exception raise];
        }
    }
    
    NSArray *newArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    if (!rowOrderAscending) {
        newArray = [[newArray reverseObjectEnumerator] allObjects];
    }
    
    return newArray;
}

- (NSArray *)orderedSectionsForTableView {
    for (id object in [self.dictionary allKeys]) {
        if (![object respondsToSelector:@selector(compare:)]) {
            NSException *exception = [NSException exceptionWithName:@"Object should respond to compare:"
                                                             reason:[NSString stringWithFormat:@"The following section identifier does not implement @selector(compare:), therefore I can't order your sections: %@", object]
                                                           userInfo:nil];
            [exception raise];
        }
    }
    NSArray *retVal = [[self.dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (!sectionOrderAscending) {
        retVal = [[retVal reverseObjectEnumerator] allObjects];
    }
    
    return retVal;
}

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section {
    return [[self orderedSectionsForTableView] objectAtIndex:section];    
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self orderedObjectsForSection:indexPath.section];
    
    return [array objectAtIndex:indexPath.row];
}

@end
