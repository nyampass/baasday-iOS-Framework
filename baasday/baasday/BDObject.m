//
//  BDBasic.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"

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

- (NSString *)collectionPath {
    return [NSString stringWithFormat:@"objects/%@", self.collectionName];
}

@end

