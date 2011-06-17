#import "SKDataFilter.h"


@implementation SKDataFilter
@synthesize selector, comparisonObject, filterType, comparisonOperator;

- (id)initWithSelector:(SEL)aSelector comparisonObject:(id)aComparisonObject {
    if ((self = [super init])) {
        selector = aSelector;
        self.comparisonObject = aComparisonObject;
        filterType = SKDataFilterTypeIncludeOnly;
        comparisonOperator = SKDataFilterComparisonOperatorEquals;
    }
    
    return self;
}

- (id)initWithSelector:(SEL)aSelector
      comparisonObject:(id)aComparisonObject
            filterType:(SKDataFilterType)aFilterType
    comparisonOperator:(SKDataFilterComparisonOperator)aComparisonOperator {
    
    if ((self = [self initWithSelector:aSelector comparisonObject:aComparisonObject])) {
        filterType = aFilterType;
        comparisonOperator = aComparisonOperator;
    }
    
    return self;
}

- (NSSet *)setWithObjects:(NSSet *)objects {
    NSMutableSet *remainingObjects = [NSMutableSet set];
    
    for (id object in objects) {
        if ([self matchesObject:object]) [remainingObjects addObject:object];
    }
    
    return remainingObjects;
}

+ (SKDataFilter *)where:(NSString *)selectorString isEqualTo:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorEquals] autorelease];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotEqualTo:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorEquals] autorelease];
}

+ (SKDataFilter *)where:(NSString *)selectorString isGreaterThan:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorGreaterThan] autorelease];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotGreaterThan:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorGreaterThan] autorelease];
}

+ (SKDataFilter *)where:(NSString *)selectorString isLessThan:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorLessThan] autorelease];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotLessThan:(id)value {
    return [[[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorLessThan] autorelease];
}

- (BOOL)matchesObject:(id)object {
    return ([[object performSelector:selector] compare:comparisonObject] == comparisonOperator) != filterType;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc {
    selector = NULL;
    filterType = 0;
    comparisonOperator = 0;
    
    [comparisonObject release];
    [super dealloc];
}

@end
