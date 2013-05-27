//
//  BDConnection.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDConnection.h"
#import "BDSettings.h"
#import "BDBaasday(Private).h"
#import "BDUser.h"

#import "JSONKit.h"

@interface BDConnectionOperation : NSOperation {
	NSURLRequest *_request;
	NSMutableData *_responseData;
	BDConnectionResultBlock _block;
	BOOL _isExecuting;
	BOOL _isFinished;
}

- (id)initWithRequest:(NSURLRequest *)request block:(BDConnectionResultBlock)block;

@end

@implementation BDConnectionOperation

- (id)initWithRequest:(NSURLRequest *)request block:(BDConnectionResultBlock)block {
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
	NSDictionary *result = [[JSONDecoder decoder] objectWithData:_responseData error:&error];
	if (error) {
		_block(nil, error);
	} else {
		_block(result, nil);
	}
	[self setValue:[NSNumber numberWithBool:NO] forKey:@"_isExecuting"];
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"_isFinished"];
}

@end

typedef enum {
    BDConnectionRequestTypeFormUrlencoded,
    BDConnectionRequestTypeJSON,
    BDConnectionRequestTypeMultipartFormData,
} BDConnectionRequestType;

@interface BDConnection ()

@property (nonatomic, strong) NSString* method;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDictionary* query;
@property (nonatomic, strong) NSDictionary* requestJson;
@property (nonatomic, strong) NSMutableURLRequest* request;

@end

@implementation BDConnection

+ (void)setHeadersWithRequest:(NSMutableURLRequest *)request
{
    [request setValue:[BDBaasday applicationId] forHTTPHeaderField:@"X-Baasday-Application-Id"];
    [request setValue:[BDBaasday apiKey] forHTTPHeaderField:@"X-Baasday-Application-Api-Key"];
    if ([BDBaasday userAuthenticationKey]) {
        NSLog(@"user-authentication-key: %@",
              [BDBaasday userAuthenticationKey]);

        [request setValue:[BDBaasday userAuthenticationKey] forHTTPHeaderField:@"X-Baasday-Application-User-Authentication-Key"];
    }
}

- (NSMutableURLRequest *)requestWithPath:(NSString *)path requestType:(BDConnectionRequestType)requestType
{
    NSAssert(path, @"path is undefined");
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BDAPIURL, path]];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [BDConnection setHeadersWithRequest:request];

    // [request setValue:VALUE forHTTPHeaderField:@"Field You Want To Set"];
    switch (requestType) {
        case BDConnectionRequestTypeFormUrlencoded:
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case BDConnectionRequestTypeJSON:
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;

        case BDConnectionRequestTypeMultipartFormData:
            [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
            break;
            
        default:
            break;
    }

    return request;
}

#pragma -
#pragma Operation

- (BDConnection *)setMethod:(NSString *)method path:(NSString *)path
{
    NSAssert(method &&
             ([method isEqualToString:@"GET"] ||
              [method isEqualToString:@"POST"] ||
              [method isEqualToString:@"PUT"] ||
              [method isEqualToString:@"DELETE"]), @"HTTP method is wrong");
    
    NSAssert(path, @"undefined path");

    self.method = method;
    self.path = path;
    
    return self;
}

- (BDConnection *)getWithPath:(NSString *)path
{
    return [self setMethod:@"GET" path:path];
}

- (BDConnection *)postWithPath:(NSString *)path
{
    return [self setMethod:@"POST" path:path];
}

- (BDConnection *)putWithPath:(NSString *)path
{
    return [self setMethod:@"PUT" path:path];
}

- (BDConnection *)deleteWithPath:(NSString *)path
{
    return [self setMethod:@"DELETE" path:path];
}

- (BDConnection *)query:(NSDictionary *)query
{
    self.query = query;
    return self;
}

