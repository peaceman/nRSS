//
//  FeedBinApiClient.h
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "AFHTTPClient.h"

static NSString* const kFeedBinApiBaseURLString = @"https://api.feedbin.me/v1/";

@interface FeedBinApiClient : AFHTTPClient
+ (id)sharedInstance;
@end
