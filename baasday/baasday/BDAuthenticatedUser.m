//
//  BDAuthenticatedUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDAuthenticatedUser.h"
#import "BDBaasday.h"

@implementation BDAuthenticatedUser

+ (NSString *)path {
    return @"me";
}

- (NSString *)objectPath {
	return [BDAuthenticatedUser path];
}

- (NSString *)authenticationKey {
	return [self objectForKey:@"_authenticationKey"];
}

+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values error:(NSError **)error {
	BDUser *user = [BDUser createWithValues:values error:error];
	if (!user) return nil;
	return [[self alloc] initWithValues:user.values];
}

+ (BDAuthenticatedUser *)createWithError:(NSError **)error {
	return [self createWithValues:[NSDictionary dictionary] error:error];
}

+ (BDAuthenticatedUser *)fetchWithError:(NSError **)error {
	NSAssert([BDBaasday userAuthenticationKey], @"userAuthenticationKey is not set");
	return [[self alloc] initWithValues:[BDConnection fetchWithPath:[self path] error:error]];
}

@end
