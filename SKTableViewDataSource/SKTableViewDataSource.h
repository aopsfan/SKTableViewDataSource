#import <Foundation/Foundation.h>
#import "SKCollectionDiff.h"
#import "SKTableViewInfo.h"
#import "SKFilteredSet.h"
#import "SKOptionKeys.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AvailabilityMacros.h>

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
    UITableViewRowAnimation editingStyleDeleteRowAnimation;
    UITableViewRowAnimation editingStyleInsertRowAnimation;
    SEL sortSelector;
    
    BOOL shouldReloadDictionary;
    
    id<SKTableViewDataSource, UITableViewDataSource> target;
    UITableView *tableView;
}

@property (readonly) SKTableViewInfo *tableViewInfo;
@property BOOL sectionOrderAscending;
@property BOOL rowOrderAscending;
@property UITableViewRowAnimation editingStyleDeleteRowAnimation;
@property UITableViewRowAnimation editingStyleInsertRowAnimation;
@property SEL sortSelector;
@property (nonatomic, retain) id target;
@property (nonatomic, retain) UITableView *tableView;

#pragma mark Data

- (NSSet *)allObjects;
- (NSSet *)displayedObjects;
- (NSSet *)filters;

#pragma mark Updating Content

- (id)initWithSet:(NSSet *)initialObjects;
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget;
- (id)initWithSortSelector:(SEL)aSortSelector options:(NSDictionary *)options DEPRECATED_ATTRIBUTE;
- (id)initWithSortSelector:(SEL)aSortSelector optionKeys:(SKOptionKeys *)optionKeys;
- (void)setObjects:(NSSet *)newObjects;
- (void)setObjectsWithOptions:(NSDictionary *)options DEPRECATED_ATTRIBUTE;
- (void)setObjectsWithOptionKeys:(SKOptionKeys *)optionKeys;
- (void)addObject:(id)anObject;
- (void)addObject:(id)anObject updateTable:(BOOL)updateTable;
- (void)deleteObject:(id)anObject;
- (void)deleteObject:(id)anObject updateTable:(BOOL)updateTable;
- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTable:(BOOL)updateTable;
- (void)removeHiddenObjects;
- (void)reloadData;

// more updateTable methods coming soon

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
