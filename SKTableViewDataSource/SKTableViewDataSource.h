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
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget sortSelector:(SEL)aSortSelector;
- (id)initWithEntityName:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context target:(id)aTarget;
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)setObjects:(NSSet *)newObjects;
- (void)setObjectsWithEntityName:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)setObjectsWithFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)context;
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
