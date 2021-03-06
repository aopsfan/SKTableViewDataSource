#import <Foundation/Foundation.h>
#import "SKCollectionDiff.h"
#import "SKTableViewInfo.h"
#import "SKFilteredSet.h"
#import "SKOptionKeys.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AvailabilityMacros.h>
#import "NSObject-Selector.h"

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
    SKTableViewInfo *tableViewSnapshot;
    
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
@property (nonatomic, strong) id target;
@property (nonatomic, strong) UITableView *tableView;

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
- (void)setObjects:(NSSet *)newObjects updateTable:(BOOL)updateTable;
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
- (void)updateTableAnimated:(BOOL)animated;
- (void)takeTableViewSnapshot;

// more updateTable methods coming soon

#pragma mark Filtering Objects

- (void)addFilter:(SKDataFilter *)filter;
- (void)removeFilter:(SKDataFilter *)filter;

#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section inTableViewInfo:(SKTableViewInfo *)info;
- (NSArray *)orderedSectionsForTableViewInfo:(SKTableViewInfo *)info;

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section;
- (NSUInteger)sectionForSectionIdentifier:(id)identifier;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@end
