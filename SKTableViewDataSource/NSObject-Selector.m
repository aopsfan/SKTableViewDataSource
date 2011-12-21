#import "NSObject-Selector.h"
#import <objc/message.h>

@implementation NSObject (Selector)

- (id)arcPerformSelector:(SEL)sel {
    id object = objc_msgSend(self, sel);
    return object;
}

@end
