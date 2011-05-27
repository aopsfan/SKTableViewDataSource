#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSDate (DateWithoutTime)

- (NSDate *)dateWithoutTime;

@end

@interface Transaction : NSManagedObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSDate *date;

- (NSDate *)displayableDate;
- (NSComparisonResult)compare:(Transaction *)transaction;

+ (void)createDefaults:(NSManagedObjectContext *)context;

@end
