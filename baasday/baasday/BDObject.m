//
//  BDBasic.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"

@implementation BDObject

- (id)initWithCollectionName:(NSString *)collectionName {
    if (self = [super init]) {
        self.collectionName = collectionName;
    }
    return self;
}

- (NSString *)collectionPath {
    return [NSString stringWithFormat:@"objects/%@", self.collectionName];
}

@end

