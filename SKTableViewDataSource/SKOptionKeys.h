#import <Foundation/Foundation.h>
#import <CoreData/NSFetchRequest.h>
#import <CoreData/NSManagedObjectContext.h>
#import "SKDataFilter.h"
#import <AvailabilityMacros.h>

@interface SKOptionKeys : NSObject {
    NSMutableSet *objects;
    NSMutableString *entityName;
    NSFetchRequest *fetchRequest;
    NSObject *target;
    NSManagedObjectContext *managedObjectContext;
    SKDataFilter *predicateFilter;
    
    NSUInteger objectOptionsCount;
}

@property (nonatomic, retain)NSMutableSet *objects;
@property (nonatomic, retain)NSMutableString *entityName;
@property (nonatomic, retain)NSFetchRequest *fetchRequest;
@property (nonatomic, retain)NSObject *target;
@property (nonatomic, retain)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain)SKDataFilter *predicateFilter;
@property (nonatomic, readonly)NSUInteger objectOptionsCount;

+ (NSString *)objectsOption DEPRECATED_ATTRIBUTE;
+ (NSString *)entityNameOption DEPRECATED_ATTRIBUTE;
+ (NSString *)fetchRequestOption DEPRECATED_ATTRIBUTE;
+ (NSString *)targetOption DEPRECATED_ATTRIBUTE;
+ (NSString *)managedObjectContextOption DEPRECATED_ATTRIBUTE;
+ (NSString *)predicateFilterOption DEPRECATED_ATTRIBUTE;

@end
