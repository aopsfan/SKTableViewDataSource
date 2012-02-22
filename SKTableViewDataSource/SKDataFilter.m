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
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorEquals];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotEqualTo:(id)value {
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorEquals];
}

+ (SKDataFilter *)where:(NSString *)selectorString isGreaterThan:(id)value {
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorGreaterThan];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotGreaterThan:(id)value {
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorGreaterThan];
}

+ (SKDataFilter *)where:(NSString *)selectorString isLessThan:(id)value {
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeIncludeOnly
                                comparisonOperator:SKDataFilterComparisonOperatorLessThan];
}

+ (SKDataFilter *)where:(NSString *)selectorString isNotLessThan:(id)value {
    return [[SKDataFilter alloc] initWithSelector:NSSelectorFromString(selectorString)
                                  comparisonObject:value
                                        filterType:SKDataFilterTypeExclude
                                comparisonOperator:SKDataFilterComparisonOperatorLessThan];
}

- (BOOL)matchesObject:(id)object {
    return ([[object arcPerformSelector:selector] compare:comparisonObject] == comparisonOperator) != filterType;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[SKDataFilter alloc] initWithSelector:selector comparisonObject:comparisonObject filterType:filterType comparisonOperator:comparisonOperator];
}

- (BOOL)isEqual:(id)object {
    SKDataFilter *filter = (SKDataFilter *)object;
    
    if ((filter.selector == self.selector) &&
        (filter.filterType == self.filterType) &&
        ([filter.comparisonObject isEqual:self.comparisonObject]) &&
        (filter.comparisonOperator == self.comparisonOperator)) {
        return YES;
    }
    
    return NO;
}

- (void)dealloc {
    selector = NULL;
    filterType = 0;
    comparisonOperator = 0;
    
}

@end
