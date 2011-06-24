#import <Foundation/Foundation.h>
#import "SKCollectionDiff.h"
#import "SKTableViewInfo.h"
#import "SKFilteredSet.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol SKTableViewDataSource <NSObject>
@optional

- (void)contentUpdated;
- (void)objectAdded:(id)object;
- (void)objectDeleted:(id)object;

- (UITableViewCell *)cellForObject:(id)object;

@end

@interface SKTableViewDataSource : NSObject <UITableViewDataSource> {
    SKFilteredSet *objects;
    SKTableViewInfo *tableViewInfo;
    
    BOOL sectionOrderAscending;
    BOOL rowOrderAscending;
    SEL sortSelector;
    
    BOOL shouldReloadDictionary;
    SKCollectionDiff *currentDiff;
    
    id<SKTableViewDataSource, UITableViewDataSource> target;
}

@property (readonly) SKTableViewInfo *tableViewInfo;
@property (nonatomic, retain) SKCollectionDiff *currentDiff;
@property BOOL sectionOrderAscending;
@property BOOL rowOrderAscending;
@property SEL sortSelector;
@property (nonatomic, retain) id target;

#pragma mark Data

- (NSSet *)allObjects;
- (NSSet *)displayedObjects;

#pragma mark Updating Content

- (id)initWithSet:(NSSet *)initialObjects;
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget;
- (id)initWithSortSelector:(SEL)aSortSelector options:(NSDictionary *)options;
- (void)setObjects:(NSSet *)newObjects;
- (void)setObjectsWithOptions:(NSDictionary *)options;
- (void)addObject:(id)anObject;
- (void)deleteObject:(id)anObject;
- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeFilteredObjects;

#pragma mark Filtering Objects

- (void)addFilter:(SKDataFilter *)filter;
- (void)removeFilter:(SKDataFilter *)filter;

#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section;
- (NSArray *)orderedSectionsForTableView;

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section;
- (NSUInteger)sectionForSectionIdentifier:(id)identifier;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@end
