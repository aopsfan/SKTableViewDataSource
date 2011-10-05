#import <Foundation/Foundation.h>
#import "SKDataFilter.h"
#import "SKCollectionDiff.h"

@interface SKFilteredSet : NSObject {
    NSMutableSet *filters;
    NSMutableArray *objects;
    
    SKCollectionDiff *filteredDiff;
}

@property (nonatomic, copy) SKCollectionDiff *filteredDiff;

#pragma mark Initializers

- (id)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithObjects:(NSSet *)newObjects predicateFilter:(SKDataFilter *)predicateFilter;

#pragma mark Getting Data

- (NSSet *)displayedObjects;
- (NSSet *)hiddenObjects;
- (NSSet *)allObjects;
- (NSSet *)filters;
- (BOOL)filtersMatchObject:(id)object;

#pragma mark Managing Objects

- (void)setObjects:(NSSet *)newObjects predicateFilter:(SKDataFilter *)filter;
- (void)setObjects:(NSSet *)newObjects;
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)removeAllObjects;
- (void)removeHiddenObjects;

#pragma mark Filter Actions

- (void)addFilter:(SKDataFilter *)filter;
- (void)removeFilter:(SKDataFilter *)filter;
- (void)removeAllFilters;

@end
