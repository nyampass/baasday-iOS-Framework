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

static NSString* userAuthenticationKey = nil;

+ (void)setUserAuthenticationKey:(NSString *)key {
    userAuthenticationKey = key;
}

+ (NSString *)userAuthenticationKey {
    return userAuthenticationKey;
}

static NSString *apiURLRoot = BD_API_URL_ROOT;

+ (NSString *)apiURLRoot {
	return apiURLRoot;
}

+ (void)setAPIURLRoot:(NSString *)apiURLRoot {
	apiURLRoot = apiURLRoot;
}

@end
