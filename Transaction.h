#import <Foundation/Foundation.h>

@interface NSDate (DateWithoutTime)

- (NSDate *)dateWithoutTime;

@end

@interface Transaction : NSObject {
    NSString *title;
    NSNumber *price;
    NSDate *date;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSDate *date;

- (id)initWithTitle:(NSString *)aTitle price:(double)aPrice date:(NSDate *)aDate;
- (NSDate *)displayableDate;
- (NSComparisonResult)compare:(Transaction *)transaction;

@end
