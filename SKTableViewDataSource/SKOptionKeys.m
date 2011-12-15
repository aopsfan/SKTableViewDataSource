#import "SKOptionKeys.h"


@implementation SKOptionKeys
@synthesize objects, entityName, fetchRequest, target, managedObjectContext, predicateFilter, objectOptionsCount;

- (id)init {
    self = [super init];
    if (self) {
        objectOptionsCount = 0;
    }
    return self;
}

- (void)dealloc {
    
    objectOptionsCount = 0;  
    
}

- (void)setObjects:(NSMutableSet *)someObjects {
    if (!objects) {
        objects = [[NSMutableSet alloc] init];
    }
    objects = someObjects;
    
    objectOptionsCount++;
}

- (void)setEntityName:(NSMutableString *)anEntityName {
    if (!entityName) {
        entityName = [[NSMutableString alloc] init];
    }
    entityName = anEntityName;
    
    objectOptionsCount++;
}

- (void)setFetchRequest:(NSFetchRequest *)aFetchRequest {
    if (!fetchRequest) {
        fetchRequest = [[NSFetchRequest alloc] init];
    }
    fetchRequest = aFetchRequest;
    
    objectOptionsCount++;
}

- (void)setTarget:(NSObject *)aTarget {
    if (!target) {
        target = [[NSObject alloc] init];
    }
    target = aTarget;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
    }
    managedObjectContext = aManagedObjectContext;
}

- (void)setPredicateFilter:(SKDataFilter *)aPredicateFilter {
    if (!predicateFilter) {
        predicateFilter = [[SKDataFilter alloc] init];
    }
    predicateFilter = aPredicateFilter;
}

+ (NSString *)objectsOption {
    return @"objects";
}

+ (NSString *)entityNameOption {
    return @"entityName";
}

+ (NSString *)fetchRequestOption {
    return @"fetchRequest";
}

+ (NSString *)targetOption {
    return @"target";
}

+ (NSString *)managedObjectContextOption {
    return @"managedObjectContext";
}

+ (NSString *)predicateFilterOption {
    return @"predicateFilter";
}


@end
