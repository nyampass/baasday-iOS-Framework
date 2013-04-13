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

typedef enum {
    BDConnectionRequestTypeJSON,
    BDConnectionRequestTypeMultipartFormData,
} BDConnectionRequestType;

@implementation BDConnection

-(NSMutableURLRequest *)requestWithPath:(NSString *)path requestType:(BDConnectionRequestType)requestType
{
    NSAssert(path, @"path is undefined");
    NSURL* url = [NSURLRequest requestWithURL:[NSString stringWithFormat:@"%@%path", BDAPIURL, path]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];

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

-(BDConnection *)post:(BDObject *)object {
    return self;
}

#pragma -
#pragma Handling response

- (NSError *)request
{
    return nil;
}

- (void)requstWithBlock:(BDObjectResultBlock)block
{
    
}

@end
