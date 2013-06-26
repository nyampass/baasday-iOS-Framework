//
//  BDBaasday.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBaasday.h"
#import "BDBaasday_Private.h"

#import "BDSettings.h"

@implementation BDBaasday

static NSString* _applicationId = nil;
static NSString* _apiKey = nil;

+ (void)setApplicationId:(NSString *)applicationId apiKey:(NSString *)apiKey {
    _applicationId = applicationId;
    _apiKey = apiKey;
}

+ (NSString *)apiKey {
    return _apiKey;
}

+ (NSString *)applicationId {
    return _applicationId;
}

+ (NSString *)version {
    return BDClientVersion;
}

static NSString *_userAuthenticationKey = nil;

+ (void)setUserAuthenticationKey:(NSString *)key {
    _userAuthenticationKey = key;
}

+ (NSString *)userAuthenticationKey {
    return _userAuthenticationKey;
}

static NSString *_deviceId = nil;

+ (void)setDeviceId:(NSString *)deviceId {
    _deviceId = deviceId;
}

+ (NSString *)deviceId {
    return _deviceId;
}

static NSString *_apiURLRoot = BD_API_URL_ROOT;

+ (NSString *)apiURLRoot {
	return _apiURLRoot;
}

+ (void)setAPIURLRoot:(NSString *)apiURLRoot {
	_apiURLRoot = apiURLRoot;
}

@end
