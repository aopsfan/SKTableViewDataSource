#import <Foundation/Foundation.h>
#define ADDED_INFO @"Added Info"
#define DELETED_INFO @"Deleted Info"

@interface SKTableViewInfo : NSObject {
    NSMutableDictionary *dictionary;
}

@property (strong, nonatomic)NSMutableDictionary *dictionary;

#pragma mark Data
- (NSMutableSet *)objectsForIdentifier:(id)identifier;
- (NSSet *)allIdentifiers;

#pragma mark Actions

- (void)setObjects:(NSSet *)objects forIdentifier:(id)identifier;
- (void)addObject:(id)object forIdentifier:(id)identifier;
- (void)removeObjectsForIdentifier:(id)identifier;
- (void)removeAllData;
- (void)log;
- (NSDictionary *)compareWithTableViewInfo:(SKTableViewInfo *)info;

@end
