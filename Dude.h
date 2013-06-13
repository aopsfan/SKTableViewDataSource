#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Dude : NSObject {
    NSString *name;
    UIColor *hairColor;
    NSNumber *height;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIColor *hairColor;
@property (nonatomic, strong) NSNumber *height;

- (id)initWithName:(NSString *)aName hairColor:(UIColor *)aHairColor height:(NSNumber *)aHeight;
+ (Dude *)dudeWithName:(NSString *)aName hairColor:(UIColor *)aHairColor height:(NSNumber *)aHeight;
- (NSComparisonResult)compare:(Dude *)otherDude;

- (NSString *)initial;

@end
