//
//  BDAPIClient.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDAPIClient.h"
#import "BDSettings.h"
#import "BDBaasday_Private.h"
#import "BDQuery_Private.h"
#import "BDListResult_Private.h"
#import "BDUser.h"
#import "BDUtility.h"

@interface BDAPIOperation : NSOperation {
	NSURLRequest *_request;
	NSMutableData *_responseData;
	BDDictionaryResultBlock _block;
	BOOL _isExecuting;
	BOOL _isFinished;
}

- (id)initWithRequest:(NSURLRequest *)request block:(BDDictionaryResultBlock)block;

@end

@implementation BDAPIOperation

- (id)initWithRequest:(NSURLRequest *)request block:(BDDictionaryResultBlock)block {
	if (self = [super init]) {
		_request = request;
		_block = block;
		_isExecuting = NO;
		_isFinished = NO;
	}
	return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key {
	if ([key isEqualToString:@"_isExecuting"] ||
		[key isEqualToString:@"_isFinished"]) {
		return YES;
	}
	return [super automaticallyNotifiesObserversForKey:key];
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isExecuting {
	return _isExecuting;
}

- (BOOL)isFinished {
	return _isFinished;
}

- (void)start {
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"_isExecuting"];
	[self setValue:[NSNumber numberWithBool:NO] forKey:@"_isFinished"];
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
	if (connection) {
		do {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (_isExecuting);
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
	_block(nil, error);
	[self setValue:[NSNumber numberWithBool:NO] forKey:@"_isExecuting"];
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"_isFinished"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error = nil;
	NSDictionary *result = [BDUtility dictionaryFromJSONData:_responseData errr:&error];
	if (error) {
		_block(nil, error);
	} else {
		_block(result, nil);
	}
	[self setValue:[NSNumber numberWithBool:NO] forKey:@"_isExecuting"];
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"_isFinished"];
}

@end

@interface BDAPIClient () {
	NSString *_requestMethod;
	NSString *_path;
	NSDictionary *_requestParameters;
	NSDictionary *_requestJSON;
}

@end

@implementation BDAPIClient

- (BDAPIClient *)setRequestMethod:(NSString *)requestMethod path:(NSString *)path
{
    NSAssert(requestMethod &&
             ([requestMethod isEqualToString:@"GET"] ||
              [requestMethod isEqualToString:@"POST"] ||
              [requestMethod isEqualToString:@"PUT"] ||
              [requestMethod isEqualToString:@"DELETE"]), @"HTTP method is wrong");
    NSAssert(path, @"undefined path");
	_requestMethod = requestMethod;
	_path = path;
    return self;
}

- (BDAPIClient *)getWithPath:(NSString *)path {
    return [self setRequestMethod:@"GET" path:path];
}

- (BDAPIClient *)postWithPath:(NSString *)path {
    return [self setRequestMethod:@"POST" path:path];
}

- (BDAPIClient *)putWithPath:(NSString *)path {
    return [self setRequestMethod:@"PUT" path:path];
}

- (BDAPIClient *)deleteWithPath:(NSString *)path {
    return [self setRequestMethod:@"DELETE" path:path];
}

- (BDAPIClient *)requestParameters:(NSDictionary *)requestParameters {
	_requestParameters = requestParameters;
    return self;
}

+ (void)setAuthenticationHeadersToRequest:(NSMutableURLRequest *)request
{
    [request setValue:[BDBaasday applicationId] forHTTPHeaderField:@"X-Baasday-Application-Id"];
    [request setValue:[BDBaasday apiKey] forHTTPHeaderField:@"X-Baasday-Application-Api-Key"];
    if ([BDBaasday userAuthenticationKey]) {
        NSLog(@"user-authentication-key: %@",
              [BDBaasday userAuthenticationKey]);
        [request setValue:[BDBaasday userAuthenticationKey] forHTTPHeaderField:@"X-Baasday-Application-User-Authentication-Key"];
    }
}

+ (NSString *)urlEncode:(id)object {
    NSString *string = [NSString stringWithFormat: @"%@", object];
	return  (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(nil, (__bridge CFStringRef) string, nil, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

+ (NSString*)queryString:(NSDictionary *)dictionary {
    NSMutableArray *pairs = [NSMutableArray array];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        [pairs addObject:[NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]]];
    }
    return [pairs componentsJoinedByString: @"&"];
}

- (NSString *)queryString {
	return [BDAPIClient queryString:_requestParameters];
}

- (BDAPIClient *)requestJson:(NSDictionary *)requestJSON {
	_requestJSON = requestJSON;
    return self;
}

- (NSURLRequest *)request {
    NSString *path;
    if (_requestParameters) {
        path = [NSString stringWithFormat:@"%@?%@", _path, [self queryString]];
    } else {
		path = _path;
    }
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BD_API_URL_ROOT, path]]];
	[request setHTTPMethod:_requestMethod];
	[BDAPIClient setAuthenticationHeadersToRequest:request];
	if (_requestJSON) {
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		NSData *jsonData = [BDUtility jsonDataFromDictionary:_requestJSON];
        [request addValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
    }

    NSLog(@"HTTP: %@ %@", _requestMethod, path);
	return request;
}

- (NSDictionary *)doRequestWithError:(NSError **)error {
    NSURLRequest *request = [self request];
    NSURLResponse* returningResponse;
	NSError *requestError = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&returningResponse error:&requestError];
	if (requestError) {
		if (error) *error = requestError;
		NSLog(@"request error: %@", requestError);
		return nil;
	}
	NSError *jsonError;
	NSDictionary *result = [BDUtility dictionaryFromJSONData:responseData errr:&jsonError];
	if (jsonError) {
		if (error) *error = jsonError;
		NSLog(@"JSON error: %@", jsonError);
		return nil;
	}
    return result;
}

