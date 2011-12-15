#import <Foundation/Foundation.h>
#import "CollectionDefs.h"

@interface SKCollectionDiff : NSObject <NSCopying> {
    NSMutableSet *addedObjects;
    NSMutableSet *deletedObjects;
}

@property (nonatomic, strong)NSMutableSet *addedObjects;
@property (nonatomic, strong)NSMutableSet *deletedObjects;

- (id)initWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted;
+ (SKCollectionDiff *)diffWithAddedObjects:(NSSet *)added deletedObjects:(NSSet *)deleted;
- (id)initWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects;
+ (SKCollectionDiff *)diffWithOldObjects:(NSSet *)oldObjects newObjects:(NSSet *)newObjects;
- (void)setDiff:(SKCollectionDiff *)diff;
- (void)addDiff:(SKCollectionDiff *)diff;
+ (SKCollectionDiff *)diff;
- (void)addObject:(id)object;
- (void)deleteObject:(id)object;

@end