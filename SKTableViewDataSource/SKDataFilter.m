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
