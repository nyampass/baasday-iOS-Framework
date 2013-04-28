//
//  BDUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"
#import "BDConnection.h"

@implementation BDUser

+ (NSString *)path {
	return @"users";
}

- (NSString *)collectionPath {
	return [BDUser path];
}

+ (BDUser *)createWithValues:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDConnection createWithPath:[self path] values:values error:error];
	if (!result) return nil;
	return [[self alloc] initWithValues:result saved:YES];
}

+ (BDUser *)createWithError:(NSError **)error {
	return [self createWithValues:@{} error:error];
}

@end
