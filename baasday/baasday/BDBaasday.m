//
//  BDBaasday.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBaasday.h"
#import "BDBaasday(Private).h"

@implementation BDBaasday

__strong static NSString* _applicationId = nil;
__strong static NSString* _apiKey = nil;

+ (void)setApplicationId:(NSString *)applicationId apiKey:(NSString *)apiKey
{
    _applicationId = applicationId;
    _apiKey = apiKey;
}

+(NSString *)apiKey
{
    return _apiKey;
}

+(NSString *)applicationId
{
    return _applicationId;
}

+(NSString *)version
{
    return @"1.0";
}

@end
