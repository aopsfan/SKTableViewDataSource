#import <Foundation/Foundation.h>
#import "SKCollectionDiff.h"
#import "SKTableViewInfo.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol SKTableViewDataSource
@optional

- (void)contentUpdated;
- (void)objectAdded:(id)object;
- (void)objectDeleted:(id)object;

@end

@interface SKTableViewDataSource : NSObject <UITableViewDataSource> {
    NSMutableSet *objects;
    SKTableViewInfo *tableViewInfo;
    
    BOOL sectionOrderAscending;
    BOOL rowOrderAscending;
    SEL sortSelector;
    
    BOOL shouldReloadDictionary;
    SKCollectionDiff *currentDiff;
    
    id<SKTableViewDataSource, UITableViewDataSource> target;
}

@property (readonly, retain) SKTableViewInfo *tableViewInfo;
@property BOOL sectionOrderAscending;
@property BOOL rowOrderAscending;
@property SEL sortSelector;
@property (nonatomic, readonly) id target;

#pragma mark Object Management

- (id)initWithSet:(NSSet *)initialObjects;
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget;
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget sortSelector:(SEL)aSortSelector;
- (id)initWithEntityName:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context target:(id)aTarget;
- (void)setObjects:(NSSet *)newObjects;
- (void)setEntityName:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)addObject:(id)anObject;
- (void)deleteObject:(id)anObject;
- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section;
- (NSArray *)orderedSectionsForTableView;

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section;
- (NSUInteger)sectionForSectionIdentifier:(id)identifier;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@end
