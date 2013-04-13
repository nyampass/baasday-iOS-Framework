//
//  BDConnection.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDObject.h"

@interface BDConnection : NSObject

- (BDConnection *)post:(BDObject *)object;

- (NSError *)request;
- (void)requstWithBlock:(BDObjectResultBlock)block;

@end
