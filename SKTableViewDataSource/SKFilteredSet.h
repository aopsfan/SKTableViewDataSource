#import <Foundation/Foundation.h>
#import "SKDataFilter.h"

@interface SKFilteredSet : NSObject {
    NSMutableSet *filters;
    NSMutableSet *allObjects;
    NSMutableSet *filteredObjects;
}

#pragma mark Getting Objects

- (NSSet *)filteredObjects;
- (NSSet *)unfilteredObjects;
- (NSSet *)allObjects;

#pragma mark Managing Objects

- (void)addObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (void)removeFilteredObjects;

#pragma mark Filter Actions

- (void)deleteFilteredObjects;
- (void)addFilter:(SKDataFilter *)filter;
- (void)removeFilter:(SKDataFilter *)filter;

@end
