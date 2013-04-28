//
//  BDBasicObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDBasicObject.h"

@interface BDObject : BDBasicObject

@property (nonatomic, strong) NSString* collectionName;

- initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values saved:(BOOL)saved;
- initWithCollectionName:(NSString *)collectionName saved:(BOOL)saved;

@end
