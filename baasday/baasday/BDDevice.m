//
//  BDDevice.m
//  baasday
//

#import "BDDevice.h"
#import "BDBasicObject_Private.h"
#import "BDUtility.h"

@implementation BDDevice

- (void)setDeviceToken:(NSData *)deviceToken {
    [[self mutableValues] setObject:@{@"apns": @{@"deviceToken": [BDUtility base64Encode:deviceToken]}} forKey:@"pushNotification"];
}

+ (NSString *)generateDeviceId {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return [NSString stringWithFormat:@"ios:%@", uuidString];
}

@end