- (NSString *)encode:(id)object
{
    NSString *string = [NSString stringWithFormat: @"%@", object];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

- (NSString*)urlEncodeFromDictionary:(NSDictionary *)dic
{
    NSMutableArray *q = [NSMutableArray array];

    for (id key in dic) {
        id value = [dic objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [self encode:key],
                          [self encode:value]];
        [q addObject:part];
    }
    return [q componentsJoinedByString: @"&"];
}

- (BDConnection *)requestJson:(NSDictionary *)json
{
    self.requestJson = json;
    return self;
}

- (void)buildRequest
{
    NSString *path;
    if (self.query) {
        path = [NSString stringWithFormat:@"%@?%@", self.path, [self urlEncodeFromDictionary:self.query]];
    } else {
        path = self.path;
    }
    if (self.requestJson) {
        self.request = [self requestWithPath:path requestType:BDConnectionRequestTypeJSON];
        int jsonOptionQuoteKeys = (1 << 5);
        NSData* jsonData = [self.requestJson JSONDataWithOptions:jsonOptionQuoteKeys error:nil];
        [self.request addValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        [self.request setHTTPBody:jsonData];
    } else {
        self.request = [self requestWithPath:path requestType:BDConnectionRequestTypeFormUrlencoded];
    }
    [self.request setHTTPMethod:self.method];
    NSLog(@"HTTP method: %@", self.method);
}

#pragma -
#pragma Handling response

- (NSDictionary *)doRequestWithError:(NSError **)error
{
    [self buildRequest];
    NSAssert(self.request, @"not set request");
    NSURLResponse* returningResponse;
	NSError *requestError = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:self.request
												 returningResponse:&returningResponse
															 error:&requestError];
	if (requestError) {
		if (error) *error = requestError;
		NSLog(@"request error: %@", requestError);
		return nil;
	}
	NSError *jsonError;
	NSDictionary *result = [[JSONDecoder decoder] objectWithData:responseData error:&jsonError];
	if (jsonError) {
		if (error) *error = jsonError;
		NSLog(@"JSON error: %@", jsonError);
		return nil;
	}
    return result;
}

- (void)doRequestInBackground:(BDConnectionResultBlock)block
{
    [self buildRequest];
    NSAssert(self.request, @"not set request");
	BDConnectionOperation *operation = [[BDConnectionOperation alloc] initWithRequest:self.request block:block];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
}

+ (NSDictionary *)fetchWithPath:(NSString *)path error:(NSError **)error {
    return [[[[self alloc] init] getWithPath:path] doRequestWithError:error];
}

+ (void)fetchInBackgroundWithPath:(NSString *)path block:(BDConnectionResultBlock)block {
	[[[[self alloc] init] getWithPath:path] doRequestInBackground:block];
}

+ (BDConnection *)connectionForCreateWithPath:(NSString *)path values:(NSDictionary *)values {
	return [[[[self alloc] init] postWithPath:path] requestJson:values];
}

+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values error:(NSError **)error {
	return [[self connectionForCreateWithPath:path values:values] doRequestWithError:error];
}

+ (void)createInBackgroundWithPath:(NSString *)path values:(NSDictionary *)values block:(BDConnectionResultBlock)block {
	[[self connectionForCreateWithPath:path values:values] doRequestInBackground:block];
}

+ (BDConnection *)connectionForFetchAllWithPath:(NSString *)path query:(BDQuery *)query {
	BDConnection *connection = [[[self alloc] init] getWithPath:path];
	if (query) [connection query:query.apiRequestParameters];
	return connection;
}

+ (BDListResult *)fetchAllWithPath:(NSString *)path query:(BDQuery *)query error:(NSError **)error {
	BDConnection *connection = [self connectionForFetchAllWithPath:path query:query];
	NSDictionary *result = [connection doRequestWithError:error];
	if (!result) return nil;
	return [[BDListResult alloc] initWithAPIResult:result];
}

+ (void)fetchAllInBackgroundWithPath:(NSString *)path query:(BDQuery *)query block:(void(^)(BDListResult *result, NSError *error))block {
	BDConnection *connection = [self connectionForFetchAllWithPath:path query:query];
	[connection doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(result ? [[BDListResult alloc] initWithAPIResult:result] : nil, error);
	}];
}

@end
