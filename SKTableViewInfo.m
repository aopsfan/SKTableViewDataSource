#import "SKTableViewInfo.h"

@interface SKTableViewInfo (Subtraction)

- (SKTableViewInfo *)subtractInfo:(SKTableViewInfo *)info;

@end

@implementation SKTableViewInfo (Subtraction)

- (SKTableViewInfo *)subtractInfo:(SKTableViewInfo *)info {
	SKTableViewInfo *differenceInfo = [[SKTableViewInfo alloc] init];
    
    for (id identifier in [self allIdentifiers]) {
        if (![info objectsForIdentifier:identifier]) {
            [differenceInfo setObjects:[self objectsForIdentifier:identifier] forIdentifier:identifier];
        } else if (![[info objectsForIdentifier:identifier] isEqualToSet:[self objectsForIdentifier:identifier]]) {
            for (id object in [self objectsForIdentifier:identifier]) {
                if (![[info objectsForIdentifier:identifier] containsObject:object]) {
                    [differenceInfo addObject:object forIdentifier:identifier];
                }
            }
        }
    }
    
	return differenceInfo;
}

@end

@implementation SKTableViewInfo
@synthesize dictionary;

- (id)init {
    if ((self = [super init])) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark Data
- (NSMutableSet *)objectsForIdentifier:(id)identifier {
    return [NSMutableSet setWithSet:(NSMutableSet *)[dictionary objectForKey:identifier]];
}

- (NSSet *)allIdentifiers {
    return [NSSet setWithArray:[dictionary allKeys]];
}

#pragma mark Actions

- (void)setObjects:(NSSet *)objects forIdentifier:(id)identifier {
    [dictionary setObject:[objects mutableCopy]
                   forKey:identifier];
}

- (void)addObject:(id)object forIdentifier:(id)identifier {
    NSMutableSet *tempObjects = [NSMutableSet setWithSet:[self objectsForIdentifier:identifier]];
    [tempObjects addObject:object];
    [self setObjects:[NSSet setWithSet:tempObjects] forIdentifier:identifier];
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

- (NSDictionary *)compareWithTableViewInfo:(SKTableViewInfo *)info {
    SKTableViewInfo *deletedInfo = [self subtractInfo:info];
    SKTableViewInfo *addedInfo = [info subtractInfo:self];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:addedInfo, ADDED_INFO, deletedInfo, DELETED_INFO, nil];
}

@end
