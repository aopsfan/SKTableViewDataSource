//
//  SKTableViewFormatter.m
//  SKTableViewFormatter
//
//  Created by Bruce Ricketts on 3/29/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "SKTableViewDataSource.h"

@implementation SKTableViewDataSource
@synthesize sortSelector, sectionOrderAscending, rowOrderAscending, methodSource, dictionary;

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

- (id)initWithSet:(NSSet *)initialObjects {
    if ((self = [self init])) {
        [objects addObjectsFromArray:[initialObjects allObjects]];
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
    id key = [self objectForHeaderInSection:indexPath.section];
    BOOL retVal = [[self.dictionary objectForKey:key] count] == 1;
    
    [objects removeObject:[self objectForIndexPath:indexPath]];
    shouldReloadDictionary = YES;
    
    return retVal;
}

- (void)dealloc {
    [objects release];
    [dictionary release];
    [methodSource release];
    
    [super dealloc];
}


#pragma mark Property overrides

- (NSMutableDictionary *)dictionary {
    if (!shouldReloadDictionary) {
        return [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    
    [dictionary removeAllObjects];
    
    for (id object in objects) {
        if (![dictionary objectForKey:[object performSelector:sortSelector]]) {
            if (![object respondsToSelector:sortSelector]) {
                NSLog(@"ERROR while trying to create dictionary in dictionary method:");
                NSLog(@">>>>> Object %@ in your data array doesn't respond to your sortSelector, %@", object, NSStringFromSelector(sortSelector));
                NSLog(@">>>>> Returning an empty dictionary");
                dictionary = [NSMutableDictionary dictionary];
                return dictionary;
            }
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
    return [methodSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark SKTableViewDataSource protocol -- optional

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([methodSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [methodSource sectionIndexTitlesForTableView:tableView];
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([methodSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [methodSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([methodSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [methodSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([methodSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [methodSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([methodSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [methodSource tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([methodSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [methodSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([methodSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [methodSource tableView:tableView titleForFooterInSection:section];
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([methodSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [methodSource tableView:tableView titleForHeaderInSection:section];
    }
    
    return nil;
}


#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section {    
    id key = [self objectForHeaderInSection:section];
    NSArray *array = (NSArray *)[self.dictionary objectForKey:key];
    NSArray *newArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    if (!rowOrderAscending) {
        newArray = [[newArray reverseObjectEnumerator] allObjects];
    }
    
    return newArray;
}

- (NSArray *)orderedSectionsForTableView {
    for (id object in [self.dictionary allKeys]) {
        if (![object respondsToSelector:@selector(compare:)]) {
            NSLog(@"ERROR while trying to sort sections in sortedSectionsForTableView method:");
            NSLog(@">>>>> Object %@ (one of your sections) doesn't respond to @selector(compare:)", object);
            NSLog(@">>>>> Please note that SKTableViewDataSource is only meant to sort sections if they are NSNumbers, NSStrings, and NSDates.");
            NSLog(@">>>>> If you need to have sections of a type that cannot implement - (NSComparisonResult)compare:(ObjectType *)otherObject,");
            NSLog(@">>>>> you may need to subclass SKTableViewDataSource and overide - (NSArray *)sortedSectionsForTableView");
            NSLog(@">>>>> Returning an unsorted array of headers");
            
            return [self.dictionary allKeys];
        }
    }
    NSArray *retVal = [[self.dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (!sectionOrderAscending) {
        retVal = [[retVal reverseObjectEnumerator] allObjects];
    }
    
    return retVal;
}

#pragma mark Other

- (id)objectForHeaderInSection:(NSUInteger)section {
    return [[self orderedSectionsForTableView] objectAtIndex:section];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self orderedObjectsForSection:indexPath.section];
    
    return [array objectAtIndex:indexPath.row];
}

@end
