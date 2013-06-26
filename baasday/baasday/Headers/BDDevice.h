//
//  BDDevice.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDBasicObject.h"

@interface BDDevice : BDBasicObject

+ (NSString *)generateDeviceId;
- (void)setDeviceToken:(NSData *)deviceToken;

@end
