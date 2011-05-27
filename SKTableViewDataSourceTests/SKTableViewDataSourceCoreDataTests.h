#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface SKTableViewDataSourceCoreDataTests : SenTestCase {
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSManagedObjectContext *context;
}

- (NSString *)applicationSupportDirectory;

@end
