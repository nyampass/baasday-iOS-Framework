//
//  BDUtility.m
//  baasday
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDUtility.h"
#import "BDBasicObject.h"

@implementation BDUtility

+ (NSDateFormatter *)dateFormatter // fix japanege environment datetime setting
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    return formatter;
}

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
		NSDateFormatter *dateFormatter = [self dateFormatter];
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
		return @{@"$type": @"datetime", @"$value": [dateFormatter stringFromDate:object]};
    } else if ([object isKindOfClass:[BDBasicObject class]]) {
        return [self fixObjectForJSON:((BDBasicObject *) object).values];
	} else {
		return object;
	}
}

+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[BDUtility fixObjectForJSON:dictionary]
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Error creating JSON object %@", error);
    }
    return jsonData;
}

+ (id)fixObjectInJSON:(id)object {
	if (object == nil) {
		return nil;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dictionary = (NSDictionary *) object;
		NSArray *fields = dictionary.allKeys;
		if ([fields containsObject:@"$type"] && [[dictionary valueForKey:@"$type"] isEqualToString:@"datetime"] && [fields containsObject:@"$value"]) {
			NSDateFormatter *dateFormatter = [self dateFormatter];
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
    return [NSJSONSerialization
            JSONObjectWithData:jsonData
            options:kNilOptions
            error:error];
}

+ (NSString *)base64Encode:(NSData *)data {
	static const char *const base64Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	int dataLength = [data length];
	int encodedLength = ceil(dataLength * 4.0 / 3.0);
	int padLength = 3 - dataLength % 3;
	if (padLength == 3) padLength = 0;
	char *encoded = (char *) malloc(sizeof(char) * (encodedLength + padLength + 1));
	const unsigned char *token = [data bytes];
	const unsigned char *tokenPointer = token;
	char *encodedPointer = encoded;
	int i;
	unsigned char rest = 0;
	for (i = 0; i < dataLength; ++i) {
		int shiftLength = (i % 3) * 2 + 2;
		*encodedPointer = base64Characters[(rest << (8 - shiftLength)) | (*tokenPointer >> shiftLength)];
		++encodedPointer;
		rest = *tokenPointer & (0xff >> (8 - shiftLength));
		if (i % 3 == 2) {
			*encodedPointer = base64Characters[rest];
			++encodedPointer;
			rest = 0;
		}
		++tokenPointer;
	}
	if (rest != 0) {
		*encodedPointer = base64Characters[rest << (padLength % 3 * 2)];
		++encodedPointer;
	}
	for (i = 0; i < padLength; ++i) {
		*encodedPointer = '=';
		++encodedPointer;
	}
	*encodedPointer = '\0';
    return [NSString stringWithCString:encoded encoding:NSASCIIStringEncoding];
}

@end
