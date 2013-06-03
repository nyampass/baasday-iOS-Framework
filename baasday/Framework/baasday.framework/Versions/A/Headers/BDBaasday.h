//
//  BDBaasday.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBaasday : NSObject

+ (void)setApplicationId:(NSString *)applicationId apiKey:(NSString *)apiKey;
+ (NSString *)applicationId;
+ (NSString *)apiKey;
+ (NSString *)version;
+ (void)setUserAuthenticationKey:(NSString *)key;
+ (NSString *)userAuthenticationKey;
+ (NSString *)apiURLRoot;
+ (void)setAPIURLRoot:(NSString *)apiURLRoot;

@end
