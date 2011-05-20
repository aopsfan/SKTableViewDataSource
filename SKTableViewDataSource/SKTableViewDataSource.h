//
//  SKTableViewFormatter.h
//  SKTableViewFormatter
//
//  Created by Bruce Ricketts on 3/29/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SKTableViewDataSource
@optional

- (void)contentUpdated;
- (void)objectAdded:(id)object;
- (void)objectDeleted:(id)object;

@end

@interface SKTableViewDataSource : NSObject <UITableViewDataSource> {
    NSMutableSet *objects;
    NSMutableDictionary *dictionary;
    
    BOOL sectionOrderAscending;
    BOOL rowOrderAscending;
    SEL sortSelector;
    
    BOOL shouldReloadDictionary;
    
    id<SKTableViewDataSource, UITableViewDataSource> target;
}

@property (readonly, copy) NSMutableDictionary *dictionary;
@property BOOL sectionOrderAscending;
@property BOOL rowOrderAscending;
@property SEL sortSelector;
@property (nonatomic, readonly) id target;

#pragma mark Object Management

- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget;
- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget sortSelector:(SEL)aSortSelector;
- (void)setObjects:(NSSet *)newObjects;
- (void)addObject:(id)anObject;
- (void)deleteObject:(id)anObject;
- (BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark Ordering

- (NSArray *)orderedObjectsForSection:(NSUInteger)section;
- (NSArray *)orderedSectionsForTableView;

#pragma mark Other

- (id)identifierForSection:(NSUInteger)section;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;

@end
