#import "Transaction.h"

@implementation NSDate (DateWithoutTime)

- (NSDate *)dateWithoutTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [formatter stringFromDate:self];
    return [formatter dateFromString:dateString];
    
    // Use NSDateComponents?
}

@end

@implementation Transaction
@dynamic title, price, date;

+ (void)createDefaults:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:context]];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (NSManagedObject *object in array) {
        [context deleteObject:object];
    }
    
    Transaction *apples = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    apples.title = @"Apples";
    apples.price = [NSNumber numberWithDouble:2.19];
    apples.date  = [NSDate date];
    
    Transaction *oranges = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    oranges.title = @"Four Oranges";
    oranges.price = [NSNumber numberWithDouble:3.99];
    oranges.date  = [NSDate date];
    
    Transaction *pears = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    pears.title = @"Five Pears";
    pears.price = [NSNumber numberWithDouble:8.29];
    pears.date  = [NSDate date];
    
    Transaction *lunchable = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    lunchable.title = @"Lunchable!";
    lunchable.price = [NSNumber numberWithDouble:2.99];
    lunchable.date  = [NSDate dateWithTimeIntervalSinceNow:86400];
    
    Transaction *burger = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    burger.title = @"Five Guys burger";
    burger.price = [NSNumber numberWithDouble:4.99];
    burger.date  = [NSDate dateWithTimeIntervalSinceNow:86400];
    
    Transaction *plunger = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    plunger.title = @"Plunger; the old one broke";
    plunger.price = [NSNumber numberWithDouble:9.99];
    plunger.date  = [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    [context save:nil];
    
}

- (NSDate *)displayableDate {
    return [self.date dateWithoutTime];
}

- (NSComparisonResult)compare:(Transaction *)transaction {
    return [self.title compare:transaction.title];
}


@end
