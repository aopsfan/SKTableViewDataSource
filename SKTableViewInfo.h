#import <Foundation/Foundation.h>


@interface SKTableViewInfo : NSObject {
    NSMutableDictionary *dictionary;
}

#pragma mark Data
- (NSMutableSet *)objectsForIdentifier:(id)identifier;
- (NSSet *)allIdentifiers;

#pragma mark Actions

- (void)setObjects:(NSSet *)objects forIdentifier:(id)identifier;
- (void)removeObjectsForIdentifier:(id)identifier;
- (void)removeAllData;
- (void)log;

@end
