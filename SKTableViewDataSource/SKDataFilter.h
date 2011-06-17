#import <Foundation/Foundation.h>

typedef enum {
    SKDataFilterTypeIncludeOnly = 0,
    SKDataFilterTypeExclude
}  SKDataFilterType;

typedef enum {
    SKDataFilterComparisonOperatorLessThan = -1,
    SKDataFilterComparisonOperatorEquals,
    SKDataFilterComparisonOperatorGreaterThan
} SKDataFilterComparisonOperator;

@interface SKDataFilter : NSObject <NSCopying> {
    SEL selector;
    SKDataFilterType filterType;
    SKDataFilterComparisonOperator comparisonOperator;
    id comparisonObject;
}

@property SEL selector;
@property (nonatomic, retain) id comparisonObject;
@property SKDataFilterType filterType;
@property SKDataFilterComparisonOperator comparisonOperator;

- (id)initWithSelector:(SEL)aSelector comparisonObject:(id)aComparisonObject;
- (id)initWithSelector:(SEL)aSelector
      comparisonObject:(id)aComparisonObject
            filterType:(SKDataFilterType)aFilterType
    comparisonOperator:(SKDataFilterComparisonOperator)aComparisonOperator;

- (NSSet *)setWithObjects:(NSSet *)objects;
- (BOOL)matchesObject:(id)object;

@end
