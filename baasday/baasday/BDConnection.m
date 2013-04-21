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

typedef enum {
    BDConnectionRequestTypeJSON,
    BDConnectionRequestTypeMultipartFormData,
} BDConnectionRequestType;

@interface BDConnection ()

@property (nonatomic, strong) NSString* method;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDictionary* query;
@property (nonatomic, strong) NSDictionary* requestJson;

@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong) NSMutableData* response;

@end

@implementation BDConnection

+ (void)setHeadersWithRequest:(NSMutableURLRequest *)request
{
    [request setValue:[BDBaasday applicationId] forHTTPHeaderField:@"X-Baasday-Application-Id"];
    [request setValue:[BDBaasday apiKey] forHTTPHeaderField:@"X-Baasday-Application-Api-Key"];
    if ([BDUser authorizedKey]) {
        NSLog(@"user-authentication-key: %@",
              [BDUser authorizedKey]);

        [request setValue:[BDUser authorizedKey] forHTTPHeaderField:@"X-Baasday-Application-User-Authentication-Key"];
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

-(NSMutableURLRequest *)requestWithPath:(NSString *)path
{
    return [self requestWithPath:path requestType:BDConnectionRequestTypeJSON];
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
    self.request = [self requestWithPath:self.path requestType:BDConnectionRequestTypeJSON];
    [self.request setHTTPMethod:self.method];
    NSLog(@"HTTP method: %@", self.method);

    if (self.requestJson) {
        NSData* jsonData = [self.requestJson JSONData];
        [self.request addValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"content-Length"];
        [self.request setHTTPBody:jsonData];
    }
}

#pragma -
#pragma Handling response

- (NSDictionary *)doRequestWithError:(NSError **)error
{
    [self buildRequest];
    NSAssert(self.request, @"not set request");
    NSURLResponse* returningResponse;
    NSData* response = [NSURLConnection sendSynchronousRequest:self.request
                                             returningResponse:&returningResponse
                                                         error:error];
    if (!*error) {
        return [self dictionaryFromData:response];
    }
    return nil;
}

- (void)doRequestWithDelegate:(id<BDConnectionDelegate>)delegate;
{
    [self buildRequest];
    NSAssert(self.request, @"not set request");
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                                  delegate:self];
    if (!connection) {
        NSLog(@"cant'init connection");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.response = nil;
    NSLog(@"%@", error);

    [self.delegate connection:self finishedWithDictionary:nil error:error];
}

- (NSDictionary *)dictionaryFromData:(NSData *)data
{
    NSLog(@"dictionaryFromData: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    JSONDecoder *decoder = [JSONDecoder decoder];
    NSError* error;
    return [decoder objectWithData:data error:&error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* dic = [self dictionaryFromData:self.response];
    return [self.delegate connection:self finishedWithDictionary:dic error:nil];
}

@end
