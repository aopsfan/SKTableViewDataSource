#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSDate (DateWithoutTime)

- (NSDate *)dateWithoutTime;

@end

@interface Transaction : NSManagedObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSDate *date;

- (NSDate *)displayableDate;
- (NSComparisonResult)compare:(Transaction *)transaction;

+ (void)createDefaults:(NSManagedObjectContext *)context;

@end
