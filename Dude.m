#import "Dude.h"

@implementation Dude
@synthesize name, height, hairColor;

- (id)initWithName:(NSString *)aName hairColor:(UIColor *)aHairColor height:(NSNumber *)aHeight {
    self = [super init];
    
    if (self) {
        self.name = aName;
        self.hairColor = [[UIColor alloc] initWithCGColor:aHairColor.CGColor];
        self.height = [[NSNumber alloc] initWithInt:[aHeight intValue]];
    }
    
    return self;
}

+ (Dude *)dudeWithName:(NSString *)aName hairColor:(UIColor *)aHairColor height:(NSNumber *)aHeight {
    Dude *dude = [[Dude alloc] initWithName:aName hairColor:aHairColor height:aHeight];
    return dude;
}

- (NSString *)lastName {
    NSArray *arrayOfNames = [self.name componentsSeparatedByString:@" "];
    return [arrayOfNames objectAtIndex:[arrayOfNames count]-1];
}

- (NSComparisonResult)compare:(Dude *)otherDude {
    NSComparisonResult comparisonResult = [[self lastName] compare:[otherDude lastName]];
    
    if (comparisonResult == NSOrderedSame) {
        return [[self name] compare:[otherDude name]];
    }
    
    return comparisonResult;
}

- (NSString *)initial {
    NSArray *arrayOfNames = [self.name componentsSeparatedByString:@" "];
    NSString *lastName = [arrayOfNames objectAtIndex:[arrayOfNames count]-1];
    unichar newChar = [lastName characterAtIndex:0];
    NSString *initial = [NSString stringWithFormat:@"%C", newChar];
    
    return initial;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name is %@, height is %i", self.name, [self.height intValue]];
}

@end


