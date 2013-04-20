//
//  BDConnection.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDConnection.h"
#import "BDObject.h"
#import "BDSettings.h"

#import "BDBaasday(Private).h"

#import "JSONKit.h"

typedef enum {
    BDConnectionRequestTypeJSON,
    BDConnectionRequestTypeMultipartFormData,
} BDConnectionRequestType;

@interface BDConnection ()

@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong) NSMutableData* response;

@end

@implementation BDConnection

-(NSMutableURLRequest *)requestWithPath:(NSString *)path requestType:(BDConnectionRequestType)requestType
{
    NSAssert(path, @"path is undefined");
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BDAPIURL, path]];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:[BDBaasday applicationId] forHTTPHeaderField:@"X-Baasday-Application-Id"];
    [request setValue:[BDBaasday apiKey] forHTTPHeaderField:@"X-Baasday-Application-Api-Key"];

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

- (BDConnection *)postWithCollectionName:(NSString *)collectionName
                              parameters:(NSDictionary *)parameters
{
    NSString* path = [NSString stringWithFormat:@"/%@", collectionName];
    self.request = [self requestWithPath:path requestType:BDConnectionRequestTypeJSON];
    
    NSData* jsonData = [parameters JSONData];

    [self.request setHTTPMethod:@"POST"];
    [self.request addValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"content-Length"];
    
    [self.request setHTTPBody:jsonData];

    return self;
}

#pragma -
#pragma Handling response

- (NSDictionary *)doRequestWithError:(NSError **)error
{
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
    NSLog(@"dictionaryFromData: %@, %@", data, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

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
