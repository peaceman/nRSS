//
//  nRSSFeedController.h
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nRSSFeedController : UITableViewController
@property (strong, nonatomic) NSDictionary* feed;
@property (strong, nonatomic) NSArray* entries;

- (void)loadNextEntry;
@end
