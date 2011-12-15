#import "SKTableViewInfo.h"


@implementation SKTableViewInfo

- (id)init {
    if ((self = [super init])) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark Data
- (NSMutableSet *)objectsForIdentifier:(id)identifier {
    return (NSMutableSet *)[dictionary objectForKey:identifier];
}

- (NSSet *)allIdentifiers {
    return [NSSet setWithArray:[dictionary allKeys]];
}

#pragma mark Actions

- (void)setObjects:(NSSet *)objects forIdentifier:(id)identifier {
    [dictionary setObject:[objects mutableCopy]
                   forKey:identifier];
}

- (void)removeObjectsForIdentifier:(id)identifier {
    [dictionary removeObjectForKey:identifier];
}

- (void)removeAllData {
    [dictionary removeAllObjects];
}

- (void)log {
    NSLog(@"instance is %@", self);
    NSLog(@"dictionary is %@", dictionary);
}

@end