- (void)doRequestInBackground:(BDDictionaryResultBlock)block {
	NSURLRequest *request = [self request];
	BDAPIOperation *operation = [[BDAPIOperation alloc] initWithRequest:request block:block];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
}

+ (NSDictionary *)fetchWithPath:(NSString *)path error:(NSError **)error {
    return [[[[self alloc] init] getWithPath:path] doRequestWithError:error];
}

+ (void)fetchInBackgroundWithPath:(NSString *)path block:(BDDictionaryResultBlock)block {
	[[[[self alloc] init] getWithPath:path] doRequestInBackground:block];
}

+ (BDAPIClient *)apiClientForCreateWithPath:(NSString *)path values:(NSDictionary *)values {
	return [[[[self alloc] init] postWithPath:path] requestJson:values];
}

+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values error:(NSError **)error {
	return [[self apiClientForCreateWithPath:path values:values] doRequestWithError:error];
}

+ (void)createInBackgroundWithPath:(NSString *)path values:(NSDictionary *)values block:(BDDictionaryResultBlock)block {
	[[self apiClientForCreateWithPath:path values:values] doRequestInBackground:block];
}

+ (BDAPIClient *)apiClientForFetchAllWithPath:(NSString *)path query:(BDQuery *)query {
	return [[[[self alloc] init] getWithPath:path] requestParameters:query ? query.requestParameters : nil];
}

+ (BDListResult *)fetchAllWithPath:(NSString *)path query:(BDQuery *)query error:(NSError **)error {
	BDAPIClient *connection = [self apiClientForFetchAllWithPath:path query:query];
	NSDictionary *result = [connection doRequestWithError:error];
	if (!result) return nil;
	return [[BDListResult alloc] initWithAPIResult:result];
}

+ (void)fetchAllInBackgroundWithPath:(NSString *)path query:(BDQuery *)query block:(void(^)(BDListResult *result, NSError *error))block {
	BDAPIClient *connection = [self apiClientForFetchAllWithPath:path query:query];
	[connection doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(result ? [[BDListResult alloc] initWithAPIResult:result] : nil, error);
	}];
}

@end
