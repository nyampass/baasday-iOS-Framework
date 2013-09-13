//
//  BDBasicObject_Private.h
//  baasday
//

#import "BDBasicObject.h"

@interface BDBasicObject (Private)

- (id)initWithValues:(NSDictionary *)values;
- (void)setValues:(NSDictionary *)values;
- (NSMutableDictionary *)mutableValues;

@end
