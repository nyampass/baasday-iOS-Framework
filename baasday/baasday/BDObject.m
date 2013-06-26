//
//  BDObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject_Private.h"
#import "BDAPIClient.h"

@interface BDObject ()

@end

@implementation BDObject

- (NSString *)id {
	return [self objectForKey:@"_id"];
}

- (NSDate *)createdAt {
	return [self objectForKey:@"_createdAt"];
}

- (NSDate *)updatedAt {
	return [self objectForKey:@"_updatedAt"];
}

- (BOOL)update:(NSDictionary *)values error:(NSError **)error {
    NSDictionary *newValues = [[[[[BDAPIClient alloc] init] putWithPath:self.apiPath] requestJson:values] doRequestWithError:error];
	if (newValues == nil) return NO;
    [self setValues:newValues];
    return YES;
}

- (BOOL)update:(NSDictionary *)values {
	return [self update:values error:nil];
}

- (void)updateInBackground:(NSDictionary *)values block:(void (^)(id, NSError *))block {
	[[[[[BDAPIClient alloc] init] putWithPath:self.apiPath] requestJson:values] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		if (result) {
            [self setValues:result];
			block(self, error);
		} else {
			block(self, error);
		}
	}];
}

- (BOOL)deleteWithError:(NSError **)error {
	if ([[[[BDAPIClient alloc] init] deleteWithPath:self.apiPath] doRequestWithError:error]) {
		return YES;
	}
	return NO;
}

- (BOOL)delete {
	return [self deleteWithError:nil];
}

- (void)deleteInBackground:(void (^)(id, NSError *))block {
	[[[[BDAPIClient alloc] init] deleteWithPath:self.apiPath] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(self, error);
	}];
}

@end
