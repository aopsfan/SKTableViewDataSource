#import "SKTableViewControllerAppAppDelegate.h"
#import "SKControllerTestViewController.h"

@implementation SKTableViewControllerAppAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SKControllerTestViewController *controller = [[[SKControllerTestViewController alloc] init] autorelease];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
