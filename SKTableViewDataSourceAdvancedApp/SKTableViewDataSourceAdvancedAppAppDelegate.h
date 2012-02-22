#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SKTableViewDataSourceAdvancedAppAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
