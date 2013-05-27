//
//  BDBasic.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"
#import "BDConnection.h"
#import "BDQuery.h"

@implementation BDObject

- (id)initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	if (self = [super initWithValues:values]) {
		self.collectionName = collectionName;
	}
	return self;
}

- (id)initWithCollectionName:(NSString *)collectionName {
	return [self initWithCollectionName:collectionName values:@{}];
}

+ (NSString *)collectionPathWithCollectionName:(NSString *)collectionName {
	return [NSString stringWithFormat:@"objects/%@", collectionName];
}

- (NSString *)collectionPath {
	return [BDObject collectionPathWithCollectionName:self.collectionName];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDConnection createWithPath:collectionName values:values error:error];
	if (!result) return nil;
	return [[self alloc] initWithCollectionName:collectionName values:result];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	return [self createWithCollectionName:collectionName values:values error:nil];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error {
	BDListResult *result = [BDConnection fetchAllWithPath:[self collectionPathWithCollectionName:collectionName] query:query error:nil];
	if (!result) return nil;
	NSMutableArray *objects = [NSMutableArray array];
	for (NSDictionary *values in result.contents) {
		[objects addObject:[[self alloc] initWithCollectionName:collectionName values:values]];
	}
	return [[BDListResult alloc] initWithObjects:objects count:result.count];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query {
	return [self fetchAllWithCollectionName:collectionName query:query error:nil];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error {
	return [self fetchAllWithCollectionName:collectionName query:nil error:nil];
}

+ (BDListResult *)fetchALlWIthCollectionName:(NSString *)collectionName {
	return [self fetchAllWithCollectionName:collectionName error:nil];
}

@end

