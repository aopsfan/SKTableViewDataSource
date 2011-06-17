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

+ (SKDataFilter *)where:(NSString *)selectorString isEqualTo:(id)value;
+ (SKDataFilter *)where:(NSString *)selectorString isNotEqualTo:(id)value;
+ (SKDataFilter *)where:(NSString *)selectorString isGreaterThan:(id)value;
+ (SKDataFilter *)where:(NSString *)selectorString isNotGreaterThan:(id)value;
+ (SKDataFilter *)where:(NSString *)selectorString isLessThan:(id)value;
+ (SKDataFilter *)where:(NSString *)selectorString isNotLessThan:(id)value;

- (NSSet *)setWithObjects:(NSSet *)objects;
- (BOOL)matchesObject:(id)object;

@end
