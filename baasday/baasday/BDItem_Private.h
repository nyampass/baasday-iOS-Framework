//
//  BDItem_Private.h
//  baasday
//
//  Created by Yuu Shimizu on 5/29/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDItem.h"
#import "BDObject_Private.h"

@interface BDItem (Private)

- initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
- initWithCollectionName:(NSString *)collectionName;

@end
