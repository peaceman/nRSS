//
//  FeedBinApiClient.m
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "FeedBinApiClient.h"
#import "AFJSONRequestOperation.h"

@implementation FeedBinApiClient
+ (id)sharedInstance {
    static FeedBinApiClient* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FeedBinApiClient alloc] initWithBaseURL:
                          [NSURL URLWithString:kFeedBinApiBaseURLString]];
    });

    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [self setDefaultCredential:
     [NSURLCredential credentialWithUser:@"public"
                                password:@"private"
                             persistence:NSURLCredentialPersistenceForSession]];

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    return self;
}
@end
