//
//  CollectionDefs.h
//  SKCollectionDiff
//
//  Created by Bruce Ricketts on 5/18/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKCollectionDiff;

@interface NSArray (Diff)
- (NSArray *)arrayBySubmittingDiff:(SKCollectionDiff *)diff;
@end

@interface NSMutableArray (Diff)
- (void)submitDiff:(SKCollectionDiff *)diff;
@end

@interface NSSet (Diff)
- (NSSet *)setBySubmittingDiff:(SKCollectionDiff *)diff;
@end

@interface NSMutableSet (Diff)
- (void)submitDiff:(SKCollectionDiff *)diff;
@end