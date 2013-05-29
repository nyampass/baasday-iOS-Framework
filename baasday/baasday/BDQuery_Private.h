//
//  BDQuery_Private.h
//  baasday
//
//  Created by Yuu Shimizu on 5/27/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDQuery.h"

@interface BDFieldOrder (Private)

@property (readonly) NSString *parameterString;

@end

@interface BDQuery (Private)

@property (readonly) NSDictionary *requestParameters;

@end
