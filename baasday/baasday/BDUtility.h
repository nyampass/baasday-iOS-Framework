//
//  BDUtility.h
//  baasday
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDUtility : NSObject

+ (id)fixObjectForJSON:(id)object;
+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary;
+ (id)fixObjectInJSON:(id)object;
+ (NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData errr:(NSError **)error;
+ (NSString *)base64Encode:(NSData *)data;

@end
