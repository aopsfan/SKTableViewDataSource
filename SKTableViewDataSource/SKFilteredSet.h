#import <Foundation/Foundation.h>
#import "SKDataFilter.h"

@interface SKFilteredSet : NSObject {
    NSMutableDictionary *filterData;
    NSMutableSet *allObjects;
    NSMutableSet *filteredObjects;
    BOOL ignoresFilters;
    
    BOOL shouldReloadObjects;
}

@property (readonly) NSMutableSet *filteredObjects;
@property BOOL ignoresFilters;

#pragma mark Getting Objects

- (NSSet *)unfilteredObjects;
- (NSSet *)allObjects;

#pragma mark Managing Objects

- (void)addObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (void)removeFilteredObjects;

#pragma mark Filter Actions

- (void)addFilter:(SKDataFilter *)filter;
- (void)removeFilter:(SKDataFilter *)filter;

@end