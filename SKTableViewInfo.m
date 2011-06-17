#import "SKTableViewInfo.h"


@implementation SKTableViewInfo

- (id)init {
    if ((self = [super init])) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [dictionary release];
    
    [super dealloc];
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
    [dictionary setObject:[[objects mutableCopy] autorelease]
                   forKey:identifier];
}

- (void)removeObjectsForIdentifier:(id)identifier {
    [dictionary removeObjectForKey:identifier];
}

- (void)log {
    NSLog(@"instance is %@", self);
    NSLog(@"dictionary is %@", dictionary);
}

@end
