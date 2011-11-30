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
    if (objects) {
        [objects release];
    }
    if (entityName) {
        [entityName release];
    }
    if (fetchRequest) {
        [fetchRequest release];
    }
    if (target) {
        [target release];
    }
    if (managedObjectContext) {
        [managedObjectContext release];
    }
    if (predicateFilter) {
        [predicateFilter release];
    }
    
    objectOptionsCount = 0;  
    
    [super dealloc];
}

- (void)setObjects:(NSMutableSet *)someObjects {
    if (!objects) {
        objects = [[NSMutableSet alloc] init];
    }
    objects = [someObjects retain];
    
    objectOptionsCount++;
}

- (void)setEntityName:(NSMutableString *)anEntityName {
    if (!entityName) {
        entityName = [[NSMutableString alloc] init];
    }
    entityName = [anEntityName retain];
    
    objectOptionsCount++;
}

- (void)setFetchRequest:(NSFetchRequest *)aFetchRequest {
    if (!fetchRequest) {
        fetchRequest = [[NSFetchRequest alloc] init];
    }
    fetchRequest = [aFetchRequest retain];
    
    objectOptionsCount++;
}

- (void)setTarget:(NSObject *)aTarget {
    if (!target) {
        target = [[NSObject alloc] init];
    }
    target = [aTarget retain];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
    }
    managedObjectContext = [aManagedObjectContext retain];
}

- (void)setPredicateFilter:(SKDataFilter *)aPredicateFilter {
    if (!predicateFilter) {
        predicateFilter = [[SKDataFilter alloc] init];
    }
    predicateFilter = [aPredicateFilter retain];
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
