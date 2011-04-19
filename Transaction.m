//
//  Transaction.m
//  SKTableViewDataSource
//
//  Created by Bruce Ricketts on 4/18/11.
//  Copyright 2011 n-genius. All rights reserved.
//

#import "Transaction.h"

@implementation NSDate (DateWithoutTime)

- (NSDate *)dateWithoutTime {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [formatter stringFromDate:self];
    return [formatter dateFromString:dateString];
}

@end

@implementation Transaction
@synthesize title, price, date;

- (id)init {
    if ((self = [super init])) {
        title = @"";
        price = [[NSNumber alloc] initWithInt:0];
        date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)aTitle price:(double)aPrice date:(NSDate *)aDate {
    if ((self = [super init])) {
        title = aTitle;
        price = [[NSNumber alloc] initWithDouble:aPrice];
        
        date = [[NSDate alloc] init];
        date = aDate;
    }
    
    return self;
}

- (NSDate *)displayableDate {
    return [date dateWithoutTime];
}

- (NSComparisonResult)compare:(Transaction *)transaction {
    return [title compare:transaction.title];
}

- (void)dealloc {
    [price release];
    [date release];
    
    [super dealloc];
}

@end
