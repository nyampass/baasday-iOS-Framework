//
//  BDBasicObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"

@interface BDBasicObject ()

@property (nonatomic, strong) NSDictionary* fields;

@end

@implementation BDBasicObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.objectId = nil;
        self.fields = dictionary;
    }
    return self;
}

- (id)valueForKey:(NSString *)key {
    return [self.fields valueForKey:key];
}

- (NSString *)path {
    return [NSString stringWithFormat:@"%@/%@", self.collectionPath, self.objectId];
}

- (NSString *)pathForFetch {
    return self.path;
}

- (NSString *)pathForUpdate {
    return self.path;
}

- (NSString *)pathForDelete {
    return self.path;
}

- (void)updateFromDictionary:(NSDictionary *)dic
{
    NSLog(@"%@", dic);
    self.fields = dic;
}

- (BOOL)update:(NSDictionary *)values {
    BDConnection* connection = [[BDConnection alloc] init];
    NSError *error;
    NSDictionary *result = [[[connection putWithPath:self.pathForUpdate] requestJson:values] doRequestWithError:&error];
    if (error) {
        NSLog(@"%@", error);
        return false;
    }
    [self updateFromDictionary:result];
    return true;
}

- (void)saveWithBlock:(BDBasicObjectResultBlock)block
{
    self.block = block;
    BDConnection* connection = [[BDConnection alloc] init];
    [[connection postWithPath:self.collectionPath] doRequestWithDelegate:self];
}

+ (BDBasicObject *)findWithPath:(NSString *)path
{
    BDConnection* connection = [[BDConnection alloc] init];
    NSError* error;
    
    NSDictionary* dic = [[connection getWithPath:path] doRequestWithError:&error];
    
    if (!error)
        return [[self alloc] initWithDictionary:dic];
    
    NSLog(@"%@", error);
    return nil;
}

+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values {
    BDConnection *connection = [[BDConnection alloc] init];
    NSError *error;
    NSDictionary *result = [[[connection postWithPath:path] requestJson:values] doRequestWithError:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return result;
}

<<<<<<< HEAD
+ (NSArray *)fetchWithPath:(NSString *)path skip:(NSInteger)skip limit:(NSInteger)limit {
    BDConnection *connection = [[BDConnection alloc] init];
    NSError *error;
    NSDictionary *result = [[[connection getWithPath:path] query:@{@"skip": [NSNumber numberWithInt:skip], @"limit": [NSNumber numberWithInt:limit]}] doRequestWithError:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return [result valueForKey:@"_contents"];
}

=======
>>>>>>> temp1
- (BOOL)save
{
    BDConnection* connection = [[BDConnection alloc] init];
    NSError* error;
    NSDictionary* params = [NSDictionary dictionary];
    NSDictionary* dic = [[[connection postWithPath:self.collectionPath]
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

- (NSNumber *)numberForKey:(NSString *)key
{
    return [self.fields objectForKey:key];
}

-(void)connection:(BDConnection *)connection finishedWithDictionary:(NSDictionary *)dictionary error:(NSError *)error
{
    //    self.block(
}

- (void)incrementKey:(NSString *)key amountBy:(double)amount
{
    NSNumber* value = [self.fields valueForKey:key];
    if (!value)
        value = [NSNumber numberWithDouble:amount];
    else
        value = [NSNumber numberWithDouble:[value doubleValue] + amount];
    [self.fields setValue:value forKey:key];
    
}

@end
