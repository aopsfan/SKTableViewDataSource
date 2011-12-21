#import "SKTableViewDataSourceCoreDataTests.h"

@implementation SKTableViewDataSourceCoreDataTests

- (void)setUp {
    model = [NSManagedObjectModel mergedModelFromBundles:
              [NSArray arrayWithObject:[NSBundle bundleWithIdentifier:@"com.aopsfan.SKTableViewDataSourceTests"]]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSLog(@">>>>>>>> support directory is %@", applicationSupportDirectory);
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory, error]));
		}
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"test"]];
    [fileManager removeItemAtPath:storeUrl.path error:&error];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error creating store: %@", error);
    }
}

- (NSString *)applicationSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return basePath;
}

@end
