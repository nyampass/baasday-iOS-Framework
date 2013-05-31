//
//  BDUtility.m
//  baasday
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDUtility.h"
#import "JSONKit.h"

@implementation BDUtility

+ (id)fixObjectForJSON:(id)object {
	if (object == nil) {
		return nil;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *fixed = [NSMutableDictionary dictionary];
		for (id field in object) [fixed setValue:[self fixObjectForJSON:[object valueForKey:field]] forKey:field];
		return fixed;
	} else if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray *fixed = [NSMutableArray array];
		for (id value in object) [fixed addObject:[self fixObjectForJSON:value]];
		return fixed;
	} else if ([object isKindOfClass:[NSDate class]]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
		return @{@"$type": @"datetime", @"$value": [dateFormatter stringFromDate:object]};
	} else {
		return object;
	}
}

+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary {
	return [[BDUtility fixObjectForJSON:dictionary] JSONData];
}

+ (id)fixObjectInJSON:(id)object {
	if (object == nil) {
		return nil;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dictionary = (NSDictionary *) object;
		NSArray *fields = dictionary.allKeys;
		if ([fields containsObject:@"$type"] && [[dictionary valueForKey:@"$type"] isEqualToString:@"datetime"] && [fields containsObject:@"$value"]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			NSDate *date = nil;
			NSError *error = nil;
			dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ";
			[dateFormatter getObjectValue:&date forString:[dictionary valueForKey:@"$value"] range:nil error:&error];
			if (!error) return date;
			dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'";
			dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
			[dateFormatter getObjectValue:&date forString:[dictionary valueForKey:@"$value"] range:nil error:&error];
			if (!error) return date;
			return nil;
		} else {
			NSMutableDictionary *fixed = [NSMutableDictionary dictionary];
			for (id field in dictionary) [fixed setValue:[self fixObjectInJSON:[dictionary valueForKey:field]] forKey:field];
			return fixed;
		}
	} else if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray *fixed = [NSMutableArray array];
		for (id value in object) [fixed addObject:[self fixObjectInJSON:value]];
		return fixed;
	} else {
		return object;
	}
}

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData errr:(NSError **)error {
	return [self fixObjectInJSON:[[JSONDecoder decoder] objectWithData:jsonData error:error]];
}

@end
