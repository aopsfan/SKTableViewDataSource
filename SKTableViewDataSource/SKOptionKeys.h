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

@property (nonatomic, strong)NSMutableSet *objects;
@property (nonatomic, strong)NSMutableString *entityName;
@property (nonatomic, strong)NSFetchRequest *fetchRequest;
@property (nonatomic, strong)NSObject *target;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)SKDataFilter *predicateFilter;
@property (nonatomic, readonly)NSUInteger objectOptionsCount;

+ (NSString *)objectsOption DEPRECATED_ATTRIBUTE;
+ (NSString *)entityNameOption DEPRECATED_ATTRIBUTE;
+ (NSString *)fetchRequestOption DEPRECATED_ATTRIBUTE;
+ (NSString *)targetOption DEPRECATED_ATTRIBUTE;
+ (NSString *)managedObjectContextOption DEPRECATED_ATTRIBUTE;
+ (NSString *)predicateFilterOption DEPRECATED_ATTRIBUTE;

@end
