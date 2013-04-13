//
//  BDObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"

#import "BDConnection.h"

@interface BDObject ()

@property (nonatomic, retain) NSString* collectionName;

@end

@implementation BDObject

-(id)initWithCollectionName:(NSString *)collectionName
{
    self = [super init];
    if (self) {
        self.objectId = nil;
        self.collectionName = collectionName;
    }
    return self;
}

- (void)saveWithBlock:(BDObjectResultBlock)block
{
    BDConnection* connection = [[BDConnection alloc] init];
    [[connection post:self] requstWithBlock:block];
}

- (BOOL)save
{
    BDConnection* connection = [[BDConnection alloc] init];
    return [[connection post:self] request] == nil;
}

@end
