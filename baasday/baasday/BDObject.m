//
//  BDObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"

@interface BDObject ()

@property (nonatomic, strong) NSString* collectionName;
@property (nonatomic, strong) NSDictionary* fields;

@end

@implementation BDObject

-(id)initWithCollectionName:(NSString *)collectionName
{
    self = [super init];
    if (self) {
        self.objectId = nil;
        self.collectionName = collectionName;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.objectId = nil;
        self.fields = dictionary;
    }
    return self;
}

- (void)updateFromDictionary:(NSDictionary *)dic
{
    NSLog(@"%@", dic);
    self.fields = dic;
}

- (void)saveWithBlock:(BDObjectResultBlock)block
{
    self.block = block;
    BDConnection* connection = [[BDConnection alloc] init];
    [[connection postWithPath:self.collectionName] doRequestWithDelegate:self];
}

+ (BDObject *)findWithPath:(NSString *)path
{
    BDConnection* connection = [[BDConnection alloc] init];
    NSError* error;

    NSDictionary* dic = [[connection getWithPath:path] doRequestWithError:&error];

    if (!error)
        return [[self alloc] initWithDictionary:dic];

    NSLog(@"%@", error);
    return nil;
}

- (BOOL)save
{
    BDConnection* connection = [[BDConnection alloc] init];
    NSError* error;
    NSDictionary* params = [NSDictionary dictionary];
    NSDictionary* dic = [[[connection postWithPath:self.collectionName]
                          requestJson:params] doRequestWithError:&error];
    
    if (!error) {
        [self updateFromDictionary:dic];
    } else {
        NSLog(@"%@", error);
    }
    
    return (error == nil);
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self.fields objectForKey:key];
}

-(void)connection:(BDConnection *)connection finishedWithDictionary:(NSDictionary *)dictionary error:(NSError *)error
{
//    self.block(
}

@end
