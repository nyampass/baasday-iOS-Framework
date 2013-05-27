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

+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values {
	return [self createWithValues:values error:nil];
}

+ (BDAuthenticatedUser *)createWithError:(NSError **)error {
	return [self createWithValues:[NSDictionary dictionary] error:error];
}

+ (BDAuthenticatedUser *)create {
	return [self createWithError:nil];
}

+ (void)createInBackgroundWithValues:(NSDictionary *)values block:(BDAuthenticatedUserResultBlock)block {
	[BDUser createInBackgroundWithValues:values block:^(BDUser *user, NSError *error) {
		block(user ? [[self alloc] initWithValues:user.values] : nil, error);
	}];
}

+ (void)createInBackground:(BDAuthenticatedUserResultBlock)block {
	[self createInBackgroundWithValues:nil block:block];
}

+ (BDAuthenticatedUser *)fetchWithError:(NSError **)error {
	NSAssert([BDBaasday userAuthenticationKey], @"userAuthenticationKey is not set");
	return [[self alloc] initWithValues:[BDConnection fetchWithPath:[self path] error:error]];
}

+ (BDAuthenticatedUser *)fetch {
	return [self fetchWithError:nil];
}

+ (void)fetchInBackground:(BDAuthenticatedUserResultBlock)block {
	[BDConnection fetchInBackgroundWithPath:[self path] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithValues:result] : nil, error);
	}];
}

@end
