#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "Dude.h"
#import "SKTableViewDataSource.h"

@interface TestFileSetup : SenTestCase {
    SKTableViewDataSource *dataSource;
    NSMutableArray *objects;
    
    Dude *emily;
    Dude *bruce;
    Dude *tom;
    Dude *michael;
    Dude *emilysTwin;
    Dude *tomsTwin;
    Dude *michaelsTwin;
    Dude *brucesTwin;
}

@end
