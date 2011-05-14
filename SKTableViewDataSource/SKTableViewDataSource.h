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

@required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

@end

@interface SKTableViewDataSource : NSObject <UITableViewDataSource> {
    NSMutableSet *objects;
    NSMutableDictionary *dictionary;
    
    BOOL sectionOrderAscending;
    BOOL rowOrderAscending;
    SEL sortSelector;
    
    BOOL shouldReloadDictionary;
    
    id target;
}

@property (readonly, copy) NSMutableDictionary *dictionary;
@property BOOL sectionOrderAscending;
@property BOOL rowOrderAscending;
@property SEL sortSelector;
@property (nonatomic, readonly) id target;

#pragma mark Object Management

- (id)initWithSet:(NSSet *)initialObjects target:(id)aTarget;
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
