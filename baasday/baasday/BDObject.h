//
//  BDObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDObject;

typedef void (^BDObjectResultBlock) (BDObject*, BOOL, NSError*);

@interface BDObject : NSObject

@property (nonatomic, retain, readonly) NSString* collectionName;
@property (nonatomic, retain) NSString* objectId;

- initWithCollectionName:(NSString *)collectionName;
- (BOOL)save;
- (void)saveWithBlock:(BDObjectResultBlock)block;

@end
